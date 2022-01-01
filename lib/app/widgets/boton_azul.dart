import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final String? text;
  final VoidCallback? onPressed;
  final Color? color;

  const BotonAzul({
    Key? key, 
    @required this.text, 
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(2),
          backgroundColor: MaterialStateProperty.all<Color>(color ?? Colors.blue),
          shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text( text! , style: const TextStyle( color: Colors.white, fontSize: 17 )),
          ),
        ),
    );
  }

}