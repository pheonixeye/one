import 'package:one/models/user/user.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/models/doctor.dart';

class DoctorApi {
  const DoctorApi({required this.doc_id, required this.assistantAccountTypeId});

  final String doc_id;
  final String assistantAccountTypeId;

  static const String collection = 'doctors';

  static const String doctor_expand = 'speciality_id';

  static const _user_expandList = ['account_type_id', 'app_permissions_ids'];

  static final _user_expand = _user_expandList.join(',');

  Future<Doctor> fetchDoctorProfile() async {
    final _response = await PocketbaseHelper.pbBase
        .collection(collection)
        .getOne(doc_id, expand: doctor_expand);

    final doctor = Doctor.fromJson({
      ..._response.toJson(),
      'speciality': _response.get<RecordModel>('expand.speciality_id').toJson(),
    });

    return doctor;
  }

  Future<User> fetchDoctorAuthUser() async {
    final _response = await PocketbaseHelper.pbBase
        .collection('users')
        .getOne(doc_id, expand: _user_expand);

    final _user = User.fromRecordModel(_response);

    return _user;
  }

  Future<List<Doctor>> fetchAllDoctors() async {
    final _response = await PocketbaseHelper.pbBase
        .collection(collection)
        .getFullList(expand: doctor_expand);

    // prettyPrint(_response);
    final _doctors = _response.map((e) {
      return Doctor.fromJson({
        ...e.toJson(),
        'speciality': e.get<RecordModel>('expand.speciality_id').toJson(),
      });
    }).toList();

    return _doctors;
  }

  Future<List<User>> fetchAllDoctorsAuthAccounts() async {
    final result = await PocketbaseHelper.pbBase
        .collection('users')
        .getList(
          filter: "account_type_id != '$assistantAccountTypeId'",
          expand: _user_expand,
        );

    // prettyPrint(result);

    final _users = result.items.map((e) => User.fromRecordModel(e)).toList();

    return _users;
  }

  Future<void> toogleAccountActivation(String user_id, bool is_active) async {
    await PocketbaseHelper.pbBase
        .collection('users')
        .update(user_id, body: {'is_active': is_active});
  }
}
