import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/models/speciality.dart';

class SpecialitiesApi {
  const SpecialitiesApi();

  static const String collection = 'specialities';

  static Future<List<Speciality>> fetchSpecialities() async {
    final result = await PocketbaseHelper.pb
        .collection(collection)
        .getFullList();

    final specialities = result
        .map((e) => Speciality.fromJson(e.toJson()))
        .toList();

    return specialities;
  }
}
