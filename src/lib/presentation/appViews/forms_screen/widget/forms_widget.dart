import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/forms_model.dart';
import 'package:src/presentation/appViews/forms_screen/bloc/forms_bloc.dart';
import 'package:src/presentation/appViews/navigation_bar/main_screen.dart';
import 'package:src/presentation/widgets/custom_list_title.dart';
import 'package:src/presentation/widgets/custom_image_view.dart';
import 'package:src/shared/shared_preferences.dart';
import 'package:src/utils/image_constant.dart';
import 'package:src/utils/size_utils.dart';
import 'package:intl/intl.dart';

import '../../navigation_bar/bloc/navigation_bar_bloc.dart';

class FormsWidgets extends StatefulWidget {
  final String patientName;
  final FormsModel formCollectionsModel;
  const FormsWidgets(
      {Key? key, required this.formCollectionsModel, required this.patientName})
      : super(key: key);

  @override
  State<FormsWidgets> createState() =>
      _FormsWidgetsState(this.formCollectionsModel, this.patientName);
}

class _FormsWidgetsState extends State<FormsWidgets> {
  final FormsModel formCollectionsModel;
  final String patientName;
  int totalPendingForms = 0;
  late List<FormsRecordModel> pendingFormsRecords;
  late List<FormsRecordModel> completedFormsRecords;
  late List<FormsRecordModel> allFormsRecords;
  _FormsWidgetsState(this.formCollectionsModel, this.patientName);

  void updateStateCounter({required int newFormsCounter}) {
    setState(() {
      totalPendingForms = newFormsCounter;
    });
  }

  @override
  void initState() {
    super.initState();
    totalPendingForms = formCollectionsModel.pendingFormCount!;
    pendingFormsRecords = formCollectionsModel.pendingFormsRecords!;
    completedFormsRecords = formCollectionsModel.completedFormsRecords!;
    allFormsRecords = formCollectionsModel.allFormsRecords!;
  }

  void _getFormToken(BuildContext context, Map<String, dynamic> form,
      ResultModel collection) async {
    int userId = await MySharedPreferences.instance.getIntValue(USER_ID);
    int? collectionId = collection.id;
    int? patientId = collection.patientId;
    bool isDoctor = false;
    try {
      if (collectionId != null && patientId != null) {
        context.read<FormsBloc>().add(
            RequestFormToken(collectionId, patientId, userId, isDoctor, form));
      }
    } catch (e) {
      print('Error when obtaining the form token: $e');
    }
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
                    builder: (context) => const MainScreen(
                          index: 3,
                        )),
              );
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
                  builder: (context) => const MainScreen(
                        index: 3,
                      )),
            );
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

  Widget build(BuildContext context) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              imgHeaderWidget,
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Hello, $patientName 👋",
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A3786)),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: const TextStyle(
                    height: 1.5,
                  ),
                  formCollectionsModel.pendingFormCount != 0
                      ? TextSpan(
                          text: "You currently have ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF2A3786),
                          ),
                          children: [
                              TextSpan(
                                text: formCollectionsModel.pendingFormCount == 1
                                    ? "${formCollectionsModel.pendingFormCount} pending form "
                                    : "${formCollectionsModel.pendingFormCount} pending forms ",
                                style: const TextStyle(
                                  color: Color(0xFF6048DE),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: "that you need to complete.",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF2A3786),
                                ),
                              ),
                            ])
                      : const TextSpan(
                          text:
                              "You do not have any pending forms to complete.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF2A3786),
                          )),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 27.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Forms',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A3786)),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    BlocBuilder<NavigationBarBloc, NavigationBarState>(
                      builder: (context, state) {
                        return CustomListTitle(
                            iconData: 'assets/images/app_icons/Forms.png',
                            text: "Your Forms",
                            notificationCount: state.formsCounter,
                            iconSize: 23);
                      },
                    ),
                    formCollectionsModel.allFormsRecords!.isNotEmpty
                        ? Column(
                            children: [
                              const SizedBox(height: 5.0),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .45,
                                child: _buildAllForms(context),
                              ),
                            ],
                          )
                        : Container(
                            height: 18.0,
                            margin: const EdgeInsets.only(top: 5),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                'You do not have forms.',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              ),
                            )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildAllForms(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      addAutomaticKeepAlives: false,
      cacheExtent: 100.0,
      itemCount: allFormsRecords.length,
      itemBuilder: (context, index) {
        final formCollection = allFormsRecords[index].result;
        List<Map<String, dynamic>> formUrlsList =
            (json.decode(formCollection?.formURLs ?? "[]") as List)
                .cast<Map<String, dynamic>>();

        DateTime? updatedAtDate;
        if (formCollection?.updatedAt != null) {
          updatedAtDate = DateTime.parse(formCollection!.updatedAt!);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: formUrlsList.map((form) {
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    if (form['locked'] == 0 ||
                        (form['locked'] == 1 &&
                            form['percentageCompletion'] == 100)) {
                      _getFormToken(context, form, formCollection!);
                    }
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${form["formTitle"]}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2A3786),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      form['percentageCompletion'] == 100 && form['locked'] == 1
                          ? Container(
                              padding: const EdgeInsets.all(5.0),
                              margin: EdgeInsets.only(bottom: 5.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 130, 189, 79),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: const Text(
                                "1",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ],
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: form['percentageCompletion'] == 100 &&
                                  form['locked'] == 1
                              ? Text(
                                  'Submitted on: ${DateFormat('MMM d\'th\', yyyy').format(updatedAtDate!)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2A3786),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                )
                              : Text(
                                  '${form["percentageCompletion"]}% Completed',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2A3786),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                        ),
                        (form['locked'] == 0 ||
                                (form['locked'] == 1 &&
                                    form['percentageCompletion'] == 100))
                            ? Row(
                                children: [
                                  Text(
                                    form['percentageCompletion'] == 100 &&
                                            form['locked'] == 1
                                        ? "View form"
                                        : "Tap to complete form",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6048DE),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Container(
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF6048DE),
                                      size: 18,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  const Text(
                                    "View form",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFd1d5db),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Container(
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFFd1d5db),
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 4),
                  child: Divider(height: 0),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

class FormItem extends StatelessWidget {
  final ResultModel? formCollection;
  List<Map<String, dynamic>>? listForms;

  FormItem({
    super.key,
    this.listForms,
    this.formCollection,
  });

  void _getFormToken(BuildContext context, Map<String, dynamic> form,
      ResultModel collection) async {
    int userId = await MySharedPreferences.instance.getIntValue(USER_ID);
    int? collectionId = collection.id;
    int? patientId = collection.patientId;
    bool isDoctor = false;
    try {
      if (collectionId != null && patientId != null) {
        context.read<FormsBloc>().add(
            RequestFormToken(collectionId, patientId, userId, isDoctor, form));
      }
    } catch (e) {
      print('Error when obtaining the form token: $e');
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    double normalText = SizeUtils.calculateHomeNormalTextFontSize(context);
    double iconSize = SizeUtils.calculateIconSize(context);
    mediaQueryData = MediaQuery.of(context);
    return Row(
        children: listForms!.map((form) {
      return Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: const Color(0xFFF1F5F9),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: MediaQuery.of(context).size.width > 1000
                      ? const EdgeInsets.only(top: 15)
                      : const EdgeInsets.only(top: 18),
                  child: Text(
                    '${form["formTitle"]}',
                    style: const TextStyle(
                      color: Color(0xFF2A3786),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    'Complete form - ${form["percentageCompletion"]}%',
                    style: TextStyle(
                      color: const Color(0xFF2A3786),
                      fontSize: normalText,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Text(
                          "Tap here",
                          style: TextStyle(
                              color: form['locked'] == 0
                                  ? const Color(0xFF2A3786)
                                  : const Color(0xFFd1d5db),
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ),
                      GestureDetector(
                          onTap: () => {
                                if (form['locked'] == 0)
                                  {
                                    _getFormToken(
                                        context, form, formCollection!),
                                  },
                              },
                          child: Container(
                            padding: const EdgeInsets.all(4.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: form['locked'] == 0
                                  ? const Color(0xFF6048DE)
                                  : const Color(0xFFd1d5db),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.width > 1000
                                  ? iconSize - 11
                                  : iconSize - 7,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }).toList());
  }
}
