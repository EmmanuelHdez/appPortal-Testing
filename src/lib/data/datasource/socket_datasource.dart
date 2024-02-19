import 'package:socket_io_client/socket_io_client.dart';
import 'package:src/config/config.dart';
import 'package:src/shared/shared_preferences.dart';

class SocketDatasource {
  final Socket socket;

  SocketDatasource(this.socket);

  void connectAndJoinRoom(String room) async {
    int patientId = await MySharedPreferences.instance.getIntValue(PATIENT_ID);
    socket.connect();
    socket.onConnect((_) {
      socket.emit(room, patientId);
      print("Connection socket created for $patientId");
    });
  }

  void emitEvent(String event, dynamic data) {
    socket.emit(event, data);
  }

  void onEvent(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void disconnect() {
    socket.dispose();
  }
}
