import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexao {
  ///Atributos
  static Conexao? _instancia;
  Database? _Base;

  ///Contrutor privado
  Conexao._Internar();

  ///método público que cria a única intância de Conexão. ----(Operador ??=  - Atribui valor ao objeto se o objeto for NULL)
  static Conexao? get getConexao {
    _instancia ??= Conexao._Internar();

    return _instancia;
  }

  ///Método que irá criar o meu DB e retorna-lo. também uma única instância, pois a classe Conexão só permite uma criação...
  Future<Database> get getBanco async {
    String vCaminho = await getDatabasesPath();
    String vCaminhoBanco = join(vCaminho, 'anotacoes.db');

    ///Cria o banco se meu banco for null, caso contrário retorna a intância já criada (Operador ??=  - Atribui valor ao objeto se o objeto for NULL)
    _Base ??= _Base = await openDatabase(vCaminhoBanco,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade);

    return _Base!;
  }

  ///Esse método  é chamado na primeira execução do APP, criação da estrutura do banco...
  FutureOr<void> _onCreate(Database db, int version) {
    db.execute('CREATE TABLE ANOTACOES ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'TITULO VARCHAR(100), '
        'DESCRICAO TEXT, '
        'DATA DATETIME)');
  }

  ///Quando incremento uma versão.
  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}

  ///Quando  volto uma versão.
  FutureOr<void> _onDowngrade(Database db, int oldVersion, int newVersion) {}

  ///Get Dados
  Future<List<Map<String, Object?>>> getDados() async {
    Database vDB = await getBanco;

    List<Map<String, Object?>> vAnotacoes =
        await vDB!.rawQuery('SELECT * FROM ANOTACOES ORDER BY DATA DESC');

    return vAnotacoes;
  }

  ///Atualizar
  void Atualizar(int pID, Map<String, dynamic> pMapDados) async {
    Database vDB = await getBanco;

    vDB.update('ANOTACOES', pMapDados, where: 'ID = ${pID}');
  }

  ///Deletar
  void Deletar(int pID) async {
    Database vDB = await getBanco;

    vDB.delete('ANOTACOES', where: 'ID = ?', whereArgs: [pID]);
  }
}
