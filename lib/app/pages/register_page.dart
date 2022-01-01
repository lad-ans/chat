import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global/environment.dart';
import '../helpers/helpers.dart';
import '../services/auth_services.dart';
import '../services/socket_service.dart';
import '../widgets/boton_azul.dart';
import '../widgets/custom_input.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                const Logo( titulo: 'Registrar' ),

                _Form(),

                const Labels( 
                  ruta: 'login',
                  titulo: 'Tens uma conta?',
                  subTitulo: 'Entrar!',
                ),

                const Text( 'Termos e condições', style: TextStyle( fontWeight: FontWeight.w200 ))

              ],
            ),
          ),
        ),
      )
   );
  }
}



class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final service = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
       child: Column(
         children: <Widget>[
           
           CustomInput(
             icon: Icons.perm_identity,
             placeholder: 'Nome',
             keyboardType: TextInputType.text, 
             textController: nameCtrl,
           ),

           CustomInput(
             icon: Icons.mail_outline,
             placeholder: 'E-mail',
             keyboardType: TextInputType.emailAddress, 
             textController: emailCtrl,
           ),

           CustomInput(
             icon: Icons.lock_outline,
             placeholder: 'Senha',
             textController: passCtrl,
             isPassword: true,
           ),
           

           BotonAzul(
             text: 'Registrar',
             color: service.loading ? Colors.grey : null,
             onPressed: service.loading ? null : () async {

               FocusScope.of(context).unfocus();
               final registerresult = await service.register(nameCtrl.text, emailCtrl.text, passCtrl.text);

               if ( registerresult is bool ?  registerresult : registerresult.isEmpty ) {
                 
                 socketService.connect();
                 Navigator.pushReplacementNamed(context, 'users');
               
               } else {
                 
                 Environment.msngrKey.currentState!.showMaterialBanner(
                   customMaterialBanner(registerresult, onPressed: () => Environment.msngrKey.currentState?.hideCurrentMaterialBanner())
                 );

               }

             },
           ),

         ],
       ),
    );
  }
}
