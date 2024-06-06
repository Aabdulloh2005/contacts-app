import 'dart:math';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/viewmodels/contacts_viewmodel.dart';
import 'package:contact_app/views/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ContactsViewmodel contactsViewmodel = ContactsViewmodel();
  final TextEditingController _searchController = TextEditingController();
  String? searchText;

  @override
  void initState() {
    super.initState();
    contactsViewmodel.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              searchText = _searchController.text;
            });
          },
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.search),
            filled: true,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: Colors.grey.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                onTap: () async {
                  final Map<String, dynamic>? data = await showDialog(
                    context: context,
                    builder: (context) => DialogWidget(),
                  );
                  if (data != null) {
                    await contactsViewmodel.addContact(
                      Contact(
                        id: data['id'],
                        name: data['name'],
                        phone: data['phone'],
                        image: data['image'],
                      ),
                    );
                    setState(() {
                      contactsViewmodel.getContacts();
                    });
                  }
                },
                leading: Icon(
                  Icons.person_add_alt_1,
                  color: Colors.purple.shade300,
                ),
                title: Text(
                  "Create contact",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.purple.shade300,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List<Contact>>(
                  future: contactsViewmodel.getContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No contacts available"));
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text("An error occurred"));
                    }
                    final contactList = snapshot.data!.where((contact) {
                      return searchText == null || searchText!.isEmpty
                          ? true
                          : contact.name.toLowerCase().contains(searchText!.toLowerCase());
                    }).toList();
                    return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: contactList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        final contact = contactList[i];
                        return ListTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final Map<String, dynamic>? data = await showDialog(
                                    context: context,
                                    builder: (context) => DialogWidget(contact: contact),
                                  );
                                  if (data != null) {
                                    Contact updated = Contact(
                                      id: data['id'],
                                      name: data["name"],
                                      phone: data['phone'],
                                      image: data['image'],
                                    );
                                    await contactsViewmodel.editContact(updated);
                                    setState(() {
                                      contactsViewmodel.getContacts();
                                    });
                                  }
                                },
                                icon: const Icon(Icons.edit, color: Colors.blue),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await contactsViewmodel.deleteContact(contact.id);
                                  setState(() {
                                    contactsViewmodel.getContacts();
                                  });
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            contact.phone,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                            backgroundImage: contact.image != null && Uri.tryParse(contact.image!) != null
                                ? NetworkImage(contact.image!)
                                : null,
                            child: contact.image == null || !Uri.tryParse(contact.image!)!.isAbsolute
                                ? Text(
                                    contact.name.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 20),
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
