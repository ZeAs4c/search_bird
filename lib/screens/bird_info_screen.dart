import 'package:flutter/material.dart';
import 'package:search_bird/bloc/bird_post_cubit.dart';
import 'package:search_bird/models/bird_post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BirdPostInfoScreen extends StatelessWidget {
  final BirdModel birdModel;

  BirdPostInfoScreen({required this.birdModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(birdModel.birdName!),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context)
                  .size
                  .width, //Динамическое значение ширина экрана
              height: MediaQuery.of(context).size.width / 1.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(birdModel.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text(birdModel.birdName!,style: Theme.of(context).textTheme.headlineLarge,),
            SizedBox(height: 5,),
            Text(birdModel.birdDescription!,style: Theme.of(context).textTheme.headlineLarge,),
            SizedBox(height: 5,),
            TextButton(onPressed: (){
              context.read<BirdPostCubit>().removeBirdPost(birdModel);
              Navigator.of(context).pop();
            }, child: Text("Delete")),
          ],
        ),
      ),
    );
  }
}
