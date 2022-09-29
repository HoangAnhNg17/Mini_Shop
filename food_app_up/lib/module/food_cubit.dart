import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItemCubit extends Cubit<ItemState>{
  ListItemCubit() : super(InitState());

  List<ItemModel> listItem = [];
  List<ItemModel> listItemSelected = [];
  List<String> itemNames = [
    'Gà KFC',
    'Trà sữa',
    'Vịt quay bắc kinh',
    'Sữa chua hạ long',
    'Gà ủ muối',
    'Bia Tiger',
    'Spaghetti',
    'Pizza',
    'Bánh mì hội an',
    'Phở thìn',
    'Chân gà',
    'Coffee',
    'Trà',
    'Xôi',
    'Cơm',
  ];
  SharedPreferences? sharedPreferences;


  Future convertStringToListItem() async{
    emit(ItemGettingState());
    await Future.delayed(Duration(seconds: 2));
    if(sharedPreferences == null){
      sharedPreferences = await SharedPreferences.getInstance();
    }

    Map<String,dynamic> jsonData = Map<String,dynamic>();
    List<String>? dataString = [];

    if(sharedPreferences?.getStringList('listItem') == null){

      for(String name in itemNames){
        Random random = Random();
        ItemModel model = ItemModel(
          name,
          Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1),
          42,
          0,
        );
        jsonData['name'] = model.name;
        jsonData['cnt'] = model.cnt;
        jsonData['price'] = model.price;
        jsonData['color'] = model.color.value;
        dataString.add(jsonEncode(jsonData));
        listItem.add(model);
      }
      await sharedPreferences!.setStringList('listItem', dataString);
    }else{
      dataString = sharedPreferences!.getStringList('listItem');
      for(String data in dataString!){
        jsonData = jsonDecode(data);
        Color color = Color(jsonData['color']);
        ItemModel model = ItemModel(jsonData['name'], color, jsonData['price'], jsonData['cnt']);
        listItem.add(model);
      }
    }

    emit(ItemGetSuccessState());
  }

  void addItemToCart(ItemModel model){
    model.cnt = 1;
    listItemSelected.add(model);
    saveDataFromLocal();
    emit(ItemGetSuccessState());
  }

  int Sum(){
    int sum = 0;
    for(ItemModel model in listItemSelected){
      sum += (model.cnt * model.price);
    }
    return sum;
  }

  void increment(ItemModel model){
    model.cnt += 1;
    Sum();
    saveDataFromLocal();
    emit(ItemGetSuccessState());
  }

  void decrement(ItemModel model){
    model.cnt -= 1;
    if(model.cnt == 0){
      listItemSelected.removeWhere((element) => model.color == element.color && model.name == element.name);
    }
    Sum();
    saveDataFromLocal();
    emit(ItemGetSuccessState());
  }

  Future saveDataFromLocal() async{
    if(sharedPreferences == null){
      sharedPreferences = await SharedPreferences.getInstance();
    }

    Map<String,dynamic> dataJson = Map<String,dynamic>();
    List<String> listDataString = [];

    for(ItemModel model in listItemSelected){
      dataJson['name'] = model.name;
      dataJson['cnt'] = model.cnt;
      dataJson['price'] = model.price;
      int val = model.color.value;
      dataJson['color'] = val;

      String dataString = jsonEncode(dataJson);
      listDataString.add(dataString);
    }
    await sharedPreferences!.setStringList('item', listDataString);
  }

  void getDataFromLocal() async{
    if(sharedPreferences == null){
      sharedPreferences = await SharedPreferences.getInstance();
    }

    List<String>? listDataString = sharedPreferences!.getStringList('item');

    if(listDataString != null && listDataString.isNotEmpty){
      for(String data in listDataString){
        Map<String,dynamic> dataJson = Map<String,dynamic>();
        dataJson = jsonDecode(data);
        int val = dataJson['color'];
        Color color = Color(val);
        listItemSelected.add(ItemModel(dataJson['name'], color, dataJson['price'], dataJson['cnt']));
      }
    }
    emit(ItemGetSuccessState());
  }
}

class ItemState {}

class InitState extends ItemState {}

class ItemGetSuccessState extends ItemState {}

class ItemGettingState extends ItemState {}

class ItemModel{
  String name;
  Color color;
  int price;
  int cnt;

  ItemModel(this.name, this.color, this.price, this.cnt);

  @override
  bool operator ==(Object other){
    return (other is ItemModel) && other.color == color;
  }
}