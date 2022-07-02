class Dados {
  final String id;
  final String volume, distancia, data;

// variaveis nomeadas {}
  Dados(
      {required this.id,
      required this.volume,
      required this.distancia,
      required this.data});

// converte em objeto os dados vindo do JSON
  factory Dados.fromJson(Map<dynamic, dynamic> jsonDados) {
    return Dados(
        id: jsonDados['id'],
        volume: jsonDados['volume'],
        distancia: jsonDados['distancia'],
        data: jsonDados['data']);
  }
}