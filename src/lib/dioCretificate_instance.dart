import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:http/io_client.dart';
import 'package:src/cert_loader.dart';


class CustomDioClient {
  SecurityContext _createSecurityContext() {
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(NetworkCertReader.getCert()!.buffer.asInt8List());
    return securityContext;
  }

  HttpClient _createHttpClient() {
    SecurityContext securityContext = _createSecurityContext();
    HttpClient client = HttpClient(context: securityContext);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    return client;
  }

  Dio createDioInstance() {
    HttpClient client = _createHttpClient();
    IOClient ioClient = IOClient(client);

    Dio dio = Dio();
    dio.httpClientAdapter = DefaultHttpClientAdapter(
      onHttpClientCreate: (client) {
        SecurityContext sc = _createSecurityContext();
        HttpClient httpClient = HttpClient(context: sc);
        return httpClient;
      },
    );
    return dio;
  }






}