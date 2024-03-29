import 'package:http/http.dart' as http;
import 'dart:io' show Platform;


enum Format { TEXT, JSON, JSONP }

/// This queries the ipify service (http://www.ipify.org) to retrieve this
/// machine's public IP address.  Returns your public IP address as a string or
/// any error encountered.  By default, this function will run using exponential
/// as a json string, and backoff.
///
/// Usage:
/// ```dart
/// void main() async {
///   final data = await Ipify.ipv4(format: Format.JSON);
///
///   print(data);
/// }
/// ```
class DeviceInformation {
  static const String _scheme = 'https';
  static const String _hostv4 = 'api.ipify.org';
  static const String _hostv64 = 'api64.ipify.org';
  static const String _path = '/';
  static const String _format = 'format=';



  /// Simply returns an IPv4 address, the default format is a text
  ///
  /// Usage:
  /// ```dart
  /// final text = Ipify.ipv4();
  /// print(text); // 98.207.254.136
  ///
  /// final jsonText = Ipify.ipv4(format = Format.JSON);
  /// print(jsonText);  // {"ip":"98.207.254.136"}
  ///
  /// final jsonpText = Ipify.ipv4(format = Format.JSONP);
  /// print(jsonpText); // callback({"ip":"98.207.254.136"});
  /// ```
  static Future<String> ipv4({Format format = Format.TEXT}) async {
    final uri =
        Uri(host: _hostv4, path: _path, scheme: _scheme, query: _param(format));
    return await _send(uri);
  }

  /// Simply returns an IPv6 address if existed else fallback for IPv4,
  /// the default format is a text
  ///
  /// Usage:
  /// ```dart
  /// final text = Ipify.ipv64();
  /// print(text); // 98.207.254.136 or 2a00:1450:400f:80d::200e
  ///
  /// final jsonText = Ipify.ipv64(format = Format.JSON);
  /// print(jsonText);  // {"ip":"98.207.254.136"} or {"ip":"2a00:1450:400f:80d::200e"}
  ///
  /// final jsonpText = Ipify.ipv64(format = Format.JSONP);
  /// print(jsonpText); // callback({"ip":"98.207.254.136"}); or callback({"ip":"2a00:1450:400f:80d::200e"});
  /// ```
  static Future<String> ipv64({Format format = Format.TEXT}) async {
    final uri = Uri(
        host: _hostv64, path: _path, scheme: _scheme, query: _param(format));
    return await _send(uri);
  }

  static Future<String> getDeviceSO({Format format = Format.TEXT}) async {
    final os = Platform.operatingSystem;
    return os;
  }
 
  static Future<String> _send(Uri uri) async {
    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
            'Received an invalid status code from ipify: ${response.statusCode}. The service might be experiencing issues.');
      }

      return response.body;
    } catch (e) {
      throw Exception(
          "The request failed because it wasn't able to reach the ipify service. This is most likely due to a networking error of some sort.");
    }
  }

  static String _param(Format format) =>
      _format +
      (Format.TEXT == format
          ? ''
          : Format.JSON == format
              ? 'json'
              : 'jsonp');
}