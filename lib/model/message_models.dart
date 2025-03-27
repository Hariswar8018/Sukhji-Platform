class Messages {
  Messages({
    required this.read,
    required this.told,
    required this.from,
    required this.mes,
    required this.type,
    required this.sent,
  });
  late final String read;
  late final String told;
  late final String from;
  late final String mes;
  late final Type type;
  late final String sent;

  Messages.fromJson(Map<String, dynamic> json){
    read = json['read'];
    told = json['told'];
    from = json['from'];
    mes = json['mes'];
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'];
  }

  Map<String, dynamic> toJson(Messages messages) {
    final _data = <String, dynamic>{};
    _data['read'] = read;
    _data['told'] = told;
    _data['from'] = from;
    _data['mes'] = mes;
    _data['type'] = type.name;
    _data['sent'] = sent;
    return _data;
  }
}

enum Type {text, image}
