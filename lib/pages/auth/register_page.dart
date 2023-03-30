import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/helper/helper_function.dart';
import 'package:my_chat_app/pages/auth/login_page.dart';
import 'package:my_chat_app/pages/home_page.dart';
import 'package:my_chat_app/service/auth_service.dart';
import 'package:my_chat_app/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ), // Default color is blue
      // The body can be a SingleChildScrollView only when the _isloading is done
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("Bash!",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text("Create your account now to explore",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400)),

                      const SizedBox(height: 40),

                      Image.asset("assets/register.jpg"),

                      const SizedBox(height: 40),

                      // Enter user's full name
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person_2,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            fullName = val;
                          });
                        },

                        // Check the validation
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Name cannot be empty";
                          }
                        },
                      ),

                      const SizedBox(height: 15),

                      // Enter email
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                            //print(email);
                          });
                        },

                        // Check the validation
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),

                      const SizedBox(height: 15),

                      // Enter password
                      TextFormField(
                        obscureText:
                            true, // Hide the password when user entering
                        decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            )),

                        // Check the validation
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                            //print(password);
                          });
                        },
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       login();
                      //     },
                      //     child: Text("TEST"))
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                color: Color(0xFF463f3a), fontSize: 16),
                          ),
                          onPressed: () {
                            register();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(TextSpan(
                        text: "Already have an account? ",
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const LoginPage());
                                })
                        ],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // save the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserNameSF(fullName);
          await HelperFunctions.saveUserEmailSF(email);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
