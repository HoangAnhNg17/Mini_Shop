import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app_up/module/food_cubit.dart';

import 'module/home_page.dart';

class FoodApp extends StatefulWidget {
  const FoodApp({Key? key}) : super(key: key);

  @override
  State<FoodApp> createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListItemCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title:'BeaMin',
        home: HomePage(),
      ),
    );
  }
}
