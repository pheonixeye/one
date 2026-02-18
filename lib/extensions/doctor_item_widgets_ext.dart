import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/doctor_doument_type.dart';
import 'package:one/models/doctor_items/doctor_drug_item.dart';
import 'package:one/models/doctor_items/doctor_lab_item.dart';
import 'package:one/models/doctor_items/doctor_procedure_item.dart';
import 'package:one/models/doctor_items/doctor_rad_item.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

extension WxDoctorDrugItem on DoctorDrugItem {
  ///item view card extention to display items in a column
  Widget viewWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.drugFormAndConcentration}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: '$concentration $unit $form',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.drugDefaultDoses}',
              children: [
                TextSpan(text: ' :\n'),
                ...default_doses.map(
                  (e) => TextSpan(
                    text: '(${default_doses.indexOf(e) + 1}) $e\n',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  Widget createEditWidget(BuildContext context) {
    return const SizedBox();
  }
}

extension WxDoctorLabItem on DoctorLabItem {
  Widget viewWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.labSpecialInstructions}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: special_instructions,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  Widget createEditWidget(BuildContext context) {
    return const SizedBox();
  }
}

extension LocalizedString on RadiologyType {
  String localizedString(BuildContext context) {
    final _isEnglish = context.read<PxLocale>().isEnglish;
    return _isEnglish ? type_en : type_ar;
  }
}

extension WxDoctorRadItem on DoctorRadItem {
  Widget viewWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.radiologyType}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: type.localizedString(context),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.radSpecialInstructions}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: special_instructions,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  Widget createEditWidget(BuildContext context) {
    return const SizedBox();
  }
}

extension WxDoctorSupplyItem on DoctorSupplyItem {
  Widget viewWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.supplyItemUnit}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: context.read<PxLocale>().isEnglish ? unit_en : unit_ar,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.reorderQuantity}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: '$reorder_quantity',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.transferQuantity}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: '$transfer_quantity',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.buyingPrice}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: '$buying_price ${context.loc.egp}',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.sellingPrice}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: '$selling_price ${context.loc.egp}',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.notifyOnReorder}',
              children: [
                TextSpan(text: ' : '),
                WidgetSpan(
                  child: Icon(
                    notify_on_reorder_quantity ? Icons.check : Icons.close,
                    color: notify_on_reorder_quantity
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  Widget createEditWidget(BuildContext context) {
    return const SizedBox();
  }
}

extension WxDoctorProcedureItem on DoctorProcedureItem {
  Widget viewWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.price}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: '$price ${context.loc.egp}',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.discountPercentage}',
              children: [
                TextSpan(text: ' : '),
                TextSpan(
                  text: '$discount_percentage %',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  Widget createEditWidget(BuildContext context) {
    return const SizedBox();
  }
}

extension WxDoctorDocumentTypeItem on DoctorDocumentTypeItem {
  Widget viewWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          Text.rich(
            TextSpan(
              text: '• ${context.loc.isAllowedOnPortal}',
              children: [
                TextSpan(text: ' : '),
                WidgetSpan(
                  child: is_allowed_on_portal
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  Widget createEditWidget(BuildContext context) {
    return const SizedBox();
  }
}
