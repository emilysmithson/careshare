part of 'category_cubit.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesListEmpty extends CategoriesState {}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoriesError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class CategoriesLoaded extends CategoriesState {
  final List<CareCategory> categoriesList;

  const CategoriesLoaded(this.categoriesList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoriesLoaded &&
        listEquals(other.categoriesList, categoriesList);
  }

  @override
  int get hashCode => categoriesList.hashCode;
}
