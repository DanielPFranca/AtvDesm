import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // pacote que permite a manipulação de banco de dados
import 'package:path/path.dart'; // permite pegar o diretório de onde o bd é criado

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
  WidgetsFlutterBinding
      .ensureInitialized(); // Para garantir que o Flutter esteja inicializado antes de acessar o banco de dados
  await _insertInitialDog(); // Espera a inserção do cachorro inicial antes de construir o widget
}

// função para inserir dados no banco de dados
Future<void> _insertInitialDog() async {
  var database = await _initializeDatabase();
  var Rocky = Dog(id: 5, nome: "Rocky", idade: 2);
  var Caju = Dog(id: 6, nome: "Caju", idade: 6);
  await _insertDog(database, Caju);
  //await _insertDog(database, Rocky);
}

// função para inicializar o banco de dados
Future<Database> _initializeDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'dogs_a.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE dogsa(id INTEGER PRIMARY KEY, nome TEXT, idade INTEGER)',
      );
    },
    version: 1,
  );
}

Future<void> _insertDog(Database database, Dog dog) async {
  await database.insert('dogsa', dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Dog>> _dogs;
  @override
  void initState() {
    super.initState();
    _dogs = _fetchDogs();
  }

  Future<List<Dog>> _fetchDogs() async {
    var database = await _initializeDatabase();
    final List<Map<String, dynamic>> maps = await database.query('dogsa');

    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        idade: maps[i]['idade'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APP BD"),
      ),
      body: FutureBuilder<List<Dog>>(
        future: _dogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dogs = snapshot.data!;
            return ListView.builder(
              itemCount: dogs.length,
              itemBuilder: (context, index) {
                final dog = dogs[index];
                return ListTile(
                  title: Text(dog.nome),
                  subtitle: Text('Idade: ${dog.idade}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Dog {
  final int id;
  String nome;
  final int idade;
  Dog({required this.id, required this.nome, required this.idade});
  // função para transformar os dados em Map para salvar no banco de dados
  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'idade': idade};
  }
}
