import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // pacote que permite a manipulação de banco de dados
import 'package:path/path.dart'; // permite pegar o diretório de onde o bd é criado

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await _insertInitialProd();
  // var Agua = Prod(id: 5, nome: "Agua", quant: 10);
  // await updateProd(Agua);
}

// função para inserir dados no banco de dados
Future<void> _insertInitialProd() async {
  var database = await _initializeDatabase();
  var Agua = Prod(id: 5, nome: "Agua", quant: 14);
  var Melancia = Prod(id: 6, nome: "Melancia", quant: 12);
  await _insertProd(database, Agua);
  //await deleteProd(6);
}

// função para inicializar o banco de dados
Future<Database> _initializeDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'Prod_a.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE Prod(id INTEGER PRIMARY KEY, nome TEXT, quant INTEGER)',
      );
    },
    version: 1,
  );
}

Future<void> _insertProd(Database database, Prod prod) async {
  await database.insert('Prod', prod.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> deleteProd(int id) async {
  final db = await _initializeDatabase();
  await db.delete('Prod', where: 'id = ?', whereArgs: [id]);
  print('Deletando dado');
}

Future<void> updateProd(Prod prod) async {
  final db = await _initializeDatabase();
  await db.update('Prod', prod.toMap(), where: 'id = ?', whereArgs: [prod.id]);
  print('Atualizando dado');
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Prod>> _Prod;
  @override
  void initState() {
    super.initState();
    _Prod = _fetchProd();
  }

  Future<List<Prod>> _fetchProd() async {
    var database = await _initializeDatabase();
    final List<Map<String, dynamic>> maps = await database.query('Prod');

    return List.generate(maps.length, (i) {
      return Prod(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        quant: maps[i]['quant'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APP BD"),
      ),
      body: FutureBuilder<List<Prod>>(
        future: _Prod,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final prod = snapshot.data!;
            return ListView.builder(
              itemCount: prod.length,
              itemBuilder: (context, index) {
                final Prod = prod[index];
                return ListTile(
                  title: Text(Prod.nome),
                  subtitle: Text('Quant: ${Prod.quant}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Prod {
  final int id;
  String nome;
  final int quant;
  Prod({required this.id, required this.nome, required this.quant});
  // função para transformar os dados em Map para salvar no banco de dados
  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'quant': quant};
  }
}
