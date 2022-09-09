import 'package:ez_tracker_app/helpers/enum.dart';
import 'package:ez_tracker_app/models/category/category_model.dart';
import 'package:ez_tracker_app/models/login/login_req_model.dart';
import 'package:ez_tracker_app/models/user/user_model.dart';
import 'package:ez_tracker_app/services/firestore_service.dart';
import 'package:ez_tracker_app/uis/widgets/app_progress_indicator.dart';
import 'package:ez_tracker_app/utils/dialog_helper.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';
import '../models/signup/singup_req_model.dart';
import 'base_provider.dart';

class AccountProvider extends BaseProvider {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  CategoryModel? _categoryModel;
  CategoryModel? get categoryModel => _categoryModel;

  Future<bool> loginWithEmailAndPassword({
    required LoginReqModel reqModel,
  }) async {
    AppProgressIndicator.show();
    final EmailSignInResults emailSignInResults =
        await firebaseAuthService.signInWithEmailAndPassword(
      email: reqModel.email ?? '',
      password: reqModel.password ?? '',
    );

    String msg = '';
    //if email and password signin is complete
    if (emailSignInResults == EmailSignInResults.signInCompleted) {
      if (firebaseAuthService.currentUser()?.uid != null) {
        await firestoreDBService.setData(
          path: FireStoreEndPoints.users +
              '/${firebaseAuthService.currentUser()?.uid}',
          data: reqModel.toParam(
            userId: firebaseAuthService.currentUser()!.uid,
          ),
          withMerge: true,
        );
        AppProgressIndicator.dismiss();
      }
    } else if (emailSignInResults == EmailSignInResults.emailNotVerified) {
      msg = 'Email not verified \nPlease verify your email and retry';
    } else if (emailSignInResults ==
        EmailSignInResults.emailOrPasswordInvalid) {
      msg = 'Email or pasword is invalid';
    } else {
      msg = "sign in not completed";
    }

    if (msg != '') {
      AppProgressIndicator.dismiss();
      await DialogHelper.showOkDialog(message: msg);
      return false;
    }
    return true;
  }

  Future<bool> signUpWithEmailAndPassword({
    required SignUpReqModel reqModel,
  }) async {
    AppProgressIndicator.show();
    final EmailSignUpResults response = await firebaseAuthService.signUpAuth(
      email: reqModel.email ?? '',
      password: reqModel.password ?? '',
    );
    AppProgressIndicator.dismiss();
    //if signup is completed
    if (response == EmailSignUpResults.signUpCompleted) {
      if (firebaseAuthService.currentUser()?.uid != null) {
        await firestoreDBService.setData(
          path: FireStoreEndPoints.users +
              '/${firebaseAuthService.currentUser()?.uid}',
          data: reqModel.toParam(
            userId: firebaseAuthService.currentUser()!.uid,
          ),
        );
      }
      await DialogHelper.showOkDialog(
        message: 'Email verification link has been sent',
      );
      return true;
    } else {
      final String msg = response == EmailSignUpResults.signUpNotCompleted
          ? 'Sign up not completed'
          : 'Email has been used. Login instead';
      await DialogHelper.showOkDialog(title: msg, message: msg);
      return false;
    }
  }

  Future<bool> checkFirebaseUserAndFetchData() async {
    if (firebaseAuthService.currentUser()?.uid != null) {
      final UserModel userDetails = await firestoreDBService.documentsFuture(
        path: FireStoreEndPoints.users +
            '/${firebaseAuthService.currentUser()?.uid}',
        builder: (data, docId) {
          return UserModel.fromMap(
            data,
            docId,
          );
        },
      );
      _userModel = userDetails;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> getCategoriesData() async {
    final List<CategoryModel>? categorisList =
        await firestoreDBService.collectionFuture(
      path: FireStoreEndPoints.subCategories,
      builder: (data, _) {
        return CategoryModel.fromMap(
          data as Map<String, dynamic>,
        );
      },
    );
    _categoryModel = categorisList?.first;
    notifyListeners();
    UtilityHelper.showLog(categorisList?.first.business?.toString() ?? '');
  }
}
