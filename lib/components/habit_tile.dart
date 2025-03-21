import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({super.key, required this.habit, required this.isCompletedToday});

  final Habit habit;
  final bool isCompletedToday;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<HabitDatabase>().updateHabitCompletion(habit.id, !isCompletedToday),
      child: Container(
        decoration: BoxDecoration(
          color: isCompletedToday ? Colors.green : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: ListTile(
          title: Text(habit.name),
          leading: Checkbox.adaptive(
            activeColor: Colors.green,
            value: isCompletedToday,
            onChanged: (value) {
              if (value != null) {
                context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
              }
            },
          ),
        ),
      ),
    );
  }
}
