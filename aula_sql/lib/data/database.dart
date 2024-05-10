import 'package:aula_sql/data/databaseDAO.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  //getDatabasePath irá pegar o diretório do banco de dados
  final String path = join(await getDatabasesPath(), 'users.db');

  return openDatabase(path, onCreate: (db, version) {
    db.execute(UsersDAO.tabela);
  }, version: 1);
}
