import 'package:app_caixa_agua/pages/tela_historico.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/* Tela Inical
  Onde aparece o último registro de volume

 */

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);
  @override
  State<TelaInicial> createState() => _TelaInicialState();
}
class _TelaInicialState extends State<TelaInicial> {
/*------------------------------------------------------------------------*/
  // Variaveis
  final db = FirebaseDatabase.instance.ref(); // referência do Banco de dados
  dynamic _ultimoVolume;
  dynamic _ultimaData;
/*------------------------------------------------------------------------*/
  // Estado inicial com o listener para pegar e escutar o último registro
  @override
  void initState() {
    _activeListeners();
    super.initState();
  }
/*------------------------------------------------------------------------*/
  // Método para escutar o banco
  void _activeListeners() async {
    db.child('dados').limitToLast(1).onChildAdded.listen((event) { // pegando o útilmo registro do Firebase

      var date = "";
      var volume = event.snapshot.children.last.value; // último valor do registro é o volume
      var data = event.snapshot.children.first.value;  // primeiro valor do registro é a data
      data == null // verificação para não converter número nulo
          ? 0
          : date = DateFormat('dd/MM/yyyy, hh:mm:ss a')
              .format(DateTime.fromMillisecondsSinceEpoch(data as int));// a data esta em milisegundos
      if (_ultimoVolume != volume && _ultimaData != data) {
        // Verifica se o _ultimoVolume e a _ultimaData mudaram
        setState(() { // se sim, muda a aplicação com o setState
          _ultimoVolume = volume;
          _ultimaData = date;
        });
      }
    });
  }
/*------------------------------------------------------------------------*/
  // App Bar - Barra Superior
  _appBar() {
    return AppBar(
      title: const Text('CAIXA D\'ÁGUA Firebase'),
      centerTitle: true,
    
    );
  }
/*------------------------------------------------------------------------*/
  // Widget com os dados
  _resumo() {
    return SizedBox(
      child: StreamBuilder(
        stream: db.ref.onValue,
        builder: (context, snapshot) {
          dynamic dados = snapshot.data;
          if (snapshot.hasData && dados.snapshot.value != null) {
            // Se tiver dados e os valores não forem nulos retorna o _conteudoCentral
            return _conteudoCentral();
          } else if (snapshot.hasError) {
            // Se tiver erro retorna a mensagem de erro
            return Text('${snapshot.error}');
          } else {
            return const SizedBox(
              // caso não tem dados e não tenha erro fica com a barra circular na tela
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
/*------------------------------------------------------------------------*/
// Widget do conteudo central
  _conteudoCentral() {
    return Stack(children: [
      _backGround(),
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(150),
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('images/caixa_semback.png'),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsetsDirectional.only(top: 40, bottom: 40),
            child: Text(
              'Volume ${_ultimoVolume.toString()} %',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Última atualização: ${_ultimaData.toString()}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ],
      )
    ]);
  }
/*------------------------------------------------------------------------*/
// Imagem de Fundo
  _backGround() {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 136, 196, 224),
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.dstATop,
              ),
              image:
                  const AssetImage('images/water-wallpaper-pixbay-free.jpg'))),
    );
  }
/*------------------------------------------------------------------------*/
  // Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _resumo(),
          ElevatedButton(
                child: const Text('HISTÓRICO'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => TelaHistorico()),
                    ),
                  );
                }),
        ],
      ),
      
    );
  }
/*------------------------------------------------------------------------*/
// Fecha o listener
  @override
  void dispose() {
    _activeListeners();
    super.dispose();
  }
}