class Anotacao{

  String ?_id;
  String ?_titulo;
  String ?_descricao;
  String ?_data;


  Anotacao(this._id, this._titulo, this._descricao, this._data);

  String get id => _id!;

  set id(String value) {
    _id = value;
  }

  String get titulo => _titulo!;

  String get data => _data!;

  set data(String value) {
    _data = value;
  }

  String get descricao => _descricao!;

  set descricao(String value) {
    _descricao = value;
  }

  set titulo(String value) {
    _titulo = value;
  }
}