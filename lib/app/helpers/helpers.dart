import 'package:flutter/material.dart';

MaterialBanner customMaterialBanner(String msg, {VoidCallback? onPressed}) {
  return MaterialBanner(
    content: Text( msg, style: const TextStyle(color: Colors.white )), 
    leading: const Icon(Icons.error, color: Colors.white),
    backgroundColor: Colors.red[400],
    actions: [
      IconButton(
        icon: const Icon( Icons.close, color: Colors.white ),
        onPressed: onPressed,
      ),
    ],
  );
}