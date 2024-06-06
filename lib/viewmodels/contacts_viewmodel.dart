import 'package:contact_app/data/contacts_local_database.dart';
import 'package:contact_app/models/contact.dart';

class ContactsViewmodel {
  ContactsLocalDatabase contactsLocalDatabase = ContactsLocalDatabase();
  List<Contact> phoneList = [];

  ContactsViewmodel() {
    _initDatabase();
  }

  void _initDatabase() async {
    await contactsLocalDatabase.database;
  }

  Future<List<Contact>> getContacts() async {
    final List<Contact> response = await contactsLocalDatabase.getContacts();
    phoneList = response;
    return phoneList;
  }

  Future<void> addContact(Contact newContact) async {
    await contactsLocalDatabase.addContact(newContact);
  }

  Future<void> editContact(Contact editContact) async {
    await contactsLocalDatabase.editContact(editContact);
    await getContacts();
  }

  Future<void> deleteContact(int id) async {
    await contactsLocalDatabase.deleteContact(id);
    await getContacts();
  }
}
