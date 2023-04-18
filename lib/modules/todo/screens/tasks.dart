import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/controller/cubit/home_cubit.dart';
import '../widgets/task_card.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: ((context, index) => TaskCard(
                model: HomeCubit.get(context).newTasks[index],
              )),
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          itemCount: HomeCubit.get(context).newTasks.length,
        );
      },
    );
  }
}
