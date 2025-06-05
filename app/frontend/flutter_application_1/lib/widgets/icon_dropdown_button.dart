import 'package:flutter/material.dart';

class IconDropdownButton extends StatefulWidget {
  final ValueChanged<String> onSelected;

  const IconDropdownButton({required this.onSelected, super.key});

  @override
  IconDropdownButtonState createState() => IconDropdownButtonState();
}

class IconDropdownButtonState extends State<IconDropdownButton> {
  static const String yourEnv = 'Tu entorno';
  static const String following = 'Siguiendo';
  static const String explore = 'Explorar';
  static const String seeTopics = 'Ver temas';

  String _selectedOption = yourEnv;

  final Map<String, IconData> options = {
    yourEnv: Icons.place,
    following: Icons.people,
    explore: Icons.public,
    seeTopics: Icons.filter_alt,
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        options[_selectedOption],
        size: 30,
        color: Colors.white,
      ),
      onSelected: (String value) {
        setState(() {
          _selectedOption = value;
        });

        // Notifica al padre
        widget.onSelected(value);
      },
      itemBuilder: (BuildContext context) {
        return options.keys.map((String option) {
          return PopupMenuItem<String>(
            value: option,
            child: Text(option, style: TextStyle(fontSize: 20),),
          );
        }).toList();
      },
      position: PopupMenuPosition.under,
    );
  }
}
