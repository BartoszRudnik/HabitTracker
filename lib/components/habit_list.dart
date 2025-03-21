import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/utils/habit_utilities.dart';
import 'package:provider/provider.dart';

class HabitList extends StatelessWidget {
  const HabitList({super.key});

  @override
  Widget build(BuildContext context) {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];

        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return HabitTile(habit: habit, isCompletedToday: isCompletedToday);
      },
    );
  }
}

class HabitTile extends StatelessWidget {
  const HabitTile({super.key, required this.habit, required this.isCompletedToday});

  final Habit habit;
  final bool isCompletedToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCompletedToday ? Colors.green : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: ListTile(
        title: Text(habit.name),
        leading: Checkbox.adaptive(
          value: isCompletedToday,
          onChanged: (value) {
            if (value != null) {
              context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
            }
          },
        ),
      ),
    );
  }
}
