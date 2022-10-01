import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:anotacoes/helper/Database.dart';
import 'package:intl/intl.dart';
import 'package:anotacoes/ObjetoAnotacao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _ControleTitulo = TextEditingController();
  final TextEditingController _ControleTexto = TextEditingController();
  List<Map<String, Object?>>? _vListaRetorno;

  ///Converto minha String para um DateTime... com isso consigo aplicar o FORMAT que receber um DateTime e retorna um String formatada.
  String _RetornarDataFormatada(String pString) {
    DateTime vDataConvertida = DateTime.parse(pString);
    String vRetorno = DateFormat('y/MM/d').format(vDataConvertida);

    return vRetorno;
  }

  Future<int> retornaIDCadastrado() async {
    Database db = await Conexao.getConexao!.getBanco;

    print("id cadastro.....");

    Map<String, dynamic> vMapDados = {
      'TITULO': _ControleTitulo.text,
      'DESCRICAO': _ControleTexto.text,
      'DATA': DateTime.now().toString()
    };

    int vID = await db.insert('ANOTACOES', vMapDados);

    return vID;
  }

  Future<void> BuscarDados() async {
    _vListaRetorno = await Conexao.getConexao?.getDados();

    print("LISTA:" + _vListaRetorno.toString());

    setState(() {
      _vListaRetorno;
    });
  }

  Future<void> _Salvar() async {
    int vIDCadastrado = await retornaIDCadastrado();

    if (vIDCadastrado > 0) {
      ///_ControleTexto.clear();
      /// _ControleTitulo.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registro: $vIDCadastrado inserido com sucesso!'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Registro não inserido!'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  void _AbrirDialogCadastro({int? idAtualizacao}) {
    _ControleTexto.clear();
    _ControleTitulo.clear();
    String _vLabelAcaoBotao = '';

    if (idAtualizacao == null) {
      _vLabelAcaoBotao = 'Salvar';
    } else {
      _vLabelAcaoBotao = 'Atualizar';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Adicionar Anotação"),
            content: Column(
              ///A minha coluna vai ocupar o tamanho min necessário para incluir o Widgets dentro...
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Título',
                      labelStyle: TextStyle(color: Colors.teal),
                      hintText: 'Digite o título aqui...'),
                  autofocus: true,
                  controller: _ControleTitulo,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: TextStyle(color: Colors.teal),
                      hintText: 'Digite o texto aqui...'),
                  autofocus: true,
                  controller: _ControleTexto,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.teal)),
                  onPressed: () => Navigator.pop(context)),
              TextButton(
                  child: Text(
                    _vLabelAcaoBotao,
                    style: TextStyle(color: Colors.teal),
                  ),
                  onPressed: () {
                    if (idAtualizacao == null) {
                      _Salvar();
                    } else {
                      Map<String, dynamic> vMapDados = {
                        'TITULO': _ControleTitulo.text,
                        'DESCRICAO': _ControleTexto.text,
                        'DATA': DateTime.now().toString()
                      };

                      Conexao.getConexao!.Atualizar(idAtualizacao, vMapDados);
                    }

                    BuscarDados();
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BuscarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("App Anotações"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _vListaRetorno?.length,
                  itemBuilder: (context, i) {
                    return Card(
                        //color: Colors.black45,
                        child: ListTile(
                            title: Text(
                              'Título: ' +
                                  _vListaRetorno![i]["TITULO"].toString() +
                                  '\n' +
                                  'Data: ' +
                                  _RetornarDataFormatada(
                                      _vListaRetorno![i]["DATA"].toString()),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Descrição: ' +
                                  _vListaRetorno![i]["DESCRICAO"].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ///Atualizarrr
                                Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: GestureDetector(
                                        child: const Icon(Icons.edit,
                                            color: Colors.teal),
                                        onTap: () {
                                          Anotacao AnotacaoEdit = Anotacao(
                                              _vListaRetorno![i]["ID"]
                                                  .toString(),
                                              _vListaRetorno![i]["TITULO"]
                                                  .toString(),
                                              _vListaRetorno![i]["DESCRICAO"]
                                                  .toString(),
                                              _vListaRetorno![i]["DATA"]
                                                  .toString());

                                          _AbrirDialogCadastro(
                                              idAtualizacao: int.parse(
                                                  AnotacaoEdit.id.toString()));
                                        })),

                                ///Deletar
                                GestureDetector(
                                    child: const Icon(Icons.remove_circle,
                                        color: Colors.redAccent),
                                    onTap: () {
                                      Anotacao AnotacaoDelete = Anotacao(
                                          _vListaRetorno![i]["ID"].toString(),
                                          _vListaRetorno![i]["TITULO"]
                                              .toString(),
                                          _vListaRetorno![i]["DESCRICAO"]
                                              .toString(),
                                          _vListaRetorno![i]["DATA"]
                                              .toString());

                                      Conexao.getConexao!.Deletar(int.parse(
                                          AnotacaoDelete.id.toString()));
                                      BuscarDados();
                                    })
                              ],
                            )));
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: _AbrirDialogCadastro,
          child: const Icon(Icons.add)),
    );
  }
}
