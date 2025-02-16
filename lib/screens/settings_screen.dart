import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Ajustes'),
          actions: [Text('My Profile')],
        ),
        body: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: size.width * 0.05, horizontal: size.height * 0.01),
            child: Row(
              children: [
                // To do
                CustomCircleAvatar(
                  image: 'https://media.istockphoto.com/id/1090878494/es/foto/retrato-de-joven-sonriente-a-hombre-guapo-en-camiseta-polo-azul-aislado-sobre-fondo-gris-de.jpg?s=612x612&w=0&k=20&c=dHFsDEJSZ1kuSO4wTDAEaGOJEF-HuToZ6Gt-E2odc6U=',
                  radius: size.width * 0.20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.height * 0.05),
                  child: Column(
                    children: [
                      Text('Username Name')
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            child: CustomDropdownButton(
              list: []
            )
          )
        ]));
  }
}
