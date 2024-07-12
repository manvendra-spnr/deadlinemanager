import 'dart:io';

import 'package:deadlinemanager/models/utils/colors.dart';
import 'package:deadlinemanager/models/utils/images.dart';
import 'package:deadlinemanager/view%20model/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserRegistration extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

File? _image;
final picker = ImagePicker();

bool hide = true;
final _formKey = GlobalKey<FormState>();
final _firstNameController = TextEditingController();
final _lastNameController = TextEditingController();
final _dobController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();
// final databaseReference = FirebaseDatabase.instance.ref("USER DETAILS");

class _RegistrationPageState extends State<UserRegistration> {
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Remove existing image'),
            onPressed: () {
              setState(() {
                _image = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: showOptions,
                  child: _image == null
                      ? Stack(
                          // alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              // backgroundColor:
                              // _image == null ? UiColors.grey : UiColors.iconColor,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(75),
                                child: Image.asset(
                                  userLogo,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              radius: 75,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          ],
                        )
                      : CircleAvatar(
                          radius: 75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.file(
                              _image!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      customTextField(_firstNameController, "First Name",
                          " first name", Icon(Icons.person)),
                      customTextField(_lastNameController, "Last Name",
                          " last name", Icon(Icons.person)),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: UiColors.themeColor)),
                          labelText: 'Date of Birth (MM/DD/YYYY)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dobController.text =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      customTextField(_emailController, "Email", " Email",
                          Icon(Icons.email)),
                      customTextField(_passwordController, "Password",
                          " Password", Icon(Icons.lock)),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: UiColors.themeColor)),
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hide = !hide;
                                });
                              },
                              icon: hide
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: hide,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            sendVerificationEmail();
                            AuthServices().signUpUser(_emailController.text,
                                _passwordController.text, context);
                            _firstNameController.clear();
                            _lastNameController.clear();
                            _emailController.clear();
                            _passwordController.clear();
                            _dobController.clear();
                            _confirmPasswordController.clear();
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith(
                                  (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => UiColors.themeColor)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: UiColors.themeColor)),
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

  // @override
  // void dispose() {
  //   _firstNameController.dispose();
  //   _lastNameController.dispose();
  //   _dobController.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   _confirmPasswordController.dispose();
  //   super.dispose();
  // }
}
