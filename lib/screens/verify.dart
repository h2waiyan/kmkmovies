import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviesdb/screens/login.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
                'I have sent a verification link to your email. Please verify your email to continue'),
            ElevatedButton(
                onPressed: () async {
                  try {
                    User? currentUser = FirebaseAuth.instance.currentUser;

                    await currentUser!.reload();
                    currentUser = FirebaseAuth.instance.currentUser;

                    if (currentUser!.emailVerified == true) {
                      if (mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                              'Please verify your email',
                            ),
                            backgroundColor: Colors.red),
                      );
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text("I've aleready verified my email")),
          ],
        ),
      ),
    );
  }
}
