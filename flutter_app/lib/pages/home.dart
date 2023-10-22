import 'package:flutter/material.dart';
import 'package:flutter_app/classes/imc.dart';
import 'package:flutter_app/model/config_model.dart';
import 'package:flutter_app/repositories/configuracoes_repository.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

final TextEditingController _textFieldController1 = TextEditingController();
final TextEditingController _textFieldController2 = TextEditingController();

class _HomeState extends State<Home> {
  final logger = Logger();
  late ConfiguracoesRepository configuracoesRepository;
  var configuracoesModel = ConfiguracoesModel.vazio();
  double imcResult = 0.0;
  List<double> imcHistory = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    configuracoesRepository = await ConfiguracoesRepository.carregar();
    configuracoesModel = configuracoesRepository.obterDados();
    _textFieldController1.text = configuracoesModel.peso.toString();
    _textFieldController2.text = configuracoesModel.altura.toString();
    carregarIMCHistory(); // Chame carregarIMCHistory após a inicialização
    setState(() {});
  }

  void carregarIMCHistory() {
    final historicoIMC = configuracoesRepository.obterDados().imc;
    logger.d(historicoIMC);
    setState(() {
      imcHistory = historicoIMC;
    });
  }

  void calculateIMC() {
    final weight = double.tryParse(_textFieldController1.text) ?? 0.0;
    final height = double.tryParse(_textFieldController2.text) ?? 0.0;

    if (weight > 0 && height > 0) {
      final imc = Imc(weight: weight, height: height).imc;
      setState(() {
        imcResult = imc;
        imcHistory.add(imc); // Adicione o IMC calculado à lista
        configuracoesModel.imc = imcHistory;
        configuracoesRepository.salvar(configuracoesModel); // Salve no Hive
        logger.d(imcResult);
      });
    } else {
      // Lógica de tratamento de entrada inválida
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32.0),
        color: Colors.black54,
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  const Padding(padding: EdgeInsets.all(32.0)),
                  Text(
                    "Calcule o seu IMC de acordo com sua Altura x Peso",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _textFieldController1,
                      decoration: const InputDecoration(
                        labelText: 'Insira o seu peso',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hoverColor: Colors.red,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _textFieldController2,
                      decoration: const InputDecoration(
                        labelText: 'Insira a sua altura',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hoverColor: Colors.red,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: calculateIMC,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.fromLTRB(36.0, 18.0, 36.0, 18.0),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: const Text('Calcular meu IMC'),
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.all(20),
                  child: const Text(
                    "Resultados salvos",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  )),
              Expanded(
                  child: ListView.builder(
                itemCount: imcHistory.length,
                itemBuilder: (context, index) {
                  final imc = imcHistory[index];
                  Color backgroundColor = Colors.white;
                  if (imc < 18.5) {
                    backgroundColor = Colors.yellow;
                  } else if (imc < 24.9) {
                    backgroundColor = Colors.green;
                  } else {
                    backgroundColor = Colors.red;
                  }

                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: backgroundColor, // Cor de fundo
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        'IMC ${index + 1}: $imc',
                        style: const TextStyle(fontWeight: FontWeight.bold,),
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
