class DBTable {
  final String tableName;
  const DBTable(this.tableName);
}

class DBColumn {
  final String columnName;
  const DBColumn(this.columnName);
}

class Users extends DBTable {
  Users() : super('users');

  static const DBColumn id = DBColumn('id');
  static const DBColumn email = DBColumn('email');
  static const DBColumn premium = DBColumn('premium');
  static const DBColumn parameters = DBColumn('saved_params');
}

class UsersCheck extends DBTable {
  UsersCheck() : super('users_check');

  static const DBColumn id = DBColumn('id');
  static const DBColumn email = DBColumn('email');
}

class Tanks extends DBTable {
  Tanks() : super('tanks');

  static const DBColumn id = DBColumn('id');
  static const DBColumn name = DBColumn('name');
  static const DBColumn createdAt = DBColumn('created_at');
  static const DBColumn ownerId = DBColumn('owner_id');
  static const DBColumn type = DBColumn('tank_type');
  static const DBColumn size = DBColumn('tank_size');
  static const DBColumn measurementUnit = DBColumn('tank_measurement');
  static const DBColumn imageLocalPath = DBColumn('image_local_path');
  static const DBColumn imageUrl = DBColumn('image_url');
}

class TankReadings extends DBTable {
  TankReadings() : super('tank_readings');

  static const DBColumn id = DBColumn('id');
  static const DBColumn tankId = DBColumn('tank_id');
  static const DBColumn createdAt = DBColumn('created_at');
  static const DBColumn note = DBColumn('note');
  static const DBColumn ownerId = DBColumn('owner_id');
  static const DBColumn imageUrl = DBColumn('image_url');
  static const DBColumn data = DBColumn('data');
}

class AppDefaults extends DBTable {
  AppDefaults() : super('app_defaults');

  static const DBColumn id = DBColumn('id');
  static const DBColumn name = DBColumn('name');
  static const DBColumn value = DBColumn('value');
}

class Table {
  static final users = Users();
  static final usersCheck = UsersCheck();
  static final tanks = Tanks();
  static final tankReadings = TankReadings();
  static final appDefaults = AppDefaults();
}
