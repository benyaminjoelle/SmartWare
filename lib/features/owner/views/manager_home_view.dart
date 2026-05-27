import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:storex/widgets/box_loader.dart';

class ManagerLogin extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
     
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Warehouse Manager Login'),
            SizedBox(height: 20),
            BoxesLoader(),
          ],
        ),
      ),
    );
  }
}


  