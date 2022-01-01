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

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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

                const Logo( titulo: 'Mensagens' ),

                _Form(),

                const Labels( 
                  ruta: 'register',
                  titulo: 'Não possui uma conta?',
                  subTitulo: 'Criar uma agora',
                ),

                const Text('Termos e condições de uso', style: TextStyle( fontWeight: FontWeight.w200 ))

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

  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
       child: Column(
         children: <Widget>[
           
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
             text: 'Entrar',
             color: authService.loading ? Colors.grey : null,
             onPressed: authService.loading ? null : () async {

               FocusScope.of(context).unfocus();
               final loginResult = await authService.login(emailCtrl.text, passCtrl.text);
               
               if ( loginResult is bool ?  loginResult : loginResult.isEmpty ) {
                  
                  socketService.connect();
                  Navigator.pushReplacementNamed(context, 'users');
               
               } else {
                  
                  Environment.msngrKey.currentState!.showMaterialBanner(
                    customMaterialBanner(loginResult, onPressed: () => Environment.msngrKey.currentState?.hideCurrentMaterialBanner())
                  );

              }

             },
           ),

         ],
       ),
    );
  }

}
