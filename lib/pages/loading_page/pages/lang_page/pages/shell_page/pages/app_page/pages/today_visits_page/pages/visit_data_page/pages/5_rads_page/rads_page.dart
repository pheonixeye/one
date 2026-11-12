import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_rads.dart';
import 'package:one/models/preset.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/5_rads_page/widgets/rads_desktop_view.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/5_rads_page/widgets/rads_mobile_view.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_presets.dart';
import 'package:one/providers/px_profile_items/px_pi_rads.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class VisitRadsPage extends StatefulWidget {
  const VisitRadsPage({super.key});

  @override
  State<VisitRadsPage> createState() => _VisitRadsPageState();
}

class _VisitRadsPageState extends State<VisitRadsPage>
    with TickerProviderStateMixin {
  final ValueNotifier<bool> _isPresetsVisible = ValueNotifier<bool>(true);

  final ValueNotifier<List<String>> _visitRadsState =
      ValueNotifier<List<String>>(
        [],
      );

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  )..repeat(reverse: true); // Repeats back and forth indefinitely

  late final AnimationController _bottomSheetController = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );

  late final _colorAnimation = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  ).animate(_controller);

  late final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _bottomSheetController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addPiRad(String id) {
    _visitRadsState.value = [..._visitRadsState.value, id];
  }

  void _removePiRad(String id) {
    final _current = _visitRadsState.value;
    final _index = _current.indexOf(id);
    _current.removeAt(_index);
    _visitRadsState.value = [..._current];
  }

  void _setPiRadsFromPreset(List<String> radsIds) {
    _visitRadsState.value = [...radsIds];
  }

  void _toogleIsPresetsVisible() {
    _isPresetsVisible.value = !_isPresetsVisible.value;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxPiRads, PxVisitData, PxPresets, PxLocale>(
      builder: (context, rb, v, p, l, _) {
        while (v.result == null || rb.rads == null || p.result == null) {
          return const CentralLoading();
        }

        while (v.result is ApiErrorResult ||
            rb.rads is ApiErrorResult ||
            p.result is ApiErrorResult) {
          return CentralError(
            code: (v.result as ApiErrorResult).errorCode,
            toExecute: () async {
              v.retry();
              rb.retry();
              p.retry();
            },
          );
        }
        final _piRads = (rb.filteredRads as ApiDataResult<List<PiRad>>).data;

        final _presets = (p.result as ApiDataResult<List<Preset>>).data;

        final _radPresets = _presets
            .where((e) => e.type == PresetType.rad)
            .toList();

        final _data = (v.result as ApiDataResult<VisitData>).data;

        final _visit_rads = _data.rads;

        _visitRadsState.value = [
          ..._visit_rads.map((l) => l.id),
        ];

        final _infoHeader = Builder(
          builder: (context) {
            return VisitDetailsPageInfoHeader(
              patient: _data.patient,
              title: context.loc.visitLabs,
              iconData: FontAwesomeIcons.droplet,
            );
          },
        );
        return Scaffold(
          body: Builder(
            builder: (context) {
              if (context.isMobile) {
                return RadsMobileView(
                  infoHeader: _infoHeader,
                  rb: rb,
                  bottomSheetController: _bottomSheetController,
                  visitRadsState: _visitRadsState,
                  p: p,
                  radsPresets: _radPresets,
                  visitRads: _visit_rads,
                  piRads: _piRads,
                  colorAnimation: _colorAnimation,
                  v: v,
                  data: _data,
                  setPiRadsFromPreset: _setPiRadsFromPreset,
                  addPiRad: _addPiRad,
                  removePiRad: _removePiRad,
                  searchController: _searchController,
                );
              }
              //desktop & tablet
              return RadsDesktopView(
                infoHeader: _infoHeader,
                rb: rb,
                bottomSheetController: _bottomSheetController,
                visitRadsState: _visitRadsState,
                p: p,
                radsPresets: _radPresets,
                visitRads: _visit_rads,
                piRads: _piRads,
                colorAnimation: _colorAnimation,
                v: v,
                data: _data,
                setPiRadsFromPreset: _setPiRadsFromPreset,
                addPiRad: _addPiRad,
                removePiRad: _removePiRad,
                isPresetsVisible: _isPresetsVisible,
                toogleIsPresetsVisible: _toogleIsPresetsVisible,
                searchController: _searchController,
              );
            },
          ),
        );
      },
    );
  }
}
