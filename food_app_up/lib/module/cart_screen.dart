import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'food_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.yellow,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          children: [
            BlocBuilder<ListItemCubit, ItemState>(builder: (_, state) {
              return Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                          itemCount: context
                              .read<ListItemCubit>()
                              .listItemSelected
                              .length,
                          itemBuilder: (context, index) {
                            return CartItemWidget(context
                                .read<ListItemCubit>()
                                .listItemSelected[index]);
                          }),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "\$${context.read<ListItemCubit>().Sum()}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 70,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              'BUY',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget CartItemWidget(ItemModel model) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: Colors.grey,
        ),
        SizedBox(
          width: 30,
        ),
        Expanded(
          child: Text(
            '${model.name}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          color: Colors.black.withOpacity(0.5),
          onPressed: () {
            context.read<ListItemCubit>().increment(model);
          },
        ),
        Text(
          '${model.cnt}',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove_circle_outline),
          color: Colors.black.withOpacity(0.5),
          onPressed: () {
            context.read<ListItemCubit>().decrement(model);
          },
        )
      ],
    );
  }
}
