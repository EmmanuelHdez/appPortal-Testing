import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/account_model.dart';
import 'package:src/presentation/appViews/account_screen/bloc/account_bloc.dart';
import 'package:src/presentation/appViews/account_screen/widgets/utils.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/shared/shared_preferences.dart';
import 'package:src/utils/app_export.dart';

class AccountWidget extends StatefulWidget {
  final AccountModel accountModel;
  const AccountWidget({Key? key, required this.accountModel}) : super(key: key);

  @override
  State<AccountWidget> createState() => _AccountWidgetState(this.accountModel);
}

class _AccountWidgetState extends State<AccountWidget> {
  final AccountModel accountModel;
  late List<Map<String, dynamic>> notificationsList;
  late List<Map<String, dynamic>> dataList;
  late String patientNameToShow;

  _AccountWidgetState(this.accountModel);

  Uint8List? _image;
  late String? _recentPhoto;

  void selectImage(BuildContext context) async {
    int userId = await MySharedPreferences.instance.getIntValue(USER_ID);
    await pickImage(ImageSource.gallery).then((f) async {
      var file = File(f!.path);
      String filePath = file.path;
      String fileName = filePath.split('/').last;
      var img = await file.readAsBytes();
      try {
        context
            .read<AccountBloc>()
            .add(UploadPhoto(userId, fileName, filePath));
        setState(() {
          _image = img;
        });
      } catch (e) {
        print('error $e');
      }
    });
  }

  _getUrlPhoto() {
    String? url = accountModel.patientInfo.recentPhoto != null
        ? accountModel.patientInfo.recentPhoto!.url
        : null;
    if (url != '') {
      List<String> keys = url!.split('/');
      String key = keys.last;
      return NetworkImage(
          '${EnvironmentConfig.serverUrl}/s3/uploads/uploads/$key');
    }
    return '';
  }

  Future _getPatientName() async {
    final patient_prefFirstName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_FIRSTNAME);

    final patient_prefmiddleName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_MIDDLENAME);

    final patient_prefLastName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_LASTNAME);

    final patientPreferredFullName =
        '$patient_prefFirstName $patient_prefmiddleName $patient_prefLastName'
            .trim();
    final cleanedPatientPreferredFullName =
        patientPreferredFullName.replaceAll(RegExp(r'\s+'), ' ');

    setState(() {
      if (cleanedPatientPreferredFullName.isNotEmpty) {
        patientNameToShow = cleanedPatientPreferredFullName;
      } else {
        patientNameToShow = accountModel.patientInfo.fullName;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    patientNameToShow = '';

    _recentPhoto = accountModel.patientInfo.recentPhoto != null
        ? accountModel.patientInfo.recentPhoto!.url
        : null;
    dataList = [
      {
        "iconData": 'assets/images/app_icons/Name.png',
        "text": "Name:",
        "value": accountModel.patientInfo.fullName
      },
      {
        "iconData": 'assets/images/app_icons/P-UK-ID.png',
        "text": "P-UK ID:",
        "value": accountModel.patientInfo.patientRef
      },
      {
        "iconData": 'assets/images/app_icons/Email.png',
        "text": "Email:",
        "value": accountModel.patientInfo.email,
      },
    ];
    notificationsList = [
      {
        "iconData": 'assets/images/app_icons/Appointments.png',
        "text": "Upcoming appointment",
        "notificationCount": accountModel.upcomingAppointments
      },
      {
        "iconData": 'assets/images/app_icons/Forms.png',
        "text": "Pending Forms",
        "notificationCount": accountModel.pendingForms
      },
      {
        "iconData": 'assets/images/app_icons/Unread-notes.png',
        "text": "Unread Portal Notes",
        "notificationCount": accountModel.unreadNotes
      },
    ];

    _getPatientName();
  }

  @override
  Widget _buildProfilePictureWidget(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          _image != null
              ? CircleAvatar(
                  radius: 55,
                  backgroundImage: MemoryImage(_image!),
                )
              : _recentPhoto != null
                  ? CircleAvatar(
                      radius: 55,
                      backgroundImage: _getUrlPhoto(),
                      backgroundColor: Colors.white,
                    )
                  : const CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/340px-Default_pfp.svg.png",
                      ),
                      backgroundColor: Colors.white,
                    ),
          Positioned(
            bottom: 3,
            left: 75,
            child: GestureDetector(
              onTap: () {
                selectImage(context);
              },
              child: Container(
                padding: const EdgeInsets.all(7.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6048DE),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImgHeaderPortrait() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomImageView(
              imagePath: ImageConstant.imgHeader, width: size.width * 1.0),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsRouter()));
            },
            child: const Icon(
              Icons.settings,
              color: Color(0xFFd1d5db),
              size: 36.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImgHeaderLandScape() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgHeader,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width < 600
                  ? null // Phone vertical orientation portrait
                  : null // Tablet vertical orientation portrait
              : MediaQuery.of(context).size.width < 1000
                  ? getHorizontalSize(
                      size.width * 0.85) // Phone landscape orientation
                  : getHorizontalSize(350), // Tablet landscape orientation
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsRouter()));
          },
          child: const Icon(
            Icons.settings,
            color: Color(0xFFd1d5db),
            size: 36.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double mainHeader = SizeUtils.calculateMainHeaderFontSize(context);
    double iconSize = SizeUtils.calculateIconSize(context);

    mediaQueryData = MediaQuery.of(context);

    Widget profilePictureWidget = _buildProfilePictureWidget(context);
    Widget imgHeaderWidget;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imgHeaderWidget = _buildImgHeaderPortrait();
    } else {
      imgHeaderWidget = _buildImgHeaderLandScape();
    }

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(
              left: 36,
              top: 20,
              right: 36,
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              imgHeaderWidget,
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 20),
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsRouter()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color(0xFF2A3786),
                                width: 2.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF2A3786),
                              size: 18.0,
                            ),
                          ),
                        )),
                    Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: const Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            'Your Account',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A3786)),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        )),
                  ],
                ),
              ),
              profilePictureWidget,
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15),
                child: Text(
                  "Hi there, $patientNameToShow 👋",
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A3786)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                  width: mediaQueryData.size.width * 0.8,
                  height: MediaQuery.of(context).orientation ==
                          Orientation.portrait
                      ? MediaQuery.of(context).size.width < 600
                          ? MediaQuery.of(context).size.height *
                              0.14 // Phone vertical orientation portrait
                          : MediaQuery.of(context).size.width *
                              0.3 // Tablet vertical orientation portrait
                      : MediaQuery.of(context).size.width < 1000
                          ? getHorizontalSize(
                              size.height * 0.1) // Phone landscape orientation
                          : MediaQuery.of(context).size.width * 0.11,
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomCardWidget(
                            iconData:
                                'assets/images/app_icons/Appointments.png',
                            text: "Upcoming appointment",
                            notificationCount:
                                accountModel.upcomingAppointments,
                            iconSize: iconSize + 2),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomCardWidget(
                            iconData:
                                'assets/images/app_icons/Forms.png',
                            text: "Pending Forms",
                            notificationCount:
                                accountModel.pendingForms,
                            iconSize: iconSize + 2),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomCardWidget(
                            iconData:
                                'assets/images/app_icons/Unread-notes.png',
                            text: "Unread Portal Notes",
                            notificationCount:
                                accountModel.unreadNotes,
                            iconSize: iconSize + 2),
                      )
                    ],
                  )
                  ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomTextContentWidget(
                        iconData: dataList[index]["iconData"],
                        text: dataList[index]["text"],
                        value: dataList[index]["value"],
                        iconSize: iconSize);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
              const SizedBox(height: 40.0),
              Container(
                child: const Center(
                  child: Text.rich(
                    TextSpan(
                      text:
                          "If any of the above is incorrect please contact our support team.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF2A3786),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ])),
      ),
    ));
  }
}

class CustomTextContentWidget extends StatelessWidget {
  final dynamic iconData;
  final String text;

  final String value;
  final double iconSize;
  const CustomTextContentWidget(
      {super.key,
      required this.iconData,
      required this.text,
      required this.iconSize,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Image(
                image: AssetImage(iconData),
                width: 22,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2A3786),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: Color(0xFF2A3786), fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomCardWidget extends StatelessWidget {
  final dynamic iconData;
  final String text;
  final int notificationCount;
  final double iconSize;
  const CustomCardWidget(
      {super.key,
      required this.iconData,
      required this.text,
      required this.notificationCount,
      required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: const Color(0xFFF1F5F9),
      child: Container(
          padding: const EdgeInsets.only(top: 2.0, bottom: 2),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              child: Image(image: AssetImage(iconData), width: 23),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                notificationCount.toString(),
                style: const TextStyle(
                  color: Color(0xFF2A3786),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94a3b8),
                      fontWeight: FontWeight.normal,
                      height: 1.3),
                ))
                )
          ])),
    );
  }
}
