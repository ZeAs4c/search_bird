import 'package:flutter/material.dart';
import 'package:search_bird/bloc/bird_post_cubit.dart';
import 'package:search_bird/bloc/location_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_bird/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit()..getLocation(),
        ),
        BlocProvider<BirdPostCubit>(
          create: (context) => BirdPostCubit()..loadPost(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          //цвет app bar
          primaryColor: Color(0xFF334257),
          colorScheme: ColorScheme.light().copyWith(
            primary: Color(0xFF548CAB),
            secondary: Color(0xFF96BAFF),
          ),
        ),
        home: MapScreen(),
      ),
    );
  }
}
