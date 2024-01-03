import 'dart:convert';
import 'dart:io';

import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.logger.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:app_blood_pressure_log/enums/sort_options.dart';
import 'package:app_blood_pressure_log/model_classes/app_configs.dart';
import 'package:app_blood_pressure_log/model_classes/create_record_response.dart';
import 'package:app_blood_pressure_log/model_classes/get_app_records_response.dart';
import 'package:app_blood_pressure_log/model_classes/login_response.dart';
import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/services/app_preferences_service.dart';
import 'package:dio/dio.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked_services/stacked_services.dart';

enum _HttpMethod { get, post, put, delete }

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

  Future<bool> createAccount({
    required String email,
    required String password,
  });

  Future<bool> validateAccount({required String validationCode});

  Future<bool> fetchAppConfigs();
}

class AppNetworkService implements IAppNetworkService {
  final log = getLogger('HttpService');

  late final Dio _httpClient;
  final InterFaceAppPreferences _preferencesService =
      locator<AppPreferencesService>();

  AppNetworkService() {
    _httpClient = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: "https://blood-pressure-log.onrender.com",
        // baseUrl: "http://127.0.0.1:8000",
      ),
    );

    _httpClient.interceptors.add(DioClientInterceptor());
  }

  Future<Response> _makeHttpRequest({
    required _HttpMethod method,
    required String path,
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool verbose = false,
    bool verboseResponse = false,
    bool sendToken = true,
  }) async {
    try {
      final response = await _sendRequest(
          method: method,
          path: path,
          queryParameters: queryParameters,
          body: body,
          sendToken: sendToken);

      final statusText = 'Status Code: ${response.statusCode}';
      final responseText = 'Response Data: ${response.data}';

      if (verbose) {
        log.v('$statusText${verboseResponse ? responseText : ''}');
      }

      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.unknown && e.error is SocketException) {
        log.e(
          'This seems to be a network issue. Please check your network and try again.',
        );
        rethrow;
      }

      if (e.type == DioErrorType.connectionTimeout) {
        log.e(
          'This seems to be a network issue. Please check your network and try again.',
        );
        rethrow;
      }

      log.e(
        'A response error occurred. ${e.response?.statusCode}\nERROR: ${e.message}',
      );
      rethrow;
    } catch (e) {
      log.e('Request to $path failed. Error details: $e');
      rethrow;
    }
  }

  Future<Response> _uploadFile({
    required File file,
    required String fileName,
    Map<String, dynamic> queryParameters = const {},
    bool sendToken = true,
    bool verboseResponse = false,
  }) async {
    Options? requestOption;
    try {
      if (sendToken) {
        requestOption = Options(
          headers: {
            "Authorization": "Bearer ${_preferencesService.fetchToken()}"
          },
        );
      }
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _httpClient.post(
        "/upload",
        queryParameters: queryParameters,
        options: requestOption,
        data: formData,
      );

      final statusText = 'Status Code: ${response.statusCode}';
      final responseText = 'Response Data: ${response.data}';

      if (verboseResponse) {
        log.v('$statusText${verboseResponse ? responseText : ''}');
      }

      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.unknown && e.error is SocketException) {
        log.e(
          'This seems to be a network issue. Please check your network and try again.',
        );
        rethrow;
      }

      if (e.type == DioErrorType.connectionTimeout) {
        log.e(
          'This seems to be a network issue. Please check your network and try again.',
        );
        rethrow;
      }

      log.e(
        'A response error occurred. ${e.response?.statusCode}\nERROR: ${e.message}',
      );
      rethrow;
    } catch (e) {
      log.e('Request to \"/upload\" failed. Error details: $e');
      rethrow;
    }
  }

  Future<Response> _sendRequest({
    required _HttpMethod method,
    required String path,
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool sendToken = true,
  }) async {
    Response response;
    Options? requestOption;
    if (sendToken) {
      requestOption = Options(
        headers: {
          "Authorization": "Bearer ${_preferencesService.fetchToken()}"
        },
      );
    }

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
    Response response = await _makeHttpRequest(
      method: _HttpMethod.post,
      path: "/save_record",
      body: record.toCreateRecordJson(),
    );
    CreateRecordResponse createRecordResponse =
        CreateRecordResponse.fromJson(response.data);
    if (imageFile != null) {
      return await _uploadRecordImage(
        recordId: createRecordResponse.id,
        imageFile: imageFile,
      );
    } else {
      return createRecordResponse.id > 0;
    }
  }

  @override
  Future<bool> deleteRecord({
    required int recordId,
  }) async {
    // return serverpodClient.client.record.deleteRecord(recordId);
    return true;
  }

  @override
  Future<Map<String, List<Records>>> getRecords({
    int limit = 30,
    int page = 0,
    option = SortOptions.orderByDateAsc,
  }) async {
    Response apiResponse = await _makeHttpRequest(
      method: _HttpMethod.get,
      path: "/get_records",
      sendToken: true,
    );

    List<Records> records = getAllRecordsFromJson(
      json.encode(
        apiResponse.data,
      ),
    );
    Map<String, List<Records>> dateFormattedList = {};

    for (var singleDate in records.map((e) => e.logTime).toSet()) {
      dateFormattedList.putIfAbsent(
        DateTimeToStringConverter.ddMMMMyyyy(date: singleDate ?? DateTime.now())
            .convert(),
        () => records
            .where(
              (element) =>
                  DateTimeToStringConverter.ddMMMMyyyy(
                          date: element.logTime ?? DateTime.now())
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
    return true;
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
      path: "/token",
      body: {"email": userName, "password": password},
      sendToken: false,
    );

    LoginResponse loginResponse = LoginResponse.fromJson(response.data);

    if (loginResponse.accessToken.isNotEmpty) {
      _preferencesService.saveToken(token: loginResponse.accessToken);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> createAccount({
    required String email,
    required String password,
  }) async {
    Response response = await _makeHttpRequest(
        method: _HttpMethod.post,
        path: '/register',
        sendToken: false,
        body: {"email": email, "password": password});

    return response.statusCode == 201;
  }

  @override
  Future<bool> validateAccount({required String validationCode}) async {
    Response response = await _makeHttpRequest(
      method: _HttpMethod.get,
      path: "/verify/$validationCode",
      sendToken: false,
    );

    return response.statusCode == 200;
  }

  Future<bool> _uploadRecordImage(
      {required int recordId, required File imageFile}) async {
    Response response = await _uploadFile(queryParameters: {
      "record_id": recordId,
    }, file: imageFile, fileName: 'image_record_${recordId}_${DateTime.now()}');
    return response.statusCode == 201;
  }

  @override
  Future<bool> fetchAppConfigs() async {
    Response apiResponse = await _makeHttpRequest(
      method: _HttpMethod.get,
      path: "/app_configs",
      sendToken: false,
    );

    AppConfigs appConfig = AppConfigs.fromJson(apiResponse.data);

    _preferencesService.saveImageToken(token: appConfig.token);

    return true;
  }
}

class DioClientInterceptor extends QueuedInterceptorsWrapper {
  final log = getLogger('DioClientInterceptor');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? token = locator<AppPreferencesService>().fetchToken();
    getLogger('TOKEN').wtf(token);
    options.headers.putIfAbsent('Authorization', () => token);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.badResponse) {
      if (err.response?.statusCode == 401) {
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
    } else {
      log.e(err.toString());
      super.onError(err, handler);
    }
  }
}
