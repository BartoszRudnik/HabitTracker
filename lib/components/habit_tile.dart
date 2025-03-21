import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';

class HabitTile extends HookWidget {
  const HabitTile({super.key, required this.habit, required this.isCompletedToday});

  final Habit habit;
  final bool isCompletedToday;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    void editHabit(Habit habit) {
      textController.text = habit.name;

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: TextField(controller: textController),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    String newHabitName = textController.text.trim();

                    context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);

                    textController.clear();

                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
                MaterialButton(
                  onPressed: () {
                    textController.clear();

                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
      );
    }

    void deleteHabit(Habit habit) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Are you sure you want to delete?'),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    context.read<HabitDatabase>().deleteHabit(habit.id);

                    Navigator.of(context).pop();
                  },
                  child: Text('Delete'),
                ),
                MaterialButton(
                  onPressed: () {
                    textController.clear();

                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
      );
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => editHabit(habit),
            backgroundColor: Colors.grey.shade800,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: (context) => deleteHabit(habit),
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
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
      ),
    );
  }
}
