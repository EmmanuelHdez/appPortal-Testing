import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:src/utils/app_export.dart';

class CustomSwitch extends StatelessWidget {
  CustomSwitch({this.alignment, this.margin, this.value, this.onChanged});

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  bool? value;

  Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildSwitchWidget(),
          )
        : _buildSwitchWidget();
  }

  _buildSwitchWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: FlutterSwitch(
        value: value ?? false,
        height: getHorizontalSize(24),
        width: getHorizontalSize(44),
        toggleSize: 24,
        borderRadius: getHorizontalSize(
          12.00,
        ),
        activeColor: const Color(0xFF2A3786),
        activeToggleColor: const Color(0xFF94A3B8),
        inactiveColor: const Color(0xFFF1F5F9),
        inactiveToggleColor: const Color(0xFF94A3B8),
        onToggle: (value) {
          onChanged!(value);
        },
      ),
    );
  }
}
