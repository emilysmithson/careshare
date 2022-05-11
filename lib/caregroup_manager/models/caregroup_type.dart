import 'package:flutter/material.dart';

class CaregroupType {
  final String type;
  final IconData icon;

  const CaregroupType(this.type, this.icon);

  static const CaregroupType open = CaregroupType('open', Icons.lock_open_outlined);
  static const CaregroupType closed = CaregroupType('closed', Icons.lock_outlined);

  static List<CaregroupType> caregroupTypeList = [
    open,
    closed,
  ];
}
