import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/core/controller/cubit/home_cubit.dart';
import 'package:todo/core/utils/color_manager.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: const Text(
                'ToDo',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: cubit.newTasks.isNotEmpty ||
                    cubit.doneTasks.isNotEmpty ||
                    cubit.archivedTasks.isNotEmpty
                ? cubit.screens[cubit.currentIndex]
                : Center(
                    child: Text(
                      "There's No tasks yet",
                      style: GoogleFonts.poppins().copyWith(
                        fontSize: 35.0,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: _titleController.text,
                      date: _dateController.text,
                      time: _timeController.text,
                    );
                    Navigator.pop(context);
                    cubit.isBottomSheetShown = false;
                    cubit.changeFABIcon();
                  }
                  _titleController.text = '';
                  _timeController.text = '';
                  _dateController.text = '';
                } else {
                  cubit.scaffoldKey.currentState
                      ?.showBottomSheet(
                        elevation: 20.0,
                        (context) {
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _titleController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter the Title of Task';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Write your Task',
                                      filled: true,
                                      fillColor: ColorsManager.grey,
                                      prefixIcon:
                                          Icon(FontAwesomeIcons.listCheck),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _timeController,
                                          readOnly: true,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Enter the Time of Task';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((selectedTime) {
                                              if (selectedTime != null) {
                                                time = selectedTime;
                                                _timeController.text =
                                                    time.format(context);
                                              }
                                              log('---- ${time.format(context)} ----');
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Select time',
                                            filled: true,
                                            fillColor: ColorsManager.grey,
                                            prefixIcon:
                                                Icon(FontAwesomeIcons.clock),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _dateController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Enter the Date of Task';
                                            }
                                            return null;
                                          },
                                          readOnly: true,
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(3000),
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                date = selectedDate;
                                                _dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(date);
                                              }
                                              log('---- ${date.toString()} ----');
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Select date',
                                            filled: true,
                                            fillColor: ColorsManager.grey,
                                            prefixIcon:
                                                Icon(FontAwesomeIcons.calendar),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      .closed
                      .then((value) {
                        cubit.isBottomSheetShown = false;
                        cubit.changeFABIcon();
                        _titleController.text = '';
                        _timeController.text = '';
                        _dateController.text = '';
                      });
                  cubit.isBottomSheetShown = true;
                  cubit.changeFABIcon();
                }
              },
              child: Icon(
                cubit.FABIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavBarIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.listCheck),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.check),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.boxArchive),
                  label: 'Archive',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
