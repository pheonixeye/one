import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_lab.dart';
import 'package:one/models/preset.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/4_labs_page/widgets/labs_desktop_view.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/4_labs_page/widgets/labs_mobile_view.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_presets.dart';
import 'package:one/providers/px_profile_items/px_pi_labs.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class VisitLabsPage extends StatefulWidget {
  const VisitLabsPage({super.key});

  @override
  State<VisitLabsPage> createState() => _VisitLabsPageState();
}

class _VisitLabsPageState extends State<VisitLabsPage>
    with TickerProviderStateMixin {
  final ValueNotifier<bool> _isPresetsVisible = ValueNotifier<bool>(true);

  final ValueNotifier<List<String>> _visitLabsState =
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

  void _addPiLab(String id) {
    _visitLabsState.value = [..._visitLabsState.value, id];
  }

  void _removePiLab(String id) {
    final _current = _visitLabsState.value;
    final _index = _current.indexOf(id);
    _current.removeAt(_index);
    _visitLabsState.value = [..._current];
  }

  void _setPiLabsFromPreset(List<String> labsIds) {
    _visitLabsState.value = [...labsIds];
  }

  void _toogleIsPresetsVisible() {
    _isPresetsVisible.value = !_isPresetsVisible.value;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxPiLabs, PxVisitData, PxPresets, PxLocale>(
      builder: (context, lb, v, p, l, _) {
        while (v.result == null || lb.labs == null || p.result == null) {
          return const CentralLoading();
        }

        while (v.result is ApiErrorResult ||
            lb.labs is ApiErrorResult ||
            p.result is ApiErrorResult) {
          return CentralError(
            code: (v.result as ApiErrorResult).errorCode,
            toExecute: () async {
              v.retry();
              lb.retry();
              p.retry();
            },
          );
        }
        final _piLabs = (lb.filteredLabs as ApiDataResult<List<PiLab>>).data;

        final _presets = (p.result as ApiDataResult<List<Preset>>).data;

        final _labPresets = _presets
            .where((e) => e.type == PresetType.lab)
            .toList();

        final _data = (v.result as ApiDataResult<VisitData>).data;

        final _visit_labs = _data.labs;

        _visitLabsState.value = [
          ..._visit_labs.map((l) => l.id),
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
                return LabsMobileView(
                  infoHeader: _infoHeader,
                  lb: lb,
                  bottomSheetController: _bottomSheetController,
                  visitLabsState: _visitLabsState,
                  p: p,
                  labsPresets: _labPresets,
                  visitLabs: _visit_labs,
                  piLabs: _piLabs,
                  colorAnimation: _colorAnimation,
                  v: v,
                  data: _data,
                  setPiLabsFromPreset: _setPiLabsFromPreset,
                  addPiLab: _addPiLab,
                  removePiLab: _removePiLab,
                  searchController: _searchController,
                );
              }
              //desktop & tablet
              return LabsDesktopView(
                infoHeader: _infoHeader,
                lb: lb,
                bottomSheetController: _bottomSheetController,
                visitLabsState: _visitLabsState,
                p: p,
                labsPresets: _labPresets,
                visitLabs: _visit_labs,
                piLabs: _piLabs,
                colorAnimation: _colorAnimation,
                v: v,
                data: _data,
                setPiLabsFromPreset: _setPiLabsFromPreset,
                addPiLab: _addPiLab,
                removePiLab: _removePiLab,
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
