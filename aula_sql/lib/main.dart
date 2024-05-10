import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nome = TextEditingController();
  TextEditingController idade = TextEditingController();
  TextEditingController hobbie = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App banco de dados'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: nome,
                decoration: InputDecoration(hintText: 'Digite seu nome'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: idade,
                decoration: InputDecoration(hintText: 'Digite sua idade'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: hobbie,
                decoration: InputDecoration(hintText: 'Digite seu hobbie'),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print("${nome.text} | ${idade.text} | ${hobbie.text}");
                },
                child: Text('Exibir'))
          ],
        ),
      ),
    );
  }
}
