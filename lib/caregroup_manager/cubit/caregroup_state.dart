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

class CaregroupsLoaded extends CaregroupState {
  final List<Caregroup> caregroupList;
  final List<Caregroup> myCaregroupList;
  final List<Caregroup> otherCaregroupList;
  // final Caregroup? myCaregroup;

  const CaregroupsLoaded({
    required this.caregroupList,
    required this.myCaregroupList,
    required this.otherCaregroupList,
    // required this.myCaregroup,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CaregroupsLoaded && listEquals(other.caregroupList, caregroupList);
  }

  @override
  int get hashCode => caregroupList.hashCode;
}
