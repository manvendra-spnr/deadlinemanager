import 'package:deadlinemanager/models/utils/colors.dart';
import 'package:deadlinemanager/models/utils/images.dart';
import 'package:deadlinemanager/view%20model/auth_services.dart';
import 'package:deadlinemanager/views/userRegistration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var hide = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff2ecc87)),
                  image: DecorationImage(
                    image: AssetImage(userLogo),
                    fit: BoxFit.contain,
                  ),
                  // color: Colors.grey,
                  borderRadius: BorderRadius.circular(80)),
            ),
            SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTextField(
                      _emailController,
                      "Email",
                      Icon(Icons.email),
                      " Email",
                      false,
                      Container(
                        width: 1,
                        height: 1,
                      )),
                  SizedBox(height: 16),
                  customTextField(
                      _passwordController,
                      "Password",
                      Icon(Icons.lock),
                      " Password",
                      hide,
                      IconButton(
                          onPressed: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          icon: hide
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility))),
                  SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        AuthServices().signInUser(_emailController.text,
                            _passwordController.text, context);
                      },
                      child: Text(
                        "Login",
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
                  ),
                  Text("OR"),
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        AuthServices().signInWithGoogle(context);
                        print("USER ADDED");
                      },
                      child: Text(
                        "Login with Google",
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
                  ),
                  Column(
                    children: [
                      Divider(
                        thickness: 1,
                        color: Colors.black,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserRegistration()));
                      },
                      child: Container(
                          height: 65,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: UiColors.iconColor,
                              border: Border.all(color: UiColors.themeColor),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 24,
                                color: UiColors.themeColor,
                                fontWeight: FontWeight.w700),
                          ))),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextField(TextEditingController controller, String labelText,
      Icon icon, String WarnText, bool hide, Widget suffix) {
    return TextFormField(
      controller: controller,
      obscureText: hide,
      decoration: InputDecoration(
        labelText: labelText,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: UiColors.themeColor)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: icon,
        suffixIcon: suffix,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your' + WarnText;
        }
        return null;
      },
    );
  }
}
