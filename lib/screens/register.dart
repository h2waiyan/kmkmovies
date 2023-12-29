import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moviesdb/screens/chat.dart';
import 'package:moviesdb/screens/home.dart';
import 'package:moviesdb/screens/login.dart';
import 'package:moviesdb/screens/verify.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Register'),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    credential.user!.sendEmailVerification();

                    if (mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Verify()));
                    }
                  } on FirebaseAuthException catch (e) {
                    var errorText = '';

                    if (e.code == 'weak-password') {
                      errorText = 'The password provided is too weak.';
                    } else if (e.code == 'email-already-in-use') {
                      errorText = 'The account already exists for that email.';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(errorText),
                      backgroundColor: Colors.red,
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: const Text("Register")),
            const Text(
              "OR",
            ),
            ElevatedButton(
                onPressed: () async {
                  UserCredential gUsr = await signInWithGoogle();

                  if (mounted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatScreen()));
                  }
                },
                child: const Text("Sign in With Google"))
          ],
        ),
      ),
    );
  }
}
