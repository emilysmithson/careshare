part of 'home_page_cubit.dart';

abstract class HomePageState extends Equatable {
  final Widget content;
  const HomePageState(this.content);

  @override
  List<Object> get props => [content];
}

class HomePageLoaded extends HomePageState {
  const HomePageLoaded(Widget content) : super(content);
}
