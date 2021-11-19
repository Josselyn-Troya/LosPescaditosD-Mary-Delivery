import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
                /* color: MyColors.primaryColor, */
        /* width: double.infinity, */
        child :Stack (
          children: [
            
            Column (
              children: [
                _imageLogo(),
                _textLogin(),
                _textEmail(),
                _textPassword(),
                _buttonLogin(),
                _textRow(),
              ],
            )
          ] 
        )
      )
    );
  }

Widget _imageLogo(){
  return Container(
    margin: EdgeInsets.only(
      top: 10, 
      bottom: MediaQuery.of(context).size.height * 0.05
      ),
    child: Image.asset(
            'assets/img/logopez.jpg',
              width: 150,
              height: 150,
    )
  );
}

Widget _textLogin(){
  return Container(
    margin: EdgeInsets.only(
      top: 10,
      bottom: 20
    ),
    child: Text(
        'Iniciar sesión',
        style: TextStyle(
          color: MyColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      
    )
  );
}

Widget _textEmail(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    decoration: BoxDecoration(
      
    ),
    child: TextField(
            decoration: InputDecoration(hintText: 'Correo electronico',
            /* border: InputBorder.none, */
            contentPadding: EdgeInsets.all(0)
            ),
    ),
  );
}

Widget _textPassword(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    decoration: BoxDecoration(
      
    ),
    child: TextField(
            decoration: InputDecoration(hintText: 'Contraseña',
            /* border: InputBorder.none, */
            contentPadding: EdgeInsets.all(0)
            ),
    ),
  );
}

Widget _buttonLogin(){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
    child: ElevatedButton(
      onPressed: () {}, 
      child: Text('INGRESAR'),
      style: ElevatedButton.styleFrom(
        primary: MyColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        padding: EdgeInsets.symmetric(vertical: 20)
      ),
    )
  );
}

Widget _textRow(){
  return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No tienes una cuenta?',
                  style: TextStyle(
                  color: MyColors.primaryColor
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'register');
                  },
                  child: Text(
                        'REGISTRATE', 
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryColor
                        ),
                      ),
                )
              ],
            );
}



}