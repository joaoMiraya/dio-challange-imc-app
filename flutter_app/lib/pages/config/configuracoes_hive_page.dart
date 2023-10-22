import 'package:flutter/material.dart';
import 'package:flutter_app/model/config_model.dart';
import 'package:flutter_app/repositories/configuracoes_repository.dart';

class ConfiguracoesHivePage extends StatefulWidget {
  const ConfiguracoesHivePage({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesHivePage> createState() => _ConfiguracoesHivePageState();
}

class _ConfiguracoesHivePageState extends State<ConfiguracoesHivePage> {
  late ConfiguracoesRepository configuracoesRepository;
  var configuracoesModel = ConfiguracoesModel.vazio();

  TextEditingController nomeUsuarioController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    configuracoesRepository = await ConfiguracoesRepository.carregar();
    configuracoesModel = configuracoesRepository.obterDados();
    nomeUsuarioController.text = configuracoesModel.nomeUsuario;
    pesoController.text = configuracoesModel.peso.toString();
    alturaController.text = configuracoesModel.altura.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color corTexto =
        configuracoesModel.temaEscuro ? Colors.white : Colors.black;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Configurações Hive"),
              backgroundColor: Colors.black87,
            ),
            body: Container(
              color:
                  configuracoesModel.temaEscuro ? Colors.black87 : Colors.white,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration:
                          const InputDecoration(hintText: "Nome usuário", ),
                      controller: nomeUsuarioController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Altura"),
                      controller: alturaController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Peso"),
                      controller: pesoController,
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      "Receber notificações",
                      style: TextStyle(
                        color: corTexto,
                      ),
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        configuracoesModel.receberNotificacoes = value;
                      });
                    },
                    value: configuracoesModel.receberNotificacoes,
                  ),
                  SwitchListTile(
                      title: Text(
                        "Tema escuro",
                        style: TextStyle(
                          color: corTexto,
                        ),
                      ),
                      value: configuracoesModel.temaEscuro,
                      onChanged: (bool value) {
                        setState(() {
                          configuracoesModel.temaEscuro = value;
                        });
                      }),
                  TextButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        try {
                          configuracoesModel.altura =
                              double.parse(alturaController.text);
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Meu App"),
                                  content: const Text(
                                      "Favor informar uma altura válida!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Ok"))
                                  ],
                                );
                              });
                          return;
                        }
                        try {
                          configuracoesModel.peso =
                              double.parse(pesoController.text);
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Meu App"),
                                  content: const Text(
                                      "Favor informar um peso válida!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Ok"))
                                  ],
                                );
                              });
                          return;
                        }
                        configuracoesModel.nomeUsuario =
                            nomeUsuarioController.text;
                        configuracoesRepository.salvar(configuracoesModel);
                        Navigator.pop(context);
                      },
                      child: const Text("Salvar",))
                ],
              ),
            )));
  }
}
