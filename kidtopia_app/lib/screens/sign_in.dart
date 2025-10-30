import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget{
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInState();
}

class _SignInState extends State<SignInScreen>{
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Kidtopia Sign In')),
      body: const Center(
        child: Text ('Sign In Screen'),
      ),
    );
  }
}