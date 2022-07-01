import 'package:careshare/category_manager/domain/models/category.dart';

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

class Delta {
  final String user;
  final Delta delta;
  final String deviceId;

  Delta({
    required this.user,
    required this.delta,
    required this.deviceId,
  });

  Delta clone() {
    Delta cloned = Delta(
      user: user,
      delta: delta,
      deviceId: deviceId,
    );

    return cloned;
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'delta': jsonEncode(delta.toJson()),
      'deviceId': deviceId,
    };
  }

  factory Delta.fromJson(dynamic key, dynamic value) {
    Delta contentMap = Delta.fromJson(key, value['delta']);

    return Delta(
      user: value['user'],
      delta: contentMap,
      deviceId: value['deviceId'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Delta &&
        other.user == user &&
        other.delta == delta &&
        other.deviceId == deviceId;
  }

  @override
  int get hashCode {
    return user.hashCode ^
    delta.hashCode ^
    deviceId.hashCode;
  }
}

enum DeltaField {
  user,
  delta,
  deviceId,
}
