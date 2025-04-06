import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('What\'s New'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            30,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Elemento $index', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),

      // Botón flotante de menú
      floatingActionButton: FloatingActionButton(
        onPressed: _showOptions(),
        child: Icon(Icons.add),
      ),
    );
  }
  
  _showOptions() {
    // Mostrar opciones de menú
  }
}