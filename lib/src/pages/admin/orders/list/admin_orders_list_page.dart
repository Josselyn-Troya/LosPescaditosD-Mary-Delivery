import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/models/order.dart';
import 'package:lospescaditosdmary/src/pages/admin/orders/list/admin_orders_list_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';
import 'package:lospescaditosdmary/src/utils/relative_time.dart';
import 'package:lospescaditosdmary/src/widgets/no_data_widget.dart';

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
    return DefaultTabController(
      length: _con.status?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: Column(
              children: [
                SizedBox(height: 50),
                _menuDrawer(),
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.status.length, (index) {
                return Tab(
                  child: Text(_con.status[index] ?? ''),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children: _con.status.map((String status) {
            return FutureBuilder(
                future: _con.getOrders(status),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {

                  if (snapshot.hasData) {

                    if (snapshot.data.length > 0) {
                      return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardOrder(snapshot.data[index]);
                          }
                      );
                    }
                    else {
                      return NoDataWidget(text: 'No hay ordenes');
                    }
                  }
                  else {
                    return NoDataWidget(text: 'No hay ordenes');
                  }
                }
            );
          }).toList(),
        ),
      ),
    );
  }


   Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () {
       _con.openModalBottomSheet(order);
      },
      child: Container(
        height: 155,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )
                    ),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Orden #${order.id}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'NimbusSans'
                        ),
                      ),
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 45, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                        'Fecha del pedido: ${RelativeTime.getRelativeTime(order.timestamp ?? 0)}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Cliente: ${order.customer?.name ?? ''} ${order.customer?.lastname ?? ''}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Dirección: ${order.address?.address ?? ''}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Icon(
              Icons.menu,
              color: Colors.black,
            ),
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
                child: ClipOval(
                  child: FadeInImage(
                    image: _con.user?.image != null 
                      ? NetworkImage(_con.user?.image)
                      : AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
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
            title: Text('Crear una nueva categoría'),
            trailing: Icon(Icons.list_alt),
          ),
          ListTile(
            onTap: _con.goToProductCreate,
            title: Text('Crear un nuevo producto'),
            trailing: Icon(Icons.fastfood),
          ),
          
          _con.user != null ?
          _con.user.roles.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
            title: Text('Seleccionar otro usuario para ingresar'),
            trailing: Icon(Icons.supervised_user_circle_rounded),
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