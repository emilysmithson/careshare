import 'package:bloc/bloc.dart';
import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(
          const HomePageLoaded(
            TaskManagerView(),
          ),
        );

  navigateTo(Widget content) {
    emit(HomePageLoaded(content));
  }
}
