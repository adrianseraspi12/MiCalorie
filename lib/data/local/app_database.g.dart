// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TotalNutrientsPerDayDao _totalNutrientsPerDayDaoInstance;

  BreakfastNutrientsDao _breakfastNutrientsDaoInstance;

  LunchNutrientsDao _lunchNutrientsDaoInstance;

  DinnerNutrientsDao _dinnerNutrientsDaoInstance;

  SnackNutrientsDao _snackNutrientsDaoInstance;

  FoodDao _foodDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `total_nutrients_per_day` (`id` INTEGER, `date` TEXT, `calories` INTEGER, `carbs` REAL, `fat` REAL, `protein` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `breakfast_nutrients` (`id` INTEGER, `calories` INTEGER, `carbs` REAL, `fat` REAL, `protein` REAL, `total_nutrients_per_day_id` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `lunch_nutrients` (`id` INTEGER, `calories` INTEGER, `carbs` REAL, `fat` REAL, `protein` REAL, `total_nutrients_per_day_id` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `dinner_nutrients` (`id` INTEGER, `calories` INTEGER, `carbs` REAL, `fat` REAL, `protein` REAL, `total_nutrients_per_day_id` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `snack_nutrients` (`id` INTEGER, `calories` INTEGER, `carbs` REAL, `fat` REAL, `protein` REAL, `total_nutrients_per_day_id` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `food` (`id` INTEGER, `meal_id` INTEGER, `name` TEXT, `number_of_servings` INTEGER, `serving_size` TEXT, `calories` INTEGER, `carbs` REAL, `fat` REAL, `protein` REAL, FOREIGN KEY (`meal_id`) REFERENCES `breakfast_nutrients` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`meal_id`) REFERENCES `lunch_nutrients` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`meal_id`) REFERENCES `dinner_nutrients` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`meal_id`) REFERENCES `snack_nutrients` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  TotalNutrientsPerDayDao get totalNutrientsPerDayDao {
    return _totalNutrientsPerDayDaoInstance ??=
        _$TotalNutrientsPerDayDao(database, changeListener);
  }

  @override
  BreakfastNutrientsDao get breakfastNutrientsDao {
    return _breakfastNutrientsDaoInstance ??=
        _$BreakfastNutrientsDao(database, changeListener);
  }

  @override
  LunchNutrientsDao get lunchNutrientsDao {
    return _lunchNutrientsDaoInstance ??=
        _$LunchNutrientsDao(database, changeListener);
  }

  @override
  DinnerNutrientsDao get dinnerNutrientsDao {
    return _dinnerNutrientsDaoInstance ??=
        _$DinnerNutrientsDao(database, changeListener);
  }

  @override
  SnackNutrientsDao get snackNutrientsDao {
    return _snackNutrientsDaoInstance ??=
        _$SnackNutrientsDao(database, changeListener);
  }

  @override
  FoodDao get foodDao {
    return _foodDaoInstance ??= _$FoodDao(database, changeListener);
  }
}

class _$TotalNutrientsPerDayDao extends TotalNutrientsPerDayDao {
  _$TotalNutrientsPerDayDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _totalNutrientsPerDayInsertionAdapter = InsertionAdapter(
            database,
            'total_nutrients_per_day',
            (TotalNutrientsPerDay item) => <String, dynamic>{
                  'id': item.id,
                  'date': item.date,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                }),
        _totalNutrientsPerDayUpdateAdapter = UpdateAdapter(
            database,
            'total_nutrients_per_day',
            ['id'],
            (TotalNutrientsPerDay item) => <String, dynamic>{
                  'id': item.id,
                  'date': item.date,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                }),
        _totalNutrientsPerDayDeletionAdapter = DeletionAdapter(
            database,
            'total_nutrients_per_day',
            ['id'],
            (TotalNutrientsPerDay item) => <String, dynamic>{
                  'id': item.id,
                  'date': item.date,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _total_nutrients_per_dayMapper = (Map<String, dynamic> row) =>
      TotalNutrientsPerDay(
          row['id'] as int,
          row['date'] as String,
          row['calories'] as int,
          row['carbs'] as double,
          row['fat'] as double,
          row['protein'] as double);

  final InsertionAdapter<TotalNutrientsPerDay>
      _totalNutrientsPerDayInsertionAdapter;

  final UpdateAdapter<TotalNutrientsPerDay> _totalNutrientsPerDayUpdateAdapter;

  final DeletionAdapter<TotalNutrientsPerDay>
      _totalNutrientsPerDayDeletionAdapter;

  @override
  Future<TotalNutrientsPerDay> findTotalNutrientsByDate(String date) async {
    return _queryAdapter.query(
        'SELECT * FROM total_nutrients_per_day WHERE date = ?',
        arguments: <dynamic>[date],
        mapper: _total_nutrients_per_dayMapper);
  }

  @override
  Future<List<TotalNutrientsPerDay>> getAllNutrients() async {
    return _queryAdapter.queryList('SELECT * FROM total_nutrients_per_day',
        mapper: _total_nutrients_per_dayMapper);
  }

  @override
  Future<int> insertTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay) {
    return _totalNutrientsPerDayInsertionAdapter.insertAndReturnId(
        totalNutrientsPerDay, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> updateTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay) {
    return _totalNutrientsPerDayUpdateAdapter.updateAndReturnChangedRows(
        totalNutrientsPerDay, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> deleteTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay) {
    return _totalNutrientsPerDayDeletionAdapter
        .deleteAndReturnChangedRows(totalNutrientsPerDay);
  }
}

class _$BreakfastNutrientsDao extends BreakfastNutrientsDao {
  _$BreakfastNutrientsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _breakfastNutrientsInsertionAdapter = InsertionAdapter(
            database,
            'breakfast_nutrients',
            (BreakfastNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _breakfastNutrientsUpdateAdapter = UpdateAdapter(
            database,
            'breakfast_nutrients',
            ['id'],
            (BreakfastNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _breakfastNutrientsDeletionAdapter = DeletionAdapter(
            database,
            'breakfast_nutrients',
            ['id'],
            (BreakfastNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _breakfast_nutrientsMapper = (Map<String, dynamic> row) =>
      BreakfastNutrients(
          row['id'] as int,
          row['calories'] as int,
          row['carbs'] as double,
          row['fat'] as double,
          row['protein'] as double,
          row['total_nutrients_per_day_id'] as int);

  final InsertionAdapter<BreakfastNutrients>
      _breakfastNutrientsInsertionAdapter;

  final UpdateAdapter<BreakfastNutrients> _breakfastNutrientsUpdateAdapter;

  final DeletionAdapter<BreakfastNutrients> _breakfastNutrientsDeletionAdapter;

  @override
  Future<BreakfastNutrients> findBreakfastById(int id) async {
    return _queryAdapter.query('SELECT * FROM breakfast_nutrients WHERE id = ?',
        arguments: <dynamic>[id], mapper: _breakfast_nutrientsMapper);
  }

  @override
  Future<BreakfastNutrients> findBreakfastByTotalNutrientsId(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM breakfast_nutrients WHERE total_nutrients_per_day_id = ?',
        arguments: <dynamic>[id],
        mapper: _breakfast_nutrientsMapper);
  }

  @override
  Future<List<BreakfastNutrients>> getAllBreakfast() async {
    return _queryAdapter.queryList('SELECT * FROM breakfast_nutrients',
        mapper: _breakfast_nutrientsMapper);
  }

  @override
  Future<int> insertBreakfast(BreakfastNutrients breakfastNutrients) {
    return _breakfastNutrientsInsertionAdapter.insertAndReturnId(
        breakfastNutrients, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> updateBreakfast(BreakfastNutrients breakfastNutrients) {
    return _breakfastNutrientsUpdateAdapter.updateAndReturnChangedRows(
        breakfastNutrients, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> deleteBreakfast(BreakfastNutrients breakfastNutrients) {
    return _breakfastNutrientsDeletionAdapter
        .deleteAndReturnChangedRows(breakfastNutrients);
  }
}

class _$LunchNutrientsDao extends LunchNutrientsDao {
  _$LunchNutrientsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _lunchNutrientsInsertionAdapter = InsertionAdapter(
            database,
            'lunch_nutrients',
            (LunchNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _lunchNutrientsUpdateAdapter = UpdateAdapter(
            database,
            'lunch_nutrients',
            ['id'],
            (LunchNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _lunchNutrientsDeletionAdapter = DeletionAdapter(
            database,
            'lunch_nutrients',
            ['id'],
            (LunchNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _lunch_nutrientsMapper = (Map<String, dynamic> row) =>
      LunchNutrients(
          row['id'] as int,
          row['calories'] as int,
          row['carbs'] as double,
          row['fat'] as double,
          row['protein'] as double,
          row['total_nutrients_per_day_id'] as int);

  final InsertionAdapter<LunchNutrients> _lunchNutrientsInsertionAdapter;

  final UpdateAdapter<LunchNutrients> _lunchNutrientsUpdateAdapter;

  final DeletionAdapter<LunchNutrients> _lunchNutrientsDeletionAdapter;

  @override
  Future<LunchNutrients> findLunchById(int id) async {
    return _queryAdapter.query('SELECT * FROM lunch_nutrients WHERE id = ?',
        arguments: <dynamic>[id], mapper: _lunch_nutrientsMapper);
  }

  @override
  Future<int> insertLunch(LunchNutrients lunchNutrients) {
    return _lunchNutrientsInsertionAdapter.insertAndReturnId(
        lunchNutrients, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> updateLunch(LunchNutrients lunchNutrients) {
    return _lunchNutrientsUpdateAdapter.updateAndReturnChangedRows(
        lunchNutrients, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> deleteLunch(LunchNutrients lunchNutrients) {
    return _lunchNutrientsDeletionAdapter
        .deleteAndReturnChangedRows(lunchNutrients);
  }
}

class _$DinnerNutrientsDao extends DinnerNutrientsDao {
  _$DinnerNutrientsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _dinnerNutrientsInsertionAdapter = InsertionAdapter(
            database,
            'dinner_nutrients',
            (DinnerNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _dinnerNutrientsUpdateAdapter = UpdateAdapter(
            database,
            'dinner_nutrients',
            ['id'],
            (DinnerNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _dinnerNutrientsDeletionAdapter = DeletionAdapter(
            database,
            'dinner_nutrients',
            ['id'],
            (DinnerNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _dinner_nutrientsMapper = (Map<String, dynamic> row) =>
      DinnerNutrients(
          row['id'] as int,
          row['calories'] as int,
          row['carbs'] as double,
          row['fat'] as double,
          row['protein'] as double,
          row['total_nutrients_per_day_id'] as int);

  final InsertionAdapter<DinnerNutrients> _dinnerNutrientsInsertionAdapter;

  final UpdateAdapter<DinnerNutrients> _dinnerNutrientsUpdateAdapter;

  final DeletionAdapter<DinnerNutrients> _dinnerNutrientsDeletionAdapter;

  @override
  Future<DinnerNutrients> findDinnerById(int id) async {
    return _queryAdapter.query('SELECT * FROM dinner_nutrients WHERE id = ?',
        arguments: <dynamic>[id], mapper: _dinner_nutrientsMapper);
  }

  @override
  Future<int> insertDinner(DinnerNutrients dinnerNutrients) {
    return _dinnerNutrientsInsertionAdapter.insertAndReturnId(
        dinnerNutrients, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> updateDinner(DinnerNutrients dinnerNutrients) {
    return _dinnerNutrientsUpdateAdapter.updateAndReturnChangedRows(
        dinnerNutrients, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> deleteDinner(DinnerNutrients dinnerNutrients) {
    return _dinnerNutrientsDeletionAdapter
        .deleteAndReturnChangedRows(dinnerNutrients);
  }
}

class _$SnackNutrientsDao extends SnackNutrientsDao {
  _$SnackNutrientsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _snackNutrientsInsertionAdapter = InsertionAdapter(
            database,
            'snack_nutrients',
            (SnackNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _snackNutrientsUpdateAdapter = UpdateAdapter(
            database,
            'snack_nutrients',
            ['id'],
            (SnackNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _snackNutrientsDeletionAdapter = DeletionAdapter(
            database,
            'snack_nutrients',
            ['id'],
            (SnackNutrients item) => <String, dynamic>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _snack_nutrientsMapper = (Map<String, dynamic> row) =>
      SnackNutrients(
          row['id'] as int,
          row['calories'] as int,
          row['carbs'] as double,
          row['fat'] as double,
          row['protein'] as double,
          row['total_nutrients_per_day_id'] as int);

  final InsertionAdapter<SnackNutrients> _snackNutrientsInsertionAdapter;

  final UpdateAdapter<SnackNutrients> _snackNutrientsUpdateAdapter;

  final DeletionAdapter<SnackNutrients> _snackNutrientsDeletionAdapter;

  @override
  Future<SnackNutrients> findSnackById(int id) async {
    return _queryAdapter.query('SELECT * FROM snack_nutrients WHERE id = ?',
        arguments: <dynamic>[id], mapper: _snack_nutrientsMapper);
  }

  @override
  Future<int> insertSnack(SnackNutrients snackNutrients) {
    return _snackNutrientsInsertionAdapter.insertAndReturnId(
        snackNutrients, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> updateSnack(SnackNutrients snackNutrients) {
    return _snackNutrientsUpdateAdapter.updateAndReturnChangedRows(
        snackNutrients, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> deleteSnack(SnackNutrients snackNutrients) {
    return _snackNutrientsDeletionAdapter
        .deleteAndReturnChangedRows(snackNutrients);
  }
}

class _$FoodDao extends FoodDao {
  _$FoodDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _foodInsertionAdapter = InsertionAdapter(
            database,
            'food',
            (Food item) => <String, dynamic>{
                  'id': item.id,
                  'meal_id': item.mealId,
                  'name': item.name,
                  'number_of_servings': item.numOfServings,
                  'serving_size': item.servingSize,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                }),
        _foodUpdateAdapter = UpdateAdapter(
            database,
            'food',
            ['id'],
            (Food item) => <String, dynamic>{
                  'id': item.id,
                  'meal_id': item.mealId,
                  'name': item.name,
                  'number_of_servings': item.numOfServings,
                  'serving_size': item.servingSize,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                }),
        _foodDeletionAdapter = DeletionAdapter(
            database,
            'food',
            ['id'],
            (Food item) => <String, dynamic>{
                  'id': item.id,
                  'meal_id': item.mealId,
                  'name': item.name,
                  'number_of_servings': item.numOfServings,
                  'serving_size': item.servingSize,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _foodMapper = (Map<String, dynamic> row) => Food(
      row['id'] as int,
      row['meal_id'] as int,
      row['name'] as String,
      row['number_of_servings'] as int,
      row['serving_size'] as String,
      row['calories'] as int,
      row['carbs'] as double,
      row['fat'] as double,
      row['protein'] as double);

  final InsertionAdapter<Food> _foodInsertionAdapter;

  final UpdateAdapter<Food> _foodUpdateAdapter;

  final DeletionAdapter<Food> _foodDeletionAdapter;

  @override
  Future<List<Food>> findAllFoodByMealId(int mealId) async {
    return _queryAdapter.queryList('SELECT * FROM food WHERE mealId = ?',
        arguments: <dynamic>[mealId], mapper: _foodMapper);
  }

  @override
  Future<List<Food>> getAllFood() async {
    return _queryAdapter.queryList('SELECT * FROM food', mapper: _foodMapper);
  }

  @override
  Future<int> insertFood(Food food) {
    return _foodInsertionAdapter.insertAndReturnId(
        food, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> updateFood(Food food) {
    return _foodUpdateAdapter.updateAndReturnChangedRows(
        food, sqflite.ConflictAlgorithm.ignore);
  }

  @override
  Future<int> deleteFood(Food food) {
    return _foodDeletionAdapter.deleteAndReturnChangedRows(food);
  }
}
