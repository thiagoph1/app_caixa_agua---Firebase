// ignore_for_file: use_key_in_widget_constructors
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dados.dart';

/* TELA DE HISTORICO 
  Onde é mostrado os últimos 100 registros, podendo ser modificado as quantidades
  há um pequeno contra tempo, onde o histórico começa no fim

*/

class TelaHistorico extends StatefulWidget {
  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
/*------------------------------------------------------------------------*/
  // Variaveis
  final db = FirebaseDatabase.instance.ref(); // referência do banco
  List<Dados> dados = []; // lista para salvar os registro do banco
/*------------------------------------------------------------------------*/
  // Estado inicial com o listener para pegar e escutar o último registro
  @override
  void initState() {
    super.initState();
    _getHistorico();
  }

/*------------------------------------------------------------------------*/
  // Método para escutar o banco
  _getHistorico() async {
    db
        .child('dados')
        .limitToLast(100)
        .orderByChild('dados/data')
        .onChildAdded
        .listen((event) {
      dynamic data = event.snapshot;

      var date = "";
      String idFire = event.snapshot.key.toString();
      var volumeFire = data.value["volume"];
      var distanciaFire = data.value["distancia"];
      var dataFire = data.value["data"];
      dataFire == null
          ? 0
          : date = DateFormat('dd/MM/yyyy, hh:mm:ss a')
              .format(DateTime.fromMillisecondsSinceEpoch(dataFire));
      setState(
        () {
          dados.add(Dados(
              id: idFire,
              volume: volumeFire.toString(),
              distancia: distanciaFire.toString(),
              data: date.toString()));
        },
      );
    });
  }
/*------------------------------------------------------------------------*/
  // Build
  @override
  Widget build(context) {
    return Scaffold(
      appBar: _appBar(),
      body: SizedBox(
        child: StreamBuilder(
          stream: db.onChildAdded,
          builder: (context, snap) {
            if (snap.hasData && snap.data != null) {
              return ListView.builder(
                addAutomaticKeepAlives: false,
                reverse: true,
                itemCount: dados.length,
                itemBuilder: (context, int index) {
                  return itemLista(dados[index], context);
                },
              );
            } else if (snap.hasError) {
              return Text('${snap.error}');
            } else {
              return const SizedBox(
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
/*------------------------------------------------------------------------*/
  // App Bar - Barra Superior
  _appBar() {
    return AppBar(
      title: const Text('CAIXA D\'ÁGUA Firebase'),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.update_rounded))
      ],
    );
  }
/*------------------------------------------------------------------------*/
// Função para criar lista
  Widget criadorDaLista(context) {
    return ListView.builder(
      itemCount: dados.length,
      itemBuilder: (context, int index) {
        return itemLista(dados[index], context);
      },
    );
  }
/*------------------------------------------------------------------------*/
// Função para criar itens da lista
  Widget itemLista(Dados dados, BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text(
              "Volume: " +
                  dados.volume +
                  " % | Distancia:" +
                  dados.distancia +
                  " cm (opcional)",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Data: " + dados.data,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }
/*------------------------------------------------------------------------*/
// Fecha o listener
  @override
  void deactivate() {
    _getHistorico();
    super.deactivate();
  }
}