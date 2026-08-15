import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_log/dio_log.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/interceptor/error_interceptor.dart';

class NetworkManager {
  late final Dio dio;

  NetworkManager._internal() {
    dio = Dio(_baseOptions());
    _addInterceptors();

    // Create a custom SecurityContext
    final SecurityContext securityContext = SecurityContext(
      withTrustedRoots: true,
    );
    securityContext.allowLegacyUnsafeRenegotiation =
        true; // Enable insecure renegotiation [6]

    // Create an HttpClient with the custom context
    final HttpClient httpClient = HttpClient(context: securityContext);
    // if (kDebugMode) { // disable it if in release and server SSL already work
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    // }

    // Set the adapter to use the custom HttpClient
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => httpClient,
    );
  }

  BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: Env.apiBaseUrl,
      // connectTimeout: const Duration(seconds: 15),
      // receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      sendTimeout: Duration(seconds: 5),
    );
  }

  void _addInterceptors() {
    dio.interceptors.addAll([
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
      if (kDebugMode) DioLogInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  static final NetworkManager _instance = NetworkManager._internal();

  factory NetworkManager() => _instance;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) async {
    final response = await dio.get(path, queryParameters: query);
    return parser != null ? parser(response.data) : response.data;
  }

  Future<T> post<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? parser,
  }) async {
    final response = await dio.post(path, data: body);
    return parser != null ? parser(response.data) : response.data;
  }

  Future download(
    String url,
    String savePath,
    Function(double progress)? result,
  ) async {
    // 3. Use Dio to download the file
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (count, total) {
        // You can use this callback to update a progress bar in your UI
        debugPrint(
          'Download progress: ${(count / total * 100).toStringAsFixed(0)}%',
        );
        result?.call((count / total * 100));
      },
    );
  }

  // Future<void> downloadFile(String url, String fileName) async {
  //   try {
  //     // 1. Request permissions (if necessary)
  //     if (Platform.isAndroid || Platform.isIOS) {
  //       var status = await Permission.storage.request();
  //       if (!status.isGranted) {
  //         print('Permission denied');
  //         return;
  //       }
  //     }

  //     // 2. Get the local storage path
  //     // getApplicationDocumentsDirectory() is suitable for app-specific storage
  //     // For saving to public directories like "Downloads", more complex logic is needed (see path_provider docs)
  //     final directory = await getApplicationDocumentsDirectory();
  //     final savePath = '${directory.path}/Downloads/$fileName';

  //     // 3. Use Dio to download the file
  //     await dio.download(
  //       url,
  //       savePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           // You can use this callback to update a progress bar in your UI
  //           print(
  //               'Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
  //         }
  //       },
  //     );

  //     print('File downloaded to: $savePath');
  //   } on DioException catch (e) {
  //     print('Download error: $e');
  //   } catch (e) {
  //     print('An error occurred: $e');
  //   }
  // }
}

class APIRoute {
  static String get login => "LoginUser";
  static String get transactions => "GetListTransaction";

  static String get outTransaction => "SetOutTransaction";
  static String get returnTransaction => "SetReturnTransaction";
  static String get destroyTransaction => "SetDestroyTransaction";
  static String get moveItemBoxTransaction => "setMoveItem2Box";
  static String get moveBoxRackTransaction => "SetMoveBox2Rack";
  static String get moveBoxTransaction => "SetMoveBox2Box";

  static String get userInfo => "GetUserInfo";
  static String get departmentInfo => "GetDeptList";
  static String get reasonInfo => "GetBrokenReasonList";
  static String get itemInfo => "GetLabelidInfo";

  static String get itemHistoryInfo => "GetLabelidHistory";
  static String get itemInsideInfo => "GetLabelidInthe";

  static String get userReport => "GetTodayReport";
}
