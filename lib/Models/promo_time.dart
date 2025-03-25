import 'package:flutter/material.dart';

class PromoTime {
  final String time;
  final String hours;
  final String discount;
  final Color color;
  final IconData icon;

  PromoTime({
    required this.time,
    required this.hours,
    required this.discount,
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'hours': hours,
      'discount': discount,
      'color': color,
      'icon': icon,
    };
  }
}
