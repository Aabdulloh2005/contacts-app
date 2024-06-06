import 'package:contact_app/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactsLocalDatabase {
  ContactsLocalDatabase._contactLocalData();

  static final ContactsLocalDatabase _localdatabase =
      ContactsLocalDatabase._contactLocalData();

  factory ContactsLocalDatabase() {
    return _localdatabase;
  }
  Database? _database;

  /// Check database for null
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDataBase();
    return _database!;
  }

  /// Initialazing database to the path
  Future<Database> _initDataBase() async {
    final databasePath = await getDatabasesPath();

    final path = '$databasePath/contacts.db';
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  /// Creating database contact
  Future<void> _createDatabase(Database db, int version) async {
    print("sdsdf");
    return await db.execute('''
CREATE TABLE contact (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
phone TEXT NOT NULL,
image TEXT
);
''');
  }

  Future<void> addContact(Contact contact) async {
    await _database!.insert('contact', {
      "name": contact.name,
      "phone": contact.phone,
      "image": contact.image ?? contact.name.substring(0, 1),
    });
  }

  Future<List<Contact>> getContacts() async {
    List<Map<String, dynamic>>? rows = await _database?.query('contact');
    List<Contact> loadedContacts = [];

    if (rows != null) {
      for (var element in rows) {
        loadedContacts.add(Contact.fromJson(element));
      }
    }
    return loadedContacts;
  }

  Future<void> editContact(Contact editContact) async {
    await _database!.update(
      'contact',
      editContact.toJson(),
      where: "id = ?",
      whereArgs: [editContact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    await _database!.delete(
      'contact',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
