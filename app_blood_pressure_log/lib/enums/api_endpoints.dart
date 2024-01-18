
mixin ApiEndPointsOperations{
  ApiEndPoints getApiEndPointFromUrl({required String path}) => ApiEndPoints.none;
  bool isTokenRequired({required ApiEndPoints apiEndPoint}) => false;
}

enum ApiEndPoints with ApiEndPointsOperations{
  saveRecord('/save_record'),
  deleteRecord('/delete_record'),
  getRecords('/get_records'),
  updateRecord('update_record'),
  login('/token'),
  createAccount('/register'),
  validateAccount('/verify/'),
  fetchAppConfigs('/app_configs'),
  fetchUserDetails('/user'),
  saveFcmToken('/saveFcmToken'),
  isUserNameAvailable('/user_name_available'),
  refreshToken('/token_refresh'),
  none('');

  const ApiEndPoints(this.url);

  final String url;

  @override
  ApiEndPoints getApiEndPointFromUrl({required String path}) {
    if (path == ApiEndPoints.saveRecord.url) {
      return ApiEndPoints.saveRecord;
    } else if (path == ApiEndPoints.deleteRecord.url) {
      return ApiEndPoints.deleteRecord;
    } else if (path == ApiEndPoints.getRecords.url) {
      return ApiEndPoints.getRecords;
    } else if (path == ApiEndPoints.updateRecord.url) {
      return ApiEndPoints.updateRecord;
    } else if (path == ApiEndPoints.login.url) {
      return ApiEndPoints.login;
    } else if (path == ApiEndPoints.createAccount.url) {
      return ApiEndPoints.createAccount;
    } else if (path == ApiEndPoints.validateAccount.url) {
      return ApiEndPoints.validateAccount;
    } else if (path == ApiEndPoints.fetchAppConfigs.url) {
      return ApiEndPoints.fetchAppConfigs;
    } else if (path == ApiEndPoints.fetchUserDetails.url) {
      return ApiEndPoints.fetchUserDetails;
    } else if (path == ApiEndPoints.saveFcmToken.url) {
      return ApiEndPoints.saveFcmToken;
    } else if (path == ApiEndPoints.isUserNameAvailable.url) {
      return ApiEndPoints.isUserNameAvailable;
    } else {
      return ApiEndPoints.refreshToken;
    }
  }

  @override
  bool isTokenRequired({required ApiEndPoints apiEndPoint}) {
    switch (apiEndPoint) {
      case ApiEndPoints.saveRecord:
      case ApiEndPoints.deleteRecord:
      case ApiEndPoints.getRecords:
      case ApiEndPoints.updateRecord:
      case ApiEndPoints.createAccount:
      case ApiEndPoints.fetchUserDetails:
      case ApiEndPoints.saveFcmToken:
        return true;

      case ApiEndPoints.login:
      case ApiEndPoints.validateAccount:
      case ApiEndPoints.fetchAppConfigs:
      case ApiEndPoints.isUserNameAvailable:
      case ApiEndPoints.refreshToken:
      case ApiEndPoints.none:
        return false;
    }

  }
}
