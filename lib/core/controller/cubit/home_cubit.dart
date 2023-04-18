import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/todo/screens/archive.dart';
import 'package:todo/modules/todo/screens/done.dart';
import 'package:todo/modules/todo/screens/tasks.dart';

part 'home_cubit_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitial()) {
    // createDatabase();
    // dropDatabase();
  }
  static HomeCubit get(ctx) => BlocProvider.of(ctx);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData FABIcon = FontAwesomeIcons.penToSquare;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeFABIcon() {
    FABIcon = isBottomSheetShown
        ? FontAwesomeIcons.plus
        : FontAwesomeIcons.penToSquare;
    emit(ChangeFABIcon());
  }

  int currentIndex = 0;
  void changeBottomNavBarIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarIndex());
  }

  List screens = <Widget>[
    const TasksView(),
    const DoneView(),
    const ArchiveView(),
  ];

  /* 
  *** Drop Database***
  */
  Future<void> dropDatabase() async {
    await deleteDatabase('todo.db').then((value) {
      log('---- Database Deleted Successfully ----');
    });
  }

  late Database database;
  Future<void> createDatabase() async {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        await db
            .execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date DATETIME, status TEXT, time DATETIME)',
        )
            .then(
          (value) {
            log('---- Table Created ----');
          },
        ).catchError(
          (e) {
            log('---- Error through create database: ${e.toString()} ----');
          },
        );
      },
      onOpen: (db) {
        log('---- Database Opened ----');
        retrieveDataFromDB(db);
      },
    ).then((db) {
      database = db;
      emit(DatabaseCreatedSuccessfully());
      // log('---- Database Created Successfully ----');
    });
  }

  Future<void> insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    try {
      await database.transaction((txn) async {
        final id = await txn.rawInsert(
          'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
        );
        log('---- Transaction Inserted: $id ----');
        emit(DataInsertedToDBSuccessfully());
        retrieveDataFromDB(database);
      });
    } catch (error) {
      log('---- Transaction Failed: ${error.toString()} ----');
      emit(DataInsertedToDBFailed());
    }
  }

  Future<void> updateDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      retrieveDataFromDB(database);
      emit(UpdateDBSuccessfully());
    });
  }

  Future<void> retrieveDataFromDB(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database.rawQuery('SELECT * FROM Tasks').then((retrievedTasks) {
      log('---- Tasks: $retrievedTasks ----');
      retrievedTasks.forEach((task) {
        if (task['status'] == 'new') {
          newTasks.add(task);
        } else if (task['status'] == 'done') {
          doneTasks.add(task);
        } else {
          archivedTasks.add(task);
        }
      });
      emit(DataRetrievedFromDBSuccessfully());
    });
  }

  deleteDataFromDatabase({
    required int id,
  }) async {
    return await database.rawDelete(
      'DELETE FROM Tasks WHERE id = ?',
      [id],
    ).then((value) {
      retrieveDataFromDB(database);
      emit(DataDeletedFromDBSuccessfully());
    });
  }
}
