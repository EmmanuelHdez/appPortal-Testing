import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/config/config.dart';
import 'package:src/domain/usecase/socket_use_case.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/home_screen/home_screen.dart';
import 'package:src/presentation/appViews/forms_screen/forms_screen.dart';
import 'package:flutter/material.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/appViews/navigation_bar/bloc/navigation_bar_bloc.dart';
import 'package:src/presentation/appViews/notifications_preferences_screen/notifications_preferences_screen.dart';
import 'package:src/presentation/appViews/security_screen/pref_auth_methods_screen.dart';
import 'package:src/presentation/shared/loading_widget.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/presentation/routes/appointments_router.dart';
import 'package:src/presentation/routes/notes_router.dart';
import 'package:src/utils/size_utils.dart';
import 'package:src/shared/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatelessWidget {
  final int? index;
  const MainScreen({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<NavigationBarBloc>(),
        child: NavigationBarWidget(index: index));
  }
}

class NavigationBarWidget extends StatefulWidget {
  final int? index;
  const NavigationBarWidget({Key? key, this.index}) : super(key: key);

  @override
  State<NavigationBarWidget> createState() =>
      _NavigationBarWidgetState(this.index);
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  final int? index;
  int firstLogin = 0;
  var selectedIndex = 0;

  final ConnectSocketUseCase connectSocketUseCase = sl<ConnectSocketUseCase>();
  final EmitEventUseCase emitEventSocket = sl<EmitEventUseCase>();
  final OnEventUseCase onEventSocket = sl<OnEventUseCase>();
  final DisconnectSocketUseCase disconnectSocket =
      sl<DisconnectSocketUseCase>();
  _NavigationBarWidgetState(
    this.index,
  );
  @override
  void initState() {
    selectedIndex = index ?? 0;
    super.initState();
    connectSocketUseCase.call('joinRoom');
    newNotificationsEvent();
    removeNotificationsEvent();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await getNotificationSettings();
    });
  }

  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notification Permissions Denied'),
            content:
                Text('Allow MedQare Companion App to send you notifications?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
                child: Text('Settings'),
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _requestNotificationPermission(
      Permission permission, BuildContext context) async {
    var status = await permission.status;
    if (status.isDenied) {
      // ignore: use_build_context_synchronously
      _showPermissionDeniedDialog(context);
    } else if (status.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      _showPermissionDeniedDialog(context);
    }
  }

  Future<void> getNotificationSettings() async {
    final showconfigModal = await MySharedPreferences.instance
        .getIntValue(SHOW_CONFIG_SETTINGS_MODAL);
    if (showconfigModal == 1 && selectedIndex == 0) {
      setState(() {
        selectedIndex = 3;
        firstLogin = 1;
      });
      // ignore: use_build_context_synchronously
      _requestNotificationPermission(Permission.notification, context);
    }
  }

  // manage events 'newNotification' by patient
  void newNotificationsEvent() {
    onEventSocket.call('newNotification', (data) {
      print('Notification by socket in the room: $data');
      int counter = data['count'];
      switch (data['module']) {
        case 'Notes':
          context
              .read<NavigationBarBloc>()
              .add(const IncrementEvent(1, 0, 0, 1));
          break;
        case 'Forms':
          context
              .read<NavigationBarBloc>()
              .add(IncrementEvent(0, 0, counter, counter));
          break;
        case 'Appointments':
          context
              .read<NavigationBarBloc>()
              .add(const IncrementEvent(0, 1, 0, 1));
          break;
        default:
          context
              .read<NavigationBarBloc>()
              .add(const IncrementEvent(0, 0, 0, 0));
      }
    });
  }

  //manage events 'removeNotification' by patient
  void removeNotificationsEvent() {
    onEventSocket.call('removeNotification', (data) {
      print('Remove Notification by socket in the room : $data');
      switch (data['module']) {
        case 'Notes':
          setState(() {
            context
                .read<NavigationBarBloc>()
                .add(const DecrementEvent(1, 0, 0, 1));
          });
          break;
        case 'Forms':
          context
              .read<NavigationBarBloc>()
              .add(const DecrementEvent(0, 0, 1, 1));
          break;
        case 'Appointments':
          context
              .read<NavigationBarBloc>()
              .add(const DecrementEvent(0, 1, 0, 1));
          break;
        default:
          context
              .read<NavigationBarBloc>()
              .add(const DecrementEvent(0, 0, 0, 0));
      }
    });
  }

  @override
  void dispose() {
    disconnectSocket.call();
    super.dispose();
  }

  void _showErrorModal(String message, BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const AppointmentsRouter();
        break;
      case 2:
        page = const FormsScreen();
        break;
      case 3:
        if (firstLogin == 1) {
          page = const NotificationsPreferencesScreen(
            firstLogin: 1,
          );
        } else {
          page = const SettingsRouter();
        }
        break;
      case 4:
        page = const NotesRouter();
        break;
      default:
        page = const HomeScreen();
    }
    var selectedPage = AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: page,
    );
    return BlocListener<NavigationBarBloc, NavigationBarState>(
      listener: (context, state) {
        if (state is NavigationBarLoading) {
        } else if (state is NavigationBarError) {
          if (state.message == 401 || state.message == '401') {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LogoutScreen()),
                (Route<dynamic> route) => false,
              );
            });
          } else {
            _showErrorModal('Sorry, something went wrong', context);
          }
        }
      },
      child: BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (context, state) {
          if (state is NavigationBarInitial) {
            context.read<NavigationBarBloc>().add(const FetchNotifications());
          } else if (state is NavigationBarLoading) {
            const LoadingWidget();
          }
          return Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              body: Column(
                children: [Expanded(child: selectedPage)],
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  height: 80.0,
                  color: Colors.white,
                  padding: MediaQuery.of(context).orientation ==
                          Orientation.portrait
                      ? MediaQuery.of(context).size.width < 600
                          ? const EdgeInsets.only(
                              left: 60.0,
                              right:
                                  60.0) // Phone vertical orientation portrait
                          : const EdgeInsets.only(
                              left: 190.0,
                              right:
                                  190.0) // Tablet vertical orientation portrait
                      : MediaQuery.of(context).size.width < 1000
                          ? const EdgeInsets.only(
                              left: 200.0,
                              right: 200.0) // Phone landscape orientation
                          : const EdgeInsets.only(left: 330.0, right: 330.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBarItem(
                          color: selectedIndex == 0
                              ? const Color(0xFF6048DE)
                              : const Color(0xFF2A3786),
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          icon: const Image(
                            image: AssetImage(
                                'assets/images/app_icons/Home-White.png'),
                            width: SizeUtils.navBarIconSize,
                          ),
                          number: state.notificationsCounter),
                      CustomBarItem(
                          color: selectedIndex == 1
                              ? const Color(0xFF6048DE)
                              : const Color(0xFF2A3786),
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          icon: const Image(
                            image: AssetImage(
                                'assets/images/app_icons/Appointments-White.png'),
                            width: SizeUtils.navBarIconSize,
                          ),
                          number: state.appointmentsCounter),
                      CustomBarItem(
                        color: selectedIndex == 2
                            ? const Color(0xFF6048DE)
                            : const Color(0xFF2A3786),
                        onTap: () {
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                        icon: const Image(
                          image: AssetImage(
                              'assets/images/app_icons/Forms-White.png'),
                          width: SizeUtils.navBarIconSize,
                        ),
                        number: state.formsCounter,
                      ),
                      CustomBarItem(
                          color: selectedIndex == 4
                              ? const Color(0xFF6048DE)
                              : const Color(0xFF2A3786),
                          onTap: () {
                            setState(() {
                              selectedIndex = 4;
                            });
                          },
                          icon: const Image(
                            image: AssetImage(
                                'assets/images/app_icons/Unread-notes-White.png'),
                            width: SizeUtils.navBarIconSize,
                          ),
                          number: state.notesCounter),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}

class CustomBarItem extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final dynamic icon;
  final int? number;

  const CustomBarItem({
    super.key,
    required this.color,
    required this.onTap,
    required this.icon,
    this.number,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(child: icon),
            if (number != null && number != 0)
              Positioned(
                top: -10.0,
                right: -4.0,
                child: Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    number!.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
