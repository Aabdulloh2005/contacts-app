import 'package:contact_app/models/contact.dart';
import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final Contact? contact;
  DialogWidget({this.contact, super.key});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: contact?.name);
    final _phoneController = TextEditingController(text: contact?.phone);
    final _imageController = TextEditingController(text: contact?.image);

    return AlertDialog(
      title: Text(contact == null ? "Add a contact" : "Edit contact"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            textInputAction: TextInputAction.next,
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            textInputAction: TextInputAction.next,
            controller: _phoneController,
            decoration: const InputDecoration(
              hintText: "Phone number",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            textInputAction: TextInputAction.done,
            controller: _imageController,
            decoration: const InputDecoration(
              hintText: "Image URL",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, {
              "id": contact?.id ?? DateTime.now().millisecondsSinceEpoch,
              "name": _nameController.text,
              "phone": _phoneController.text,
              "image": _imageController.text.isEmpty ? null : _imageController.text,
            });
          },
          child: const Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
