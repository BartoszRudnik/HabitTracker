import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habit_tracker/components/add_habit_button.dart';
import 'package:habit_tracker/components/habit_list.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:provider/provider.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Provider.of<HabitDatabase>(context).readHabits();

      return null;
    }, []);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: AppBar(),
      floatingActionButton: AddHabitButton(),
      body: HabitList(),
    );
  }
}
