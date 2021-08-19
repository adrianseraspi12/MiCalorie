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

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

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
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
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
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TotalNutrientsPerDayDao? _totalNutrientsPerDayDaoInstance;

  MealNutrientsDao? _mealNutrientsDaoInstance;

  FoodDao? _foodDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
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
            'CREATE TABLE IF NOT EXISTS `total_nutrients_per_day` (`id` INTEGER, `date` TEXT, `calories` INTEGER, `carbs` INTEGER, `fat` INTEGER, `protein` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `meal_nutrients` (`id` INTEGER, `calories` INTEGER, `carbs` INTEGER, `fat` INTEGER, `protein` INTEGER, `type` INTEGER, `total_nutrients_per_day_id` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `food` (`id` INTEGER, `meal_id` INTEGER, `name` TEXT, `number_of_servings` INTEGER, `brand_name` TEXT, `calories` INTEGER, `carbs` INTEGER, `fat` INTEGER, `protein` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TotalNutrientsPerDayDao get totalNutrientsPerDayDao {
    return _totalNutrientsPerDayDaoInstance ??=
        _$TotalNutrientsPerDayDao(database, changeListener);
  }

  @override
  MealNutrientsDao get mealNutrientsDao {
    return _mealNutrientsDaoInstance ??=
        _$MealNutrientsDao(database, changeListener);
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
            (TotalNutrientsPerDay item) => <String, Object?>{
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
            (TotalNutrientsPerDay item) => <String, Object?>{
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
            (TotalNutrientsPerDay item) => <String, Object?>{
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

  final InsertionAdapter<TotalNutrientsPerDay>
      _totalNutrientsPerDayInsertionAdapter;

  final UpdateAdapter<TotalNutrientsPerDay> _totalNutrientsPerDayUpdateAdapter;

  final DeletionAdapter<TotalNutrientsPerDay>
      _totalNutrientsPerDayDeletionAdapter;

  @override
  Future<TotalNutrientsPerDay?> findTotalNutrientsByDate(String date) async {
    return _queryAdapter.query(
        'SELECT * FROM total_nutrients_per_day WHERE date = ?1',
        mapper: (Map<String, Object?> row) => TotalNutrientsPerDay(
            row['id'] as int?,
            row['date'] as String?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?),
        arguments: [date]);
  }

  @override
  Future<TotalNutrientsPerDay?> findTotalNutrientsById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM total_nutrients_per_day WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TotalNutrientsPerDay(
            row['id'] as int?,
            row['date'] as String?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<TotalNutrientsPerDay>> getAllNutrients() async {
    return _queryAdapter.queryList('SELECT * FROM total_nutrients_per_day',
        mapper: (Map<String, Object?> row) => TotalNutrientsPerDay(
            row['id'] as int?,
            row['date'] as String?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?));
  }

  @override
  Future<int> insertTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay) {
    return _totalNutrientsPerDayInsertionAdapter.insertAndReturnId(
        totalNutrientsPerDay, OnConflictStrategy.ignore);
  }

  @override
  Future<int> updateTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay) {
    return _totalNutrientsPerDayUpdateAdapter.updateAndReturnChangedRows(
        totalNutrientsPerDay, OnConflictStrategy.ignore);
  }

  @override
  Future<int> deleteTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay) {
    return _totalNutrientsPerDayDeletionAdapter
        .deleteAndReturnChangedRows(totalNutrientsPerDay);
  }
}

class _$MealNutrientsDao extends MealNutrientsDao {
  _$MealNutrientsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _mealNutrientsInsertionAdapter = InsertionAdapter(
            database,
            'meal_nutrients',
            (MealNutrients item) => <String, Object?>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'type': item.type,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _mealNutrientsUpdateAdapter = UpdateAdapter(
            database,
            'meal_nutrients',
            ['id'],
            (MealNutrients item) => <String, Object?>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'type': item.type,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                }),
        _mealNutrientsDeletionAdapter = DeletionAdapter(
            database,
            'meal_nutrients',
            ['id'],
            (MealNutrients item) => <String, Object?>{
                  'id': item.id,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein,
                  'type': item.type,
                  'total_nutrients_per_day_id': item.totalNutrientsPerDayId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MealNutrients> _mealNutrientsInsertionAdapter;

  final UpdateAdapter<MealNutrients> _mealNutrientsUpdateAdapter;

  final DeletionAdapter<MealNutrients> _mealNutrientsDeletionAdapter;

  @override
  Future<MealNutrients?> findMealById(int id) async {
    return _queryAdapter.query('SELECT * FROM meal_nutrients WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MealNutrients(
            row['id'] as int?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?,
            row['type'] as int?,
            row['total_nutrients_per_day_id'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<MealNutrients>> finddMealByTotalNutrientsId(int id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM meal_nutrients WHERE total_nutrients_per_day_id = ?1',
        mapper: (Map<String, Object?> row) => MealNutrients(
            row['id'] as int?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?,
            row['type'] as int?,
            row['total_nutrients_per_day_id'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<MealNutrients>> getAlldMeal() async {
    return _queryAdapter.queryList('SELECT * FROM meal_nutrients',
        mapper: (Map<String, Object?> row) => MealNutrients(
            row['id'] as int?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?,
            row['type'] as int?,
            row['total_nutrients_per_day_id'] as int?));
  }

  @override
  Future<int> insertMeal(MealNutrients breakfastNutrients) {
    return _mealNutrientsInsertionAdapter.insertAndReturnId(
        breakfastNutrients, OnConflictStrategy.ignore);
  }

  @override
  Future<int> updatedMeal(MealNutrients breakfastNutrients) {
    return _mealNutrientsUpdateAdapter.updateAndReturnChangedRows(
        breakfastNutrients, OnConflictStrategy.ignore);
  }

  @override
  Future<int> deletedMeal(MealNutrients breakfastNutrients) {
    return _mealNutrientsDeletionAdapter
        .deleteAndReturnChangedRows(breakfastNutrients);
  }
}

class _$FoodDao extends FoodDao {
  _$FoodDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _foodInsertionAdapter = InsertionAdapter(
            database,
            'food',
            (Food item) => <String, Object?>{
                  'id': item.id,
                  'meal_id': item.mealId,
                  'name': item.name,
                  'number_of_servings': item.numOfServings,
                  'brand_name': item.brandName,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                }),
        _foodUpdateAdapter = UpdateAdapter(
            database,
            'food',
            ['id'],
            (Food item) => <String, Object?>{
                  'id': item.id,
                  'meal_id': item.mealId,
                  'name': item.name,
                  'number_of_servings': item.numOfServings,
                  'brand_name': item.brandName,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                }),
        _foodDeletionAdapter = DeletionAdapter(
            database,
            'food',
            ['id'],
            (Food item) => <String, Object?>{
                  'id': item.id,
                  'meal_id': item.mealId,
                  'name': item.name,
                  'number_of_servings': item.numOfServings,
                  'brand_name': item.brandName,
                  'calories': item.calories,
                  'carbs': item.carbs,
                  'fat': item.fat,
                  'protein': item.protein
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Food> _foodInsertionAdapter;

  final UpdateAdapter<Food> _foodUpdateAdapter;

  final DeletionAdapter<Food> _foodDeletionAdapter;

  @override
  Future<List<Food>?> findAllFoodByMealId(int mealId) async {
    return _queryAdapter.queryList('SELECT * FROM food WHERE meal_id = ?1',
        mapper: (Map<String, Object?> row) => Food(
            row['id'] as int?,
            row['meal_id'] as int?,
            row['name'] as String?,
            row['number_of_servings'] as int?,
            row['brand_name'] as String?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?),
        arguments: [mealId]);
  }

  @override
  Future<List<Food>> getAllFood() async {
    return _queryAdapter.queryList('SELECT * FROM food',
        mapper: (Map<String, Object?> row) => Food(
            row['id'] as int?,
            row['meal_id'] as int?,
            row['name'] as String?,
            row['number_of_servings'] as int?,
            row['brand_name'] as String?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?));
  }

  @override
  Future<Food?> findFoodById(int id) async {
    return _queryAdapter.query('SELECT * FROM food WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Food(
            row['id'] as int?,
            row['meal_id'] as int?,
            row['name'] as String?,
            row['number_of_servings'] as int?,
            row['brand_name'] as String?,
            row['calories'] as int?,
            row['carbs'] as int?,
            row['fat'] as int?,
            row['protein'] as int?),
        arguments: [id]);
  }

  @override
  Future<int> insertFood(Food food) {
    return _foodInsertionAdapter.insertAndReturnId(
        food, OnConflictStrategy.ignore);
  }

  @override
  Future<int> updateFood(Food food) {
    return _foodUpdateAdapter.updateAndReturnChangedRows(
        food, OnConflictStrategy.ignore);
  }

  @override
  Future<int> deleteFood(Food food) {
    return _foodDeletionAdapter.deleteAndReturnChangedRows(food);
  }
}
