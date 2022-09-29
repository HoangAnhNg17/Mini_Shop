import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app_up/module/food_cubit.dart';

import 'cart_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ListItemCubit>().getDataFromLocal();
    context.read<ListItemCubit>().convertStringToListItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh mục'),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                  },
                ),
                Positioned(
                  top: 4,
                  right: 0,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: BlocBuilder<ListItemCubit,ItemState>(
                        builder: (_,state){
                          return Text('${context.read<ListItemCubit>().listItemSelected.length}');
                        }
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: BlocBuilder<ListItemCubit,ItemState>(
        builder: (_,ItemState state){
          if(state is ItemGettingState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is ItemGetSuccessState && context.read<ListItemCubit>().listItem.isNotEmpty){
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListView.builder(
                itemCount: context.read<ListItemCubit>().listItem.length,
                itemBuilder: (context, index) {
                  return ItemWidget(context.read<ListItemCubit>().listItem[index]);
                },
              ),
            );
          }
          return SizedBox();
        }
      )
    );
  }
  Widget ItemWidget(ItemModel itemModel){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: itemModel.color,
            height: 55,
            width: 55,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              '${itemModel.name}',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          !context.read<ListItemCubit>().listItemSelected.contains(itemModel)
              ? TextButton(
            child: Text('Thêm'),
            onPressed: () {
              context.read<ListItemCubit>().addItemToCart(itemModel);
            },
          )
              : Icon(
            Icons.check,
            color: Colors.grey,
          ),
          SizedBox(width: 17,),
        ],
      ),
    );
  }
}
