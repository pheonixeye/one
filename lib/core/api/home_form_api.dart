import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/models/homepage_models/form_submission_model.dart';

class HomeFormApi {
  const HomeFormApi();

  Future<void> submitForm(FormSubmission sub) async {
    await PocketbaseHelper.pbBase
        .collection('home_forms')
        .create(
          body: sub.toJson(),
        );
    //TODO: send confirmation email that form is submitted
  }
}
