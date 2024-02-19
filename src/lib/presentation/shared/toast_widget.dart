import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastWidget extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
   const ToastWidget(this.icon, this.text, this.color, {super.key});
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _ToastWidget(icon, text, color);
  }
}
 
class _ToastWidget extends State<ToastWidget> {
  final IconData icon;
  final String text;
  final Color color;
  _ToastWidget(this.icon, this.text, this.color);
  @override
  Widget build(BuildContext context) {
    return buildToast(icon, text, color);
  }
 
  Widget buildToast(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color.fromRGBO(255,255,255,1),
          ),
          const SizedBox(
            width: 4.0,
          ),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(255,255,255,1),
              ),
            ),
          )
        ],
      ),
    );
  }
}