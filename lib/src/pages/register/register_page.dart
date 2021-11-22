import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/pages/register/register_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ Key key }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  RegisterController _con = new RegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column (
                children: [               
                  _iconBack(),
                  _imageUser(), 
                  /* _textRegister(), */
                  _textEmail(),
                  _textName(),
                  _textLastName(),
                  _textPhone(),
                  _textPassword(),
                  _textConfirmPassword(),
                  _buttonRegister(),
                  
                ],
              )
            )
          ],
        ),
      )
    );
  }

  Widget _textRegister(){
  return Container(
    margin: EdgeInsets.only(
      top: 10,
      bottom: 20
    ),
    child: Text(
        'Registrarse',
        style: TextStyle(
          color: MyColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      
    )
  );
}

Widget _iconBack(){
  return Row(
    children: [
      IconButton(
        onPressed: () {}, 
      icon: Icon(
        Icons.arrow_back_ios,
        color: MyColors.primaryColor,
      )),
    ],
  );
}


Widget _textEmail(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    decoration: BoxDecoration(
      
    ),
    child: TextField(
      controller: _con.emailController,
      keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Correo electronico',
             /* border: InputBorder.none, */ 
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                color: MyColors.primaryColor
              ),
              prefixIcon: Icon(
                Icons.email,
                color: MyColors.primaryColor,
              )
            ),
    ),
  );
}

Widget _textName(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    decoration: BoxDecoration(
      
    ),
    child: TextField(
      controller: _con.nameController,
            decoration: InputDecoration(
              hintText: 'Nombre',
             /* border: InputBorder.none, */ 
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                color: MyColors.primaryColor
              ),
              prefixIcon: Icon(
                Icons.person,
                color: MyColors.primaryColor,
              )
            ),
    ),
  );
}

Widget _textLastName(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    decoration: BoxDecoration(
      
    ),
    child: TextField(
      controller: _con.lastnameController,
            decoration: InputDecoration(
              hintText: 'Apellido',
             /* border: InputBorder.none, */ 
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                color: MyColors.primaryColor
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: MyColors.primaryColor,
              )
            ),
    ),
  );
}

Widget _textPhone(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    decoration: BoxDecoration(
      
    ),
    child: TextField(
      controller: _con.phoneController,
      keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Telefono',
             /* border: InputBorder.none, */ 
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                color: MyColors.primaryColor
              ),
              prefixIcon: Icon(
                Icons.phone,
                color: MyColors.primaryColor,
              )
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
      controller: _con.passwordController,
      obscureText: true,
            decoration: InputDecoration(
              hintText: 'Contraseña',
             /* border: InputBorder.none, */ 
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                color: MyColors.primaryColor
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: MyColors.primaryColor,
              )
            ),
    ),
  );
}

Widget _textConfirmPassword(){
 return Container(
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    decoration: BoxDecoration(
      
    ),
    child: TextField(
      controller: _con.confirmPasswordController,
      obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirmar contraseña',
             /* border: InputBorder.none, */ 
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                color: MyColors.primaryColor
              ),
              prefixIcon: Icon(
                Icons.lock_open,
                color: MyColors.primaryColor,
              )
            ),
    ),
  );
}

Widget _buttonRegister(){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
    child: ElevatedButton(
      onPressed: _con.register, 
      child: Text('REGISTRARSE'),
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

Widget _imageUser() {
  return CircleAvatar(
    backgroundImage: AssetImage('assets/img/user_icon.png'),
    radius: 40,
    backgroundColor: Colors.white,
  );
}

}