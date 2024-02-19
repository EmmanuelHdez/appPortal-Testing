import 'package:flutter/material.dart';

class CustomListTitle extends StatelessWidget {
  final dynamic iconData;
  final String text;
  final int? notificationCount;
  final double iconSize;
  const CustomListTitle({
    super.key,
    required this.iconData,
    required this.text,
    this.notificationCount = 0,
    this.iconSize = 23,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: const Color(0xFFF1F5F9),
      child: Row(
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
              child: Image(
                image: AssetImage(iconData),
                width: 23,
              ),
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Text(
                overflow: TextOverflow.ellipsis,
                 maxLines: 2,
                text,
                style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A3786)),
                // overflow: TextOverflow.ellipsis,
              )),
          if (notificationCount != null && notificationCount != 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  notificationCount.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              ),
            )
        ],
      ),
    );
  }
}
