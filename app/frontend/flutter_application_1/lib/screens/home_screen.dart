import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:flutter_application_1/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('What\'s New'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.newsScreen);
                  },
                  child: Icon(Icons.newspaper),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.profileScreen);
                  },
                  child: Icon(Icons.person),
                ),
              ),
            ],  
          ),
          SingleChildScrollView(
            child: Column(
              children: List.generate(
                30,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PostContainer(
                    title: 'Título de la publicación $index',
                    text: 'Texto de la publicación $index',
                  ),
                ),
              ),
            ),
          ),
          // Botón Perfil
          /*AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: isOpen ? 100 : 40,
            right: isOpen ? 40 : 30,
            child: Visibility(
              visible: isOpen,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  if (Navigator.canPop(context) || AppRoutes.profileScreen != null) {
                    Navigator.pushNamed(context, AppRoutes.profileScreen);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ruta no encontrada: profileScreen')),
                    );
                  }
                },
                child: Icon(Icons.person),
              ),
            ),
          ),
          // Botón 2
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: isOpen ? 160 : 40,
            right: isOpen ? 100 : 30,
            child: Visibility(
              visible: isOpen,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  print('Botón 2');
                },
                child: Icon(Icons.photo),
              ),
            ),
          ),*/
        ],
      ),
      // Botón flotante de menú
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Icon(isOpen ? Icons.close : Icons.add),
          ),
        ),
      ),
    );
  }
}
