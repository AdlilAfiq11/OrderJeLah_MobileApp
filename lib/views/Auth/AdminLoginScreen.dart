
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/Admin/Pages/ListStall.dart';

class AdminLoginScreen extends StatefulWidget {

  const AdminLoginScreen({ Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: screenHeight * .1),
              const Text(
                "OrderJelah!: Administrator",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              const Text(
                "Sign in to continue",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * .05),
              TextFormField(
                autofocus: true,
                controller: emailController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  RegExp regex = RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                  if (value!.isEmpty) {
                    return ("Email is required.");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Please enter a valid email.");
                  }
                  return null;
                },
                onSaved: (value) {
                  emailController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Enter Your Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
              ),
              SizedBox(height: screenHeight * .025),
              TextFormField(
                autofocus: false,
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: (value) {
                  RegExp regex = RegExp(r'^.{6,}$');
                  if (value!.isEmpty) {
                    return ("Password is required.");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Please enter a valid password.");
                  }
                  return null;
                },
                onSaved: (value) {
                  passwordController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Enter Your Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
              ),
              SizedBox(
                height: screenHeight * .075,
              ),
              FormButton(
                  text: "Log In",
                  onPressed: () async {
                    if (_formKey.currentState!.validate())  {
                      await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const ListStall()));

                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FormButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  const FormButton({this.text = "", this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  const InputField(
      {this.labelText,
        this.onChanged,
        this.onSubmitted,
        this.errorText,
        this.keyboardType,
        this.textInputAction,
        this.autoFocus = false,
        this.obscureText = false,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

