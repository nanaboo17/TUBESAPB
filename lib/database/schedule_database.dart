import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tubes/models/schedule.dart';

class ScheduleDatabase {
  static final ScheduleDatabase instance = ScheduleDatabase._init();

  static Database? _database;

  ScheduleDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('schedule.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE schedules (
        schedule_id TEXT PRIMARY KEY,
        from_location TEXT NOT NULL,
        to_location TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        type TEXT NOT NULL,
        note TEXT,
        price REAL NOT NULL,
        tickets_available INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertSchedule(Schedule schedule) async {
    final db = await instance.database;

    await db.insert(
      'schedules',
      schedule.toJson()
        ..['from_location'] = schedule.from
        ..['to_location'] = schedule.to,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertDummyData() async {
    final db = ScheduleDatabase.instance;

    List<Schedule> dummySchedules = [
      Schedule(
        scheduleId: 'SCH001',
        from: 'Jakarta',
        to: 'Bandung',
        date: DateTime(2025, 6, 1),
        time: '08:00',
        type: 'Travel',
        note: 'Termasuk snack ringan',
        price: 150000,
        ticketsAvailable: 10,
      ),
      Schedule(
        scheduleId: 'SCH002',
        from: 'Yogyakarta',
        to: 'Semarang',
        date: DateTime(2025, 6, 2),
        time: '10:30',
        type: 'Bus',
        note: null,
        price: 120000,
        ticketsAvailable: 25,
      ),
      Schedule(
        scheduleId: 'SCH003',
        from: 'Surabaya',
        to: 'Malang',
        date: DateTime(2025, 6, 3),
        time: '13:00',
        type: 'Kereta Api',
        note: 'Ekonomi AC',
        price: 80000,
        ticketsAvailable: 15,
      ),
      Schedule(
        scheduleId: 'SCH004',
        from: 'Medan',
        to: 'Binjai',
        date: DateTime(2025, 6, 4),
        time: '09:45',
        type: 'Bus',
        note: 'Non-stop',
        price: 50000,
        ticketsAvailable: 30,
      ),
      Schedule(
        scheduleId: 'SCH005',
        from: 'Denpasar',
        to: 'Gilimanuk',
        date: DateTime(2025, 6, 5),
        time: '07:15',
        type: 'Travel',
        note: 'Gratis air mineral',
        price: 90000,
        ticketsAvailable: 12,
      ),
    ];

    for (var schedule in dummySchedules) {
      await db.insertSchedule(schedule);
    }

    print('✅ Dummy data berhasil dimasukkan ke database.');
  }


  Future<List<Schedule>> getAllSchedules() async {
    final db = await instance.database;

    final result = await db.query('schedules');
    return result.map((json) => Schedule.fromJson(json)).toList();
  }

  Future<void> deleteSchedule(String id) async {
    final db = await instance.database;

    await db.delete(
      'schedules',
      where: 'schedule_id = ?',
      whereArgs: [id],
    );
  }

  Future<Schedule?> getScheduleById(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'schedules',
      where: 'schedule_id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Schedule.fromJson(result.first);
    }
    return null;
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final db = await instance.database;

    await db.update(
      'schedules',
      schedule.toJson()
        ..['from_location'] = schedule.from
        ..['to_location'] = schedule.to,
      where: 'schedule_id = ?',
      whereArgs: [schedule.scheduleId],
    );
  }

  Future<List<Schedule>> getSchedulesByType(String type) async {
    final db = await instance.database;

    final result = await db.query(
      'schedules',
      where: 'type = ?',
      whereArgs: [type],
    );

    return result.map((json) => Schedule.fromJson(json)).toList();
  }

  Future<List<Schedule>> getSchedulesByDate(DateTime date) async {
    final db = await instance.database;
    final dateString = date.toIso8601String().split('T')[0]; // yyyy-MM-dd

    final result = await db.query(
      'schedules',
      where: 'date LIKE ?',
      whereArgs: ['$dateString%'],
    );

    return result.map((json) => Schedule.fromJson(json)).toList();
  }

  Future<List<Schedule>> searchSchedules(String from, String to) async {
    final db = await instance.database;

    final result = await db.query(
      'schedules',
      where: 'from_location LIKE ? AND to_location LIKE ?',
      whereArgs: ['%$from%', '%$to%'],
    );

    return result.map((json) => Schedule.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
