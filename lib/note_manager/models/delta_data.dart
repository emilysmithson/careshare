import 'package:careshare/category_manager/domain/models/category.dart';

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

class DeltaData {
  final String id;
  final String user;
  final Delta delta;
  final String deviceId;

  DeltaData({
    this.id = "0",
    required this.user,
    required this.delta,
    required this.deviceId,
  });

  DeltaData clone() {
    DeltaData cloned = DeltaData(
      id: id,
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

  factory DeltaData.fromJson(dynamic key, dynamic value) {
    Delta delta = Delta.fromJson(json.decode(value['delta']));

    return DeltaData(
      id: key,
      user: value['user'],
      delta: delta,
      deviceId: value['deviceId'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeltaData &&
        other.id == id &&
        other.user == user &&
        other.delta == delta &&
        other.deviceId == deviceId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ user.hashCode ^ delta.hashCode ^ deviceId.hashCode;
  }
}

enum DeltaField {
  user,
  delta,
  deviceId,
}
