import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/models/category.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';
import 'admin_products_create_controller.dart';

class AdminProductsCreatePage extends StatefulWidget {
  const AdminProductsCreatePage({ Key key }) : super(key: key);

  @override
  _AdminProductsCreatePageState createState() => _AdminProductsCreatePageState();
}

class _AdminProductsCreatePageState extends State<AdminProductsCreatePage> {
  
  AdminProductsCreateController _con =  new AdminProductsCreateController();
  
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
        title: Text('Nuevo producto'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          _textFieldName(),
          _textFieldDescription(),
          _textFieldPrice(),
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                _cardImage(_con.imageFile1, 1),
                _cardImage(_con.imageFile2, 2),
              ],)
          ),
          _dropDownCategories(_con.categories)
        ],
      ),
       bottomNavigationBar: _buttonCreate(), 
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryColor3,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.nameController,
        maxLines: 2,
        maxLength: 180,
        decoration: InputDecoration(
            hintText: 'Nombre del producto',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: Colors.black54
            ),
            suffixIcon: Icon(
              Icons.fastfood,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryColor3,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.descriptionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
            hintText: 'Descripción del producto',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: Colors.black54
            ),
            suffixIcon: Icon(
              Icons.description,
              color: MyColors.primaryColor,
            ),
        ),
      ),
    );
  }

  Widget _textFieldPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryColor3,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.priceController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: InputDecoration(
            hintText: 'Precio',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: Colors.black54
            ),
            suffixIcon: Icon(
              Icons.monetization_on_rounded,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }

  Widget _cardImage(File imageFile, int numberFile){
    return GestureDetector(
      onTap: () {
        _con.showAlertDialog(numberFile);
      },
      child: imageFile !=null 
        ? Card(
          elevation: 3.0,
          child: Container(
           height: 100,
            width: MediaQuery.of(context).size.width * 0.26,
            
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
        )
        : Card(
          elevation: 3.0,
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Image(
              image: AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
            ),
          ),
        )
    );
  }

  Widget _dropDownCategories(List<Category> category){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
          elevation: 2.0,
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(children: [
                  Icon(
                      Icons.search,
                      color: MyColors.primaryColor,
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Categorias',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                      ),
                    )
                ],),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton(
                    underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: MyColors.primaryColor,

                      ),
                    ),
                    elevation: 3,
                    isExpanded: true,
                    hint: Text(
                      'Selecionar categoria',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                      )
                    ),
                    items: _dropDownItems(category),
                    value: _con.idCategory,
                    onChanged: (option) {
                      setState(() {
                        print('Categoria: $option');
                        _con.idCategory = option; //estableciendo el valor seleccionado a la variable idCategory
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories){
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: 
          Text(category.name),
          value: category.id
      ));
     });
     return list;
  }


  Widget _buttonCreate() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.createProduct,
        child: Text('CREAR PRODUCTO'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

}