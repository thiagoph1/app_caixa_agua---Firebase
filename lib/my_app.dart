import 'package:app_caixa_agua/pages/tela_inicial.dart';
import 'package:flutter/material.dart';

/* My APP
  Função sem tela, contém o titulo, e o Tema da aplicação

 */

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Caixa de Água',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: const TelaInicial()
    );
  }
}