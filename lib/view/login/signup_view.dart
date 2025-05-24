import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:fitness/view/login/login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to save user data to Firestore
  Future<void> _saveUserToFirestore(User user, {String? firstName, String? lastName}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'firstName': firstName ?? user.displayName?.split(' ').first ?? '',
        'lastName': lastName ?? user.displayName?.split(' ').last ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save user data: $e")),
      );
    }
  }

  // Email/Password Registration
  Future<void> _registerUser() async {
    if (!isCheck) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please accept the terms.")),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save user data to Firestore
      await _saveUserToFirestore(
        userCredential.user!,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileView()),
      );
    } on FirebaseAuthException catch (e) {
      String error = "Registration failed.";
      if (e.code == 'email-already-in-use') {
        error = 'Email is already in use.';
      } else if (e.code == 'weak-password') {
        error = 'Password is too weak.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  // Google Sign-In
  Future<void> _signInWithGoogle() async {
    try {
      // Initialize Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Save user data to Firestore
      await _saveUserToFirestore(userCredential.user!);

      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text("Hey there,", style: TextStyle(color: TColor.gray, fontSize: 16)),
                Text("Create an Account", style: TextStyle(color: TColor.black, fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: media.width * 0.05),

                RoundTextField(
                  controller: _firstNameController,
                  hitText: "First Name",
                  icon: "assets/img/user_text.png",
                ),
                SizedBox(height: media.width * 0.04),

                RoundTextField(
                  controller: _lastNameController,
                  hitText: "Last Name",
                  icon: "assets/img/user_text.png",
                ),
                SizedBox(height: media.width * 0.04),

                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: media.width * 0.04),

                RoundTextField(
                  controller: _passwordController,
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: true,
                  rigtIcon: TextButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        "assets/img/show_password.png",
                        width: 20,
                        height: 20,
                        color: TColor.gray,
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
                        color: TColor.gray,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "By continuing you accept our Privacy Policy and\nTerm of Use",
                        style: TextStyle(color: TColor.gray, fontSize: 10),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: media.width * 0.1),

                RoundButton(
                  title: "Register",
                  onPressed: _registerUser,
                ),

                SizedBox(height: media.width * 0.04),

                Row(
                  children: [
                    Expanded(child: Divider(color: TColor.gray.withOpacity(0.5))),
                    Text("  Or  ", style: TextStyle(color: TColor.black, fontSize: 12)),
                    Expanded(child: Divider(color: TColor.gray.withOpacity(0.5))),
                  ],
                ),

                SizedBox(height: media.width * 0.04),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton("assets/img/google.png", _signInWithGoogle),
                    SizedBox(width: media.width * 0.04),
                    _buildSocialButton("assets/img/facebook.png", () {
                      // Add Facebook Sign-In logic here if needed
                    }),
                  ],
                ),

                SizedBox(height: media.width * 0.04),

                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginView()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Already have an account? ", style: TextStyle(color: TColor.black, fontSize: 14)),
                      Text("Login", style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),

                SizedBox(height: media.width * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TColor.white,
          border: Border.all(width: 1, color: TColor.gray.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(assetPath, width: 20, height: 20),
      ),
    );
  }
}