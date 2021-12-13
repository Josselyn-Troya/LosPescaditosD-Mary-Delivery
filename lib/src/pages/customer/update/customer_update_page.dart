import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/pages/customer/update/customer_update_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';

class CustomerUpdatePage extends StatefulWidget {
  const CustomerUpdatePage({ Key key }) : super(key: key);

  @override
  _CustomerUpdatePageState createState() => _CustomerUpdatePageState();
}

class _CustomerUpdatePageState extends State<CustomerUpdatePage> {

  CustomerUpdateController _con = new CustomerUpdateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar perfil'),
      ),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column (
                children: [  
                  SizedBox(height: 50),
                  
                  _imageUser(), 
                  
                  _textName(),
                  _textLastName(),
                  _textPhone(),
        
                  
                  
                ],
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: _buttonRegister(),
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



Widget _buttonRegister(){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
    child: ElevatedButton(
      onPressed: _con.isEnable ? _con.update : null, 
      child: Text('ACTUALIZAR PERFIL'),
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
  return GestureDetector(
    onTap: _con.showAlertDialog,
    child:  CircleAvatar(
        backgroundImage: _con.imageFile != null 
        ? FileImage(_con.imageFile)
        : _con.user?.image !=null ? NetworkImage(_con.user.image)
        : AssetImage('assets/img/user_icon.png'),
        radius: 40,
        backgroundColor: Colors.white,
      )
  );
}
void refresh(){
  setState(() {
    
  });
}
}