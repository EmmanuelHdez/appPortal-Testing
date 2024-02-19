# src

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

For add an icon to the app you must run the following command
[online documentation](https://pub.dev/packages/flutter_launcher_icons)
```
flutter pub run flutter_launcher_icons
```

For change the name of the application
[online documentation](https://pub.dev/packages/change_app_package_name/install), which offers tutorials
```
flutter pub run change_app_package_name:main com.psychiatryuk.src
```

For change the icon of the application
[online documentation](https://pub.dev/packages/flutter_launcher_icons)
```
flutter pub get
flutter pub run flutter_launcher_icons
```

# API Implementation Structure
Follow these steps to implement an API:

## 1. Create the Model
Define the data model that represents the structure of the data received from the API.

// Example Model
class MyDataModel {
  // Define model properties
  // ...
}

## 2. Create the Service
Create a service class responsible for making API requests and handling responses.

// Example Service
abstract class MyApiService {
  // Implement methods for API requests
  // ...
}
class MyServiceImpl implements MyApiService {}

## 3. Create the Repository
Create a repository that acts as a bridge between the service and the use case.

// Example Repository
abstract class MyDataRepository {
  // Implement methods to retrieve data from the service
  Future<AppointmentsModel> fetchFutureAppointments(int patientId);
}

class AppointmentsRepositoryImpl extends AppointmentsRepository {
  final AppointmentsService appointmentsService;

  AppointmentsRepositoryImpl(this.appointmentsService);
    // Implement methods to retrieve data from the service
  @override
  Future<AppointmentsModel> fetchFutureAppointments(int patientId) async {
    try {
      final request = await appointmentsService.fetchFutureAppointments(patientId);
      return request;
    } catch (e) {
      throw Exception(e);
    }
  }
}

## 4. Create the Use Case
Define a use case that encapsulates the business logic for interacting with the API.
// Example Use Case
class FetchMyDataUseCase {
  final MyDataRepository repository;

  FetchMyDataUseCase(this.repository);

  // Implement methods to retrieve data from the repository
  // ...
}

## 5. Create the Bloc
Create a Bloc that manages the state of the screen. It consists of events and states (e.g., MyScreenEvent, MyScreenState).

// Example Bloc
class MyScreenBloc extends Bloc<MyScreenEvent, MyScreenState> {
  final FetchMyDataUseCase useCase;

  MyScreenBloc(this.useCase) : super(MyScreenState.initial());

 //Implement event-to-state mapping
 //...

}

## 6. Dependency Injection
Handle dependency injection. The dependency injection is added in the following folder: inyection_container.dart;

// Example Dependency Injection
Future<void> initHome() async {
  // Configure dependency injection
  // ...
}

## 7. Validate the State to Display the Data
Validate the state in the UI to display the data received from the API.
// Example UI Code
if (state is MyDataLoadedState) {
  // Display data in the UI
} else if (state is MyDataErrorState) {
  // Handle error state
}

