mixin ApiEndPointsOperations {
  ApiEndPoints getApiEndPointFromUrl({required String path}) =>
      ApiEndPoints.none;
  bool isTokenRequired({required ApiEndPoints apiEndPoint}) => false;
}

enum ApiEndPoints with ApiEndPointsOperations {
  saveRecord('/save_record'),
  deleteRecord('/record/'),
  getRecords('/get_records'),
  updateRecord('/update_record'),
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
    if (path.contains(ApiEndPoints.saveRecord.url)) {
      return ApiEndPoints.saveRecord;
    } else if (path.contains(ApiEndPoints.deleteRecord.url)) {
      return ApiEndPoints.deleteRecord;
    } else if (path.contains(ApiEndPoints.getRecords.url)) {
      return ApiEndPoints.getRecords;
    } else if (path.contains(ApiEndPoints.updateRecord.url)) {
      return ApiEndPoints.updateRecord;
    } else if (path.contains(ApiEndPoints.login.url)) {
      return ApiEndPoints.login;
    } else if (path.contains(ApiEndPoints.createAccount.url)) {
      return ApiEndPoints.createAccount;
    } else if (path.contains(ApiEndPoints.validateAccount.url)) {
      return ApiEndPoints.validateAccount;
    } else if (path.contains(ApiEndPoints.fetchAppConfigs.url)) {
      return ApiEndPoints.fetchAppConfigs;
    } else if (path.contains(ApiEndPoints.fetchUserDetails.url)) {
      return ApiEndPoints.fetchUserDetails;
    } else if (path.contains(ApiEndPoints.saveFcmToken.url)) {
      return ApiEndPoints.saveFcmToken;
    } else if (path.contains(ApiEndPoints.isUserNameAvailable.url)) {
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
