import 'dart:convert';
import 'dart:io';

import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.logger.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:app_blood_pressure_log/enums/api_endpoints.dart';
import 'package:app_blood_pressure_log/enums/sort_options.dart';
import 'package:app_blood_pressure_log/model_classes/account_create_response.dart';
import 'package:app_blood_pressure_log/model_classes/api_error.dart';
import 'package:app_blood_pressure_log/model_classes/app_configs.dart';
import 'package:app_blood_pressure_log/model_classes/create_record_response.dart';
import 'package:app_blood_pressure_log/model_classes/get_app_records_response.dart';
import 'package:app_blood_pressure_log/model_classes/logged_in_user.dart';
import 'package:app_blood_pressure_log/model_classes/login/login_response.dart';
import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/services/app_permissions_service.dart';
import 'package:app_blood_pressure_log/services/app_preferences_service.dart';
import 'package:app_blood_pressure_log/services/push_notifications_service.dart';
import 'package:app_blood_pressure_log/ui/common/validation_checks.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:helper_package/helper_package.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

enum _HttpMethod { get, post, put, delete, multiPart }

abstract class IAppNetworkService {
  Future<bool> createRecord({
    required Records record,
    File? imageFile,
  });

  Future<bool> deleteRecord({required int recordId});

  Future<bool> updateRecord({required Records record});

  Future<Map<String, List<Records>>> getRecords({
    int limit = 30,
    int page = 0,
  });

  bool isUserLoggedIn();

  Future<bool> logout();

  Future<bool> loginUser({required String userName, required String password});

  Future<AccountCreateResponse> createAccount({
    required String email,
    required String password,
  });

  Future<bool> validateAccount({required String validationCode});

  Future<bool> fetchAppConfigs();

  Future<LoggedInUser> fetchLoggedInUserDetails();

  void saveFcmToken({String? token});

  Future<String> isUserNameAvailable({required String userName});
}

class AppNetworkService implements IAppNetworkService {
  final String baseUrl = "http://192.168.1.15:8000";
  final log = getLogger('HttpService');
  final InterFaceAppPreferences _preferencesService =
      locator<AppPreferencesService>();
  late final Dio _httpClient;

  AppNetworkService() {
    _httpClient = Dio(
      BaseOptions(
        connectTimeout: const Duration(minutes: 2),
        receiveDataWhenStatusError: true,
        baseUrl: baseUrl,
      ),
    );
    _httpClient.interceptors.add(
      TokenInterceptor(
        baseUrl: baseUrl,
      ),
    );
  }

  Future<Response> _makeHttpRequest({
    required _HttpMethod method,
    required String path,
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> body = const {},
    FormData? formData,
    bool verbose = false,
    bool verboseResponse = false,
    bool sendToken = true,
  }) async {
    try {
      final response = await _sendRequest(
        formData: formData,
        method: method,
        path: path,
        queryParameters: queryParameters,
        body: body,
      );

      final statusText = 'Status Code: ${response.statusCode}';
      final responseText = 'Response Data: ${response.data}';

      if (verbose) {
        log.v('$statusText${verboseResponse ? responseText : ''}');
      }

      return response;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.unknown &&
          error.error is SocketException) {
        log.e(
          'This seems to be a network issue. Please check your network and try again.',
        );
        rethrow;
      }

      if (error.type == DioExceptionType.connectionTimeout) {
        log.e(
          'This seems to be a network issue. Please check your network and try again.',
        );
        rethrow;
      }

      log.e(
        'A response error occurred. ${error.response?.statusCode}\nERROR: ${error.message}',
      );
      rethrow;
    } catch (e) {
      log.e('Request to $path failed. Error details: $e');
      rethrow;
    }
  }

  Future<Response> _sendRequest({
    required _HttpMethod method,
    required String path,
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> body = const {},
    FormData? formData,
  }) async {
    Response response;
    Options? requestOption;

    switch (method) {
      case _HttpMethod.post:
        response = await _httpClient.post(
          path,
          queryParameters: queryParameters,
          data: body,
          options: requestOption,
        );
        break;
      case _HttpMethod.put:
        response = await _httpClient.put(
          path,
          queryParameters: queryParameters,
          data: body,
          options: requestOption,
        );
        break;
      case _HttpMethod.delete:
        response = await _httpClient.delete(
          path,
          queryParameters: queryParameters,
          options: requestOption,
        );
        break;
      case _HttpMethod.multiPart:
        response = await _httpClient.post(
          path,
          options: requestOption,
          data: formData,
        );
      case _HttpMethod.get:
      default:
        response = await _httpClient.get(
          options: requestOption,
          path,
          queryParameters: queryParameters,
        );
    }

    return response;
  }

  @override
  Future<bool> createRecord({
    required Records record,
    File? imageFile,
  }) async {
    var formData = FormData.fromMap({
      "diastolic_value": record.diastolicValue,
      "systolic_value": record.systolicValue,
      "image": imageFile == null
          ? ""
          : await MultipartFile.fromFile(imageFile!.path,
              filename:
                  "${record.systolicValue}_${record.diastolicValue}_${DateTime.now()}")
    });

    Response response = await _makeHttpRequest(
        method: _HttpMethod.multiPart,
        path: ApiEndPoints.saveRecord.url,
        formData: formData,
        sendToken: true);

    CreateRecordResponse createRecordResponse =
        CreateRecordResponse.fromJson(response.data);

    return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<bool> deleteRecord({
    required int recordId,
  }) async {
    Response response = await _makeHttpRequest(
      method: _HttpMethod.delete,
      path: "${ApiEndPoints.deleteRecord.url}$recordId",
      sendToken: true,
    );

    return response.statusCode == HttpStatus.ok;
  }

  @override
  Future<Map<String, List<Records>>> getRecords({
    int limit = 30,
    int page = 0,
    option = SortOptions.orderByDateAsc,
  }) async {
    Response apiResponse = await _makeHttpRequest(
      method: _HttpMethod.get,
      path: ApiEndPoints.getRecords.url,
      sendToken: true,
    );

    List<Records> records = getAllRecordsFromJson(
      json.encode(
        apiResponse.data,
      ),
    );
    Map<String, List<Records>> dateFormattedList = {};

    for (var singleDate in records.map((e) => e.logDate).toSet()) {
      dateFormattedList.putIfAbsent(
        DateTimeToStringConverter.ddMMMMyyyy(date: singleDate ?? DateTime.now())
            .convert(),
        () => records
            .where(
              (element) =>
                  DateTimeToStringConverter.ddMMMMyyyy(
                          date: element.logDate ?? DateTime.now())
                      .convert() ==
                  DateTimeToStringConverter.ddMMMMyyyy(
                          date: singleDate ?? DateTime.now())
                      .convert(),
            )
            .toList(),
      );
    }

    return dateFormattedList;
  }

  @override
  Future<bool> updateRecord({
    required Records record,
  }) async {
    Response response = await _makeHttpRequest(
        method: _HttpMethod.put,
        path: ApiEndPoints.updateRecord.url,
        body: record.toJson());

    return response.statusCode == HttpStatus.ok;
  }

  @override
  bool isUserLoggedIn() {
    return true;
  }

  @override
  Future<bool> logout() async {
    _preferencesService.logout();
    return true;
  }

  @override
  Future<bool> loginUser({
    required String userName,
    required String password,
  }) async {
    Response response = await _makeHttpRequest(
      method: _HttpMethod.post,
      path: ApiEndPoints.login.url,
      body: {"email": userName, "password": password},
      sendToken: false,
    );

    LoginResponse loginResponse = LoginResponse.fromJson(response.data);

    if (loginResponse.accessToken.isNotEmpty) {
      _preferencesService.saveTokens(loginResponse: loginResponse);
      final fcmToken =
          await locator<PushNotificationsService>().fetchFcmToken();



      if (locator<PushNotificationsService>()
              .settings?.authorizationStatus  == AuthorizationStatus.authorized) {
        saveFcmToken(token: fcmToken);
      }

      return true;
    } else {
      return false;
    }
  }

  @override
  Future<AccountCreateResponse> createAccount({
    required String email,
    required String password,
  }) async {
    Response response = await _makeHttpRequest(
      method: _HttpMethod.post,
      path: ApiEndPoints.createAccount.url,
      sendToken: false,
      body: {
        "email": email,
        "password": password,
      },
    );

    AccountCreateResponse accountCreateResponse = AccountCreateResponse.fromMap(
      response.data,
    );

    return accountCreateResponse;
  }

  @override
  Future<bool> validateAccount({required String validationCode}) async {
    Response response = await _makeHttpRequest(
      method: _HttpMethod.get,
      path: "${ApiEndPoints.validateAccount.url}$validationCode",
      sendToken: false,
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> fetchAppConfigs() async {
    Response apiResponse = await _makeHttpRequest(
      method: _HttpMethod.get,
      path: ApiEndPoints.fetchAppConfigs.url,
      sendToken: false,
    );

    AppConfigs appConfig = AppConfigs.fromJson(apiResponse.data);

    _preferencesService.saveImageToken(token: appConfig.token);

    return true;
  }

  @override
  Future<LoggedInUser> fetchLoggedInUserDetails() async {
    Response response = await _makeHttpRequest(
        method: _HttpMethod.get,
        path: ApiEndPoints.fetchUserDetails.url,
        sendToken: true);
    return LoggedInUser(userid: response.data['user_id']);
  }

  @override
  void saveFcmToken({String? token}) async {
    await _makeHttpRequest(
        method: _HttpMethod.post,
        path: ApiEndPoints.saveFcmToken.url,
        sendToken: true,
        body: {"token": token});
  }

  @override
  Future<String> isUserNameAvailable({required String userName}) async {
    Response response = await _makeHttpRequest(
      method: _HttpMethod.post,
      path: ApiEndPoints.isUserNameAvailable.url,
      sendToken: false,
      body: {"user_name": userName},
    );

    ApiError error = ApiError.fromMap(response.data);
    return error.detail;
  }
}

class TokenInterceptor extends Interceptor {
  final String baseUrl;
  late final Dio _dio;
  final InterFaceAppPreferences _preferencesService =
      locator<AppPreferencesService>();

  TokenInterceptor({required this.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (ApiEndPoints.none.isTokenRequired(
        apiEndPoint:
            ApiEndPoints.none.getApiEndPointFromUrl(path: options.path))) {
      options.headers['Authorization'] =
          'Bearer ${_preferencesService.fetchToken()?.accessToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      try {
        final Response refreshedToken = await _dio.post(
            ApiEndPoints.refreshToken.url,
            data: {"token": _preferencesService.fetchToken()?.refreshToken});

        LoginResponse loginResponse =
            LoginResponse.fromJson(refreshedToken.data);
        _preferencesService.saveTokens(loginResponse: loginResponse);
        // Retry the request with the new token
        // Update the request header with the new access token
        err.requestOptions.headers['Authorization'] =
            'Bearer ${loginResponse.accessToken}';

        // Repeat the request with the updated header
        return handler.resolve(await _dio.fetch(err.requestOptions));
      } on DioException catch (error) {
        if (error.type == DioExceptionType.badResponse) {
          if (error.response?.statusCode == HttpStatus.unauthorized) {
            locator<DialogService>()
                .showConfirmationDialog(
                    barrierDismissible: false,
                    confirmationTitle: 'Sure',
                    title: 'Login Expired.',
                    description:
                        'Your login has expired. You will have to login again.')
                .then(
              (value) {
                locator<AppPreferencesService>().logout();
                locator<NavigationService>().replaceWithLoginView();
              },
            );
          }
        }
        // handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
