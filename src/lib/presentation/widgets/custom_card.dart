import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final dynamic iconData;
  final String text;
  final dynamic screenRoute;
  Function()? fnEvent;
  CustomCard(
      {super.key,
      required this.iconData,
      required this.text,
      required this.screenRoute,
      this.fnEvent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: const Color(0xFFF1F5F9),
      child: GestureDetector(
         onTap: fnEvent,
        child:       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Container(
              padding: const EdgeInsets.all(9.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: iconData is IconData
                  ? Icon(
                      iconData,
                      color: const Color(0xFF2A3786),
                      size: 23,
                    )
                  : Image(
                      image: AssetImage(iconData),
                      width: 23,
                    ),
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A3786)),
                // overflow: TextOverflow.ellipsis,
              )),
          if (fnEvent != null)
          Padding(padding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child:     Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF6048DE),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 17,
              ),
            ),  
          )
        ],
      ),)

    );
  }
}
