import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Menu2.dart'; // Perfil
import 'Menu3.dart'; // Dietas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  int userId = prefs.getInt('userId') ?? 0; // Carrega o userId, se não encontrado, retorna 0
  runApp(MyApp(userId: userId));  // Passando o userId para o MyApp
}

class MyApp extends StatefulWidget {
  final int userId;

  MyApp({required this.userId});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              _selectedIndex == 0 ? 'Perfil' : 'Minhas Dietas',
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.blue,
          elevation: 4,
        ),
        body: _selectedIndex == 0
            ? ProfilePage(userId: widget.userId)
            : DietPage(userId: widget.userId),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Minhas Dietas',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
