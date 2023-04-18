import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/controller/cubit/home_cubit.dart';
import '../widgets/task_card.dart';

class DoneView extends StatelessWidget {
  const DoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: ((context, index) => TaskCard(
                model: HomeCubit.get(context).doneTasks[index],
              )),
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          itemCount: HomeCubit.get(context).doneTasks.length,
        );
      },
    );
  }
}
