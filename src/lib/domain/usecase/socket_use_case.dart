
import 'package:src/domain/repository/socket_repository.dart';

class ConnectSocketUseCase {
  final SocketRepository socketRepository;

  ConnectSocketUseCase(this.socketRepository);

  void call(String room) {
    socketRepository.connectAndJoinRoom(room);
  }
}

class EmitEventUseCase {
  final SocketRepository socketRepository;

  EmitEventUseCase(this.socketRepository);

  void call(String event, dynamic data) {
    socketRepository.emitEvent(event, data);
  }
}

class OnEventUseCase {
  final SocketRepository socketRepository;

  OnEventUseCase(this.socketRepository);

  void call(String event, Function(dynamic) callback) {
    socketRepository.onEvent(event, callback);
  }
}

class DisconnectSocketUseCase {
  final SocketRepository socketRepository;

  DisconnectSocketUseCase(this.socketRepository);

  void call() {
    socketRepository.disconnect();
  }
}