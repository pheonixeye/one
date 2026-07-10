import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/clinic_inventory_api.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/pi_supply_item.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/7_supplies_page/supply_item_tile.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:one/providers/px_clinic_inventory.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_profile_items/px_pi_supplies.dart';
import 'package:one/providers/px_visit_data.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitSuppliesPage extends StatelessWidget {
  const VisitSuppliesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<PxPiSupplies, PxVisitData, PxLocale>(
        builder: (context, s, v, l, _) {
          return Builder(
            builder: (context) {
              while (v.result == null || s.supplyItems == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult ||
                  s.supplyItems is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: () async {
                    v.retry();
                    s.retry();
                  },
                );
              }
              final _supply_items =
                  (s.filteredSupplyItems as ApiDataResult<List<PiSupplyItem>>)
                      .data;

              final _data = (v.result as ApiDataResult<VisitData>).data;

              return Column(
                children: [
                  Builder(
                    builder: (context) {
                      return VisitDetailsPageInfoHeader(
                        patient:
                            (v.result as ApiDataResult<VisitData>).data.patient,
                        title: context.loc.visitSupplies,
                        iconData: FontAwesomeIcons.warehouse,
                      );
                    },
                  ),
                  Card.outlined(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText:
                                    context.loc.searchByEnglishOrArabicItemName,
                              ),
                              onChanged: (value) {
                                s.searchForItems(value);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: SmBtn(
                              tooltip: context.loc.clearSearch,
                              backgroundColor: Colors.red.shade200,
                              onPressed: () {
                                s.clearSearch();
                              },
                              child: const Icon(Icons.refresh),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ChangeNotifierProvider(
                      create: (context) {
                        final clinic_id = _data.clinic_id;
                        return PxClinicInventory(
                          api: ClinicInventoryApi(clinic_id: clinic_id),
                        );
                      },
                      child: ListView.builder(
                        itemCount: _supply_items.length,
                        itemBuilder: (context, index) {
                          final _supply_item = _supply_items[index];
                          return Card.outlined(
                            elevation: 6,
                            child: SupplyItemTile(
                              item: _supply_item,
                              index: index,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
