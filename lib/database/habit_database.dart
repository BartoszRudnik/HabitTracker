import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();

      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();

    return settings?.firstLaunchDate;
  }

  final List<Habit> currentHabits = [];

  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;

    await isar.writeTxn(() => isar.habits.put(newHabit));

    readHabits();
  }

  Future<void> readHabits() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    currentHabits
      ..clear()
      ..addAll(fetchedHabits);

    notifyListeners();
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(todayDate)) {
          habit.completedDays.add(todayDate);
        } else {
          habit.completedDays.removeWhere((date) => date == todayDate);
        }

        await isar.habits.put(habit);
      });

      readHabits();
    }
  }

  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;

        await isar.habits.put(habit);
      });

      readHabits();
    }
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async => await isar.habits.delete(id));

    readHabits();
  }
}
