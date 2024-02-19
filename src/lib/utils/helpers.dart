import 'package:src/config/config.dart';

RegExp linkRegExp = RegExp(
    r'\b(?:https?|ftp):\/\/[^\s/$.?#].[^\s]*\b|\bwww\.[^\s/$.?#].[^\s]*\b',
    caseSensitive: false);

String formHasFormCounter(dynamic collection, dynamic form) {
  if (form['formType'] == 'ADHDTxMonitoring') {
    return (form['formTitle'] +
        ' (' +
        collection['AdhdtxMonitoring']['formCounter'].toString() +
        ' of ' +
        ADHDTX_FORMCOUNTER_MAX.toString() +
        ')');
  }

  if (form['formType'] == 'SNAP4BaselineMonitoring') {
    return (form['formTitle'] +
        ' (' +
        collection['Snap4BaselineMonitoring']['formCounter'].toString() +
        ' of ' +
        SNAP4_FORMCOUNTER_MAX.toString() +
        ')');
  }

  return form['formTitle'];
}
