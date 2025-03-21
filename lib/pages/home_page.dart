import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:provider/provider.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    void createNewHabit() {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: 'Create a new habit'),
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    String newHabitName = textController.text.trim();

                    context.read<HabitDatabase>().addHabit(newHabitName);

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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.add),
      ),
    );
  }
}
