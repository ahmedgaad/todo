part of 'home_cubit.dart';

@immutable
abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class ChangeBottomNavBarIndex extends HomeStates {}

class ChangeFABIcon extends HomeStates {}

class DataRetrievedFromDBSuccessfully extends HomeStates {}

class DataDeletedFromDBSuccessfully extends HomeStates {}

class UpdateDBSuccessfully extends HomeStates {}

class DataInsertedToDBSuccessfully extends HomeStates {}

class DataInsertedToDBFailed extends HomeStates {}

class DatabaseCreatedSuccessfully extends HomeStates {}
