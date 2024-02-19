
import 'package:src/data/datasource/socket_datasource.dart';

class SocketRepository {
  final SocketDatasource socketDatasource;

  SocketRepository(this.socketDatasource);

  void connectAndJoinRoom(String room) {
    socketDatasource.connectAndJoinRoom(room);
  }

  void emitEvent(String event, dynamic data) {
    socketDatasource.emitEvent(event, data);
  }

  void onEvent(String event, Function(dynamic) callback) {
    socketDatasource.onEvent(event, callback);
  }

    void disconnect() {
    socketDatasource.disconnect();
  }
}
