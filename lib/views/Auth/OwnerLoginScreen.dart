
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/Admin/Pages/ListStall.dart';
import 'package:fyp2/FoodStallOwner/OwnerNavigate/StallNavigation.dart';

class OwnerLoginScreen extends StatefulWidget {

  final Function( String? email, String? password)? onSubmitted;

  const OwnerLoginScreen({this.onSubmitted, Key? key}) : super(key: key);
  @override
  _OwnerLoginScreenState createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
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

              SizedBox(height: screenHeight * .075),
              const Text(
                "Welcome Home Seller,",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                "Sign in to continue!",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black.withOpacity(.6),
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

                        if(emailController.text == "admin@gmail.com"){
                          await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const ListStall()));
                        }
                        else {
                          await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const OwnerPagesNavigate()));
                        }
                      }
                  }
              ),
            ],
          ),
        )
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