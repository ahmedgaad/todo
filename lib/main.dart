import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/helpers/observer.dart';
import 'package:todo/core/themes/themes_manager.dart';
import 'package:todo/core/widgets/home_screen.dart';

import 'core/controller/cubit/home_cubit.dart';

void main() {
  log('--- main ---');
  WidgetsFlutterBinding.ensureInitialized();
  log('--- main: WidgetsFlutterBinding.ensureInitialized ---');

  Bloc.observer = MyBlocObserver();
  log('--- main: MyBlocObserver ---');
  runApp(const ToDo());
}

class ToDo extends StatelessWidget {
  const ToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => HomeCubit()..createDatabase(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo',
        home: HomeView(),
        theme: ThemeManager.lightTheme,
      ),
    );
  }
}
