import 'package:flutter/material.dart';

class FieldType {
  final String type;
  final IconData icon;
  final Color color;

  FieldType({
    required this.type,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'icon': icon,
      'color': color,
    };
  }

  factory FieldType.fromMap(Map<String, dynamic> map) {
    return FieldType(
      type: map['type'],
      icon: map['icon'],
      color: map['color'],
    );
  }
}
