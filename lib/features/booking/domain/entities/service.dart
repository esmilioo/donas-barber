import 'package:flutter/material.dart';

class Service {
  final String name;
  final String description;
  final int duration;
  final double price;
  final IconData icon;

  const Service({
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.icon,
  });
}