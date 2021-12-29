import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/pages/admin/orders/list/admin_orders_list_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';

class AdminOrdersListPage extends StatefulWidget {
  const AdminOrdersListPage({ Key key }) : super(key: key);

  @override
  _AdminOrdersListPageState createState() => _AdminOrdersListPageState();
}

class _AdminOrdersListPageState extends State<AdminOrdersListPage> {

  AdminOrdersListController _con = new AdminOrdersListController();


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
       
      ),
      drawer: _drawer(),
      body: Center( 
        child: Text('Administrador'),
      ),
    );
  }

   Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primaryColor
            ),
            child: Column(children: [

              Container(
                height: 60,
                margin: EdgeInsets.only(bottom: 10),
                child: FadeInImage(
                  image: _con.user?.image != null 
                    ? NetworkImage(_con.user?.image)
                    : AssetImage('assets/img/no-image.png'),
                  fit: BoxFit.contain,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('assets/img/no-image.png'),
                ),
              ),

            Text(
              /* if(_con.user != null){} evitar datos nulos*/
              '${_con.user?.name ?? 'no'} ${_con.user?.lastname ?? ''}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              maxLines: 1,
            ),
            Text(
              _con.user?.email ?? '',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              maxLines: 1,
            ),
            Text(
              _con.user?.phone ?? '',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              maxLines: 1,
            ),
          ],)
          ),

          ListTile(
            onTap: _con.goToCategoryCreate,
            title: Text('Crear categoria'),
            trailing: Icon(Icons.list_alt),
          ),
          ListTile(
            onTap: _con.goToProductCreate,
            title: Text('Crear producto'),
            trailing: Icon(Icons.fastfood),
          ),
          
          _con.user != null ?
          _con.user.roles.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
            title: Text('Roles'),
            trailing: Icon(Icons.person),
          ) : Container() : Container(),
          
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.power_settings_new),
          ),
        ],
      ),
    );
  }

  void refresh(){
    setState(() {
      
    });
  }
}