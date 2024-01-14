import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/Admin/Pages/ListStall.dart';
import 'package:fyp2/GeneralUser/UserNavigate/navigation.dart';
import 'package:fyp2/Models/geofence.dart';
import 'package:fyp2/Models/users.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GeofenceModel geofenceModel = GeofenceModel();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(
        {
          'token': token
        },SetOptions(merge: true));
  }

  Future updateAccount() async{

    final DocumentReference geofence = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

    return await geofence.update({'account':"Active"});
  }

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
                "Welcome to OrderJeLah!",
                style: TextStyle(
                  fontSize: 45,
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
                        updateAccount();
                        storeNotificationToken();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const PagesNavigate()));
                      }
                    }
                  }
              ),
              SizedBox(
              height: screenHeight * .05,
              ),
            TextButton(
                onPressed: () => Navigator.push(
                context,
            MaterialPageRoute(
              builder: (_) => const RegisterScreen(),
              ),
            ),
              child: RichText(
                  text: const TextSpan(
                  text: "I'm a new user, ",
                  style: TextStyle(color: Colors.black),
                  children: [
                      TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                                 ),
                               ),
                              ],
                             ),
                           ),
              )
            ],
          ),
        )
      ),
    );
  }
}



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({ Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String status = "default";
  String category = "Customer";
  String account = "default";

  storeNotificationToken() async{
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(
        {
          'token': token
        },SetOptions(merge: true));
  }


  postDetailsToFirestore() async{
    //calling Firestore
    //calling user model
    //sending value
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = emailController.text;
    userModel.name = nameController.text;
    userModel.phone = phoneController.text;
    userModel.status = status;
    userModel.category = category;
    userModel.account = account;
    userModel.uid = user!.uid;

    await firebaseFirestore
      .collection("users")
      .doc(user.uid)
      .set(userModel.toMap());

    Fluttertoast.showToast(msg:"Account created Successfully");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => const LoginScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:  Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: screenHeight * .065),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                "Sign up to get started!",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
              SizedBox(height: screenHeight * .065),
              TextFormField(
                autofocus: true,
                controller: nameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("name is required.");
                  }
                  return null;
                },
                onSaved: (value) {
                  nameController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Enter Your Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
              ),
              SizedBox(height: screenHeight * .025),
              TextFormField(
                autofocus: true,
                controller: phoneController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  RegExp regex = RegExp(r'^.{10,}$');
                  if (value!.isEmpty) {
                    return ("Phone number is required.");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Please enter a valid phone number.");
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Enter Your Phone Number",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
              ),
              SizedBox(height: screenHeight * .025),
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
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Enter Your Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
              ),
              SizedBox(height: screenHeight * .025),
              TextFormField(
                autofocus: false,
                controller: confirmPasswordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: (value) {
                  RegExp regex = RegExp(r'^.{6,}$');
                  if (value!.isEmpty) {
                    return ("Password is required.");
                  }
                  if (confirmPasswordController.text != passwordController.text) {
                    return ("Password does not match.");
                  }
                  return null;
                },
                onSaved: (value) {
                  confirmPasswordController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Re-type Your Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
              ),
              SizedBox(
                height: screenHeight * .075,
              ),
              FormButton(
                  text: "Create an account",
                  onPressed: () async {
                    if (_formKey.currentState!.validate())  {
                      await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                        postDetailsToFirestore();

                        // Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }
                  }
              ),
              SizedBox(
                height: screenHeight * .05,
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                ),
                child: RichText(
                  text: const TextSpan(
                    text: "I already have a account ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Sign In",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
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