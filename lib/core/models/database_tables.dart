class DatabaseTables {
  final String tableName;
  const DatabaseTables(this.tableName);
}

class DBColumn {
  final String columnName;
  const DBColumn(this.columnName);
}

class Users extends DatabaseTables {
  Users() : super('users');

  String get id => _id.columnName;
  String get email => _email.columnName;
  String get premium => _premium.columnName;
  String get settings => _settings.columnName;
  String get username => _username.columnName;
  static const DBColumn _id = DBColumn('id');
  static const DBColumn _email = DBColumn('email');
  static const DBColumn _premium = DBColumn('premium');
  static const DBColumn _settings = DBColumn('settings');
  static const DBColumn _username = DBColumn('username');
}

class UsersCheck extends DatabaseTables {
  UsersCheck() : super('users_check');

  String get id => _id.columnName;
  String get email => _email.columnName;

  static const DBColumn _id = DBColumn('id');
  static const DBColumn _email = DBColumn('email');
}

class Tanks extends DatabaseTables {
  Tanks() : super('tanks');

  String get id => _id.columnName;
  String get name => _name.columnName;
  String get createdAt => _createdAt.columnName;
  String get ownerId => _ownerId.columnName;
  String get type => _type.columnName;
  String get size => _size.columnName;
  String get measurementUnit => _measurementUnit.columnName;
  String get imageLocalPath => _imageLocalPath.columnName;
  String get imageUrl => _imageUrl.columnName;
  String get targets => _targets.columnName;

  static const DBColumn _id = DBColumn('id');
  static const DBColumn _name = DBColumn('name');
  static const DBColumn _createdAt = DBColumn('created_at');
  static const DBColumn _ownerId = DBColumn('owner_id');
  static const DBColumn _type = DBColumn('tank_type');
  static const DBColumn _size = DBColumn('tank_size');
  static const DBColumn _measurementUnit = DBColumn('tank_measurement');
  static const DBColumn _imageLocalPath = DBColumn('image_local_path');
  static const DBColumn _imageUrl = DBColumn('image_url');
  static const DBColumn _targets = DBColumn('targets');
}

class TankReadings extends DatabaseTables {
  TankReadings() : super('tank_readings');

  String get id => _id.columnName;
  String get tankId => _tankId.columnName;
  String get createdAt => _createdAt.columnName;
  String get note => _note.columnName;
  String get ownerId => _ownerId.columnName;
  String get imageUrl => _imageUrl.columnName;
  String get data => _data.columnName;

  static const DBColumn _id = DBColumn('id');
  static const DBColumn _tankId = DBColumn('tank_id');
  static const DBColumn _createdAt = DBColumn('created_at');
  static const DBColumn _note = DBColumn('note');
  static const DBColumn _ownerId = DBColumn('owner_id');
  static const DBColumn _imageUrl = DBColumn('image_url');
  static const DBColumn _data = DBColumn('data');
}

class AppDefaults extends DatabaseTables {
  AppDefaults() : super('app_defaults');

  String get id => _id.columnName;
  String get name => _name.columnName;
  String get value => _value.columnName;

  static const DBColumn _id = DBColumn('id');
  static const DBColumn _name = DBColumn('name');
  static const DBColumn _value = DBColumn('value');
}

class Achievements extends DatabaseTables {
  Achievements() : super('achievements');

  String get id => _id.columnName;
  String get name => _name.columnName;
  String get description => _description.columnName;

  static const DBColumn _id = DBColumn("id");
  static const DBColumn _name = DBColumn("name");
  static const DBColumn _description = DBColumn("description");
}

class BugReports extends DatabaseTables {
  BugReports() : super('bug_reports');

  String get id => _id.columnName;
  String get createdAt => _createdAt.columnName;
  String get reporter => _reporter.columnName;
  String get description => _description.columnName;
  String get appVersion => _appVersion.columnName;
  String get screenshotUrl => _screenshotUrl.columnName;
  static const DBColumn _id = DBColumn('id');
  static const DBColumn _createdAt = DBColumn('created_at');
  static const DBColumn _reporter = DBColumn('reporter');
  static const DBColumn _description = DBColumn('description');
  static const DBColumn _appVersion = DBColumn('app_version');
  static const DBColumn _screenshotUrl = DBColumn('screenshot_url');
}

class Fish extends DatabaseTables {
  Fish() : super('fish');

  // No columns defined yet
}

class CommunityTankPosts extends DatabaseTables {
  CommunityTankPosts() : super('community_tank_posts');

  String get id => _id.columnName;
  String get title => _title.columnName;
  String get content => _content.columnName;
  String get authorId => _authorId.columnName;
  String get authorName => _authorName.columnName;
  String get createdAt => _createdAt.columnName;
  String get updatedAt => _updatedAt.columnName;
  String get images => _images.columnName;
  String get upVotes => _upVotes.columnName;
  String get downVotes => _downVotes.columnName;

  static const DBColumn _id = DBColumn('id');
  static const DBColumn _title = DBColumn('title');
  static const DBColumn _content = DBColumn('content');
  static const DBColumn _authorId = DBColumn('author_id');
  static const DBColumn _authorName = DBColumn('author_name');
  static const DBColumn _createdAt = DBColumn('created_at');
  static const DBColumn _updatedAt = DBColumn('updated_at');
  static const DBColumn _images = DBColumn('images');
  static const DBColumn _upVotes = DBColumn('up_votes');
  static const DBColumn _downVotes = DBColumn('down_votes');
}

class CommunityTankPostsComments extends DatabaseTables {
  CommunityTankPostsComments() : super('community_tank_posts_comments');

  String get id => _id.columnName;
  String get postId => _postId.columnName;
  String get content => _content.columnName;
  String get createdAt => _createdAt.columnName;
  String get authorId => _authorId.columnName;
  String get authorName => _authorName.columnName;

  static const DBColumn _id = DBColumn('id');
  static const DBColumn _postId = DBColumn('post_id');
  static const DBColumn _content = DBColumn('content');
  static const DBColumn _createdAt = DBColumn('created_at');
  static const DBColumn _authorId = DBColumn('author_id');
  static const DBColumn _authorName = DBColumn('author_name');
}

class SupabaseTable {
  static final users = Users();
  static final usersCheck = UsersCheck();
  static final tanks = Tanks();
  static final tankReadings = TankReadings();
  static final appDefaults = AppDefaults();
  static final bugReports = BugReports();
  static final fish = Fish();
  static final achievements = Achievements();
  static final communityTankPost = CommunityTankPosts();
  static final communityTankPostComments = CommunityTankPostsComments();
}
