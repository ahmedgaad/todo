import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/core/controller/cubit/home_cubit.dart';

import '../../../core/utils/color_manager.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.model,
  });

  final Map model;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        HomeCubit.get(context).deleteDataFromDatabase(id: model['id']);
      },
      key: Key(model['id'].toString()),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: ColorsManager.primary),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40.0,
              child: Text(
                '${model['time']}',
                style: GoogleFonts.poppins().copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: GoogleFonts.poppins().copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${model['date']}',
                  style: GoogleFonts.poppins().copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                HomeCubit.get(context).updateDatabase(
                  status: 'done',
                  id: model['id'],
                );
              },
              child: const Icon(
                FontAwesomeIcons.circleCheck,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                HomeCubit.get(context).updateDatabase(
                  status: 'archive',
                  id: model['id'],
                );
              },
              child: const Icon(
                FontAwesomeIcons.boxArchive,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
