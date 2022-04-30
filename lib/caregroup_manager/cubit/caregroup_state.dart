part of 'caregroup_cubit.dart';

abstract class CaregroupState extends Equatable {
  const CaregroupState();

  @override
  List<Object> get props => [];
}

class CaregroupInitial extends CaregroupState {}

class CaregroupLoading extends CaregroupState {
  const CaregroupLoading();
}

class CaregroupListEmpty extends CaregroupState {}

class CaregroupError extends CaregroupState {
  final String message;

  const CaregroupError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CaregroupError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class CaregroupLoaded extends CaregroupState {
  final List<Caregroup> caregroupList;
  // final Caregroup? myCaregroup;

  const CaregroupLoaded({
    required this.caregroupList,
    // required this.myCaregroup,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CaregroupLoaded && listEquals(other.caregroupList, caregroupList);
  }

  @override
  int get hashCode => caregroupList.hashCode;
}
