import 'package:socket_io_client/socket_io_client.dart';
import 'package:src/config/config.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/shared/user_preferences.dart';

class SocketConfig {
  static Future<Socket> initializeSocket() async {
    UserPreferences userInfo = UserPreferences();
    String token = await userInfo.getToken();
    Socket socket = io(
      EnvironmentConfig.baseUrlSocket,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'token': token})
          .build(),
    );
    return socket;
  }
}
