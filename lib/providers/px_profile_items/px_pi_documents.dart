import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/profile_items_api/pi_document_types_api.dart';
import 'package:one/functions/contains_arabic.dart';
import 'package:one/models/doctor_items/pi_document_type.dart';

class PxPiDocuments extends ChangeNotifier {
  final PiDocumentTypesApi api;

  PxPiDocuments({required this.api}) {
    fetchDoctorItems();
  }

  ApiResult<List<PiDocumentType>>? _documentTypes;
  ApiResult<List<PiDocumentType>>? get documentTypes => _documentTypes;

  ApiResult<List<PiDocumentType>>? _filteredDocumentTypes;
  ApiResult<List<PiDocumentType>>? get filteredDocumentTypes =>
      _filteredDocumentTypes;

  Future<void> fetchDoctorItems() async {
    _documentTypes = await api.fetchDoctorItems();
    _filteredDocumentTypes = _documentTypes;
    notifyListeners();
  }

  Future<void> retry() async => await fetchDoctorItems();

  Future<void> createItem(PiDocumentType item) async {
    await api.createItem(item);
    await fetchDoctorItems();
  }

  Future<void> updateItem(String id, PiDocumentType update) async {
    await api.updateItem(id, update);
    await fetchDoctorItems();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteItem(id);
    await fetchDoctorItems();
  }

  void searchForItems(String item_name) {
    _filteredDocumentTypes = ApiDataResult(
      data: (_documentTypes as ApiDataResult<List<PiDocumentType>>).data
          .where(
            (e) => containsArabic(item_name)
                ? e.name_ar.toLowerCase().startsWith(item_name)
                : e.name_en.toLowerCase().startsWith(item_name),
          )
          .toList(),
    );
    notifyListeners();
  }

  void clearSearch() {
    _filteredDocumentTypes = _documentTypes;
    notifyListeners();
  }
}
