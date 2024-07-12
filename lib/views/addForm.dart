import 'package:deadlinemanager/view%20model/auth_services.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class AddFormData extends StatelessWidget {
  const AddFormData({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _introductionController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    customTextField(_titleController, "Enter Title", " Title",
                        Icon(Icons.title)),
                    customTextField(
                        _introductionController,
                        "Enter Introduction",
                        " Introduction",
                        Icon(Icons.file_copy_sharp)),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () async {
                                pickFiles();
                              },
                              child: Text("Add Files"))
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        AuthServices().signOutGoogle(context);
                      },
                      child: Text('Add Task'),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget customTextField(TextEditingController controller, String labelText,
      String WarnText, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: icon,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your' + WarnText;
          }
          return null;
        },
      ),
    );
  }

  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    PlatformFile? file = result.files.first;
  }
}
