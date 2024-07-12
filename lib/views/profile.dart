import 'dart:io';

import 'package:deadlinemanager/models/utils/colors.dart';
import 'package:deadlinemanager/models/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var name = TextEditingController();
  DateTime? _selectedDate;
  File? _image;
  final picker = ImagePicker();

//Image Picker function to get image from gallery
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: UiColors.themeColor,
        centerTitle: true,
        title: Text(
          "Update Profile",
          style:
              TextStyle(color: UiColors.iconColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: GestureDetector(
                onTap: showOptions,
                child: _image == null
                    ? Stack(
                        // alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            // backgroundColor:
                            // _image == null ? UiColors.grey : UiColors.iconColor,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(52),
                              child: Image.asset(
                                userLogo,
                                height: 104,
                                width: 104,
                                fit: BoxFit.fill,
                              ),
                            ),
                            radius: 52,
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
                        radius: 52,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(52),
                          child: Image.file(
                            _image!,
                            height: 104,
                            width: 104,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
              )),
              SizedBox(
                height: 45,
              ),
              Text("Name"),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                    focusColor: Colors.amber,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: "Name",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                height: 25,
              ),
              Text("Birthday"),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: "mm/dd/yyyy",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : '',
                  )),
              SizedBox(
                height: 45,
              ),
              Container(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (name.text == "" || _selectedDate == null)
                      ? () {
                          print("FILL ALL DETAILS");
                        }
                      : () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => EditProfile()));
                        },
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => UiColors.themeColor)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
