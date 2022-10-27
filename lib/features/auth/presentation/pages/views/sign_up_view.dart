import 'package:flutter/material.dart';

class TextFieldSignUp extends StatelessWidget{
  const TextFieldSignUp({ Key? key,required  this.hintText,
    this.isHidden,
    required  this.controller}) : super(key: key);

  final String hintText;
  final bool? isHidden;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.5),
      child: TextField(
        style: const TextStyle(fontSize: 16, color: Colors.white),
        controller: controller,
        obscureText: isHidden ?? false,
        decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white54.withOpacity(0.2),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54)),
      ),
    );

  }

}

class ButtonSignUp extends StatelessWidget {
  const ButtonSignUp({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 50,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.5),
        side: BorderSide(color: Colors.white54.withOpacity(0.2), width: 2),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}