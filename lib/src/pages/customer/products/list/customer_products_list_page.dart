import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/models/category.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/pages/customer/products/list/customer_products_list_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';
import 'package:lospescaditosdmary/src/widgets/no_data_widget.dart';

class CustomerProductsListPage extends StatefulWidget {

  Product product;

  CustomerProductsListPage({ Key key, @required this.product }) : super(key: key);

  @override
  _CustomerProductsListPageState createState() => _CustomerProductsListPageState();
}

class _CustomerProductsListPageState extends State<CustomerProductsListPage> {

  CustomerProductsListController _con = new CustomerProductsListController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories?.length,
      child: Scaffold(
        key: _con.key,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            
            actions: [
              _shoppingCar()
            ],
            flexibleSpace: Column(
              children: [
                SizedBox(height: 35),
                _menuDrawer(),
                _textFieldSearch()
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.categories.length, (index){
                return Tab(
                  child: Text(
                    _con.categories[index].name ?? ''
                  ),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children: _con.categories.map((Category category) {
            return FutureBuilder( //listar info de la base de datos 
                future:_con.getProducts(category.id, _con.productName),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {

                  if (snapshot.hasData) { //si tiene informacion

                    if (snapshot.data.length > 0) { //si tiene mas de un elemento
                      return GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7
                          ),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardProduct(snapshot.data[index]);
                          }
                      );
                    }
                    else {
                      return NoDataWidget(text: 'No hay productos para mostrar');
                    }
                  }
                  else {
                    return NoDataWidget(text: 'No hay productos para mostrar');
                  }
                }
            );
          }).toList(),
        )
      )
    );
  }

  Widget _cardProduct(Product product) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(product);
      },
      child: Container(
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 200,
                  right: 1.0,
                  child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(20)
                        )
                      ),
                      child: IconButton(
                        onPressed: _con.addToCar,
                        icon: Icon(Icons.add),
                        color: Colors.white,),
                    ),

              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(20),
                    child: FadeInImage(
                      image: product.image1 != null
                          ? NetworkImage(product.image1)
                          : AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 10),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 33,
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'NimbusSans'
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6.5),
                    child: Text(
                      '${product.price ?? 0}\$',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NimbusSans'
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _shoppingCar() {
    return GestureDetector(
      onTap: _con.goToOrderCreatePage,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15, top: 13),
            child: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFieldSearch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextField(
        onChanged: _con.searchText,
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(
            Icons.search,
            color: Colors.grey[400]
          ),
          hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey[500]
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.grey[300]
            )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color: Colors.grey[300]
              )
          ),
          contentPadding: EdgeInsets.all(15)
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
                child: FadeInImage(
                  image: _con.user?.image != null 
                    ? NetworkImage(_con.user?.image)
                    : AssetImage('assets/img/no-image.png'),
                  fit: BoxFit.contain,
                  fadeInDuration: Duration(milliseconds: 10),
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
            onTap: _con.goToUpdatePage,
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            onTap: _con.goToOrdersList,
            title: Text('Mis compras'),
            trailing: Icon(Icons.shopping_cart),
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