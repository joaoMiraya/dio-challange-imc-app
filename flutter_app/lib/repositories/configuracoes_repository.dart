import 'package:flutter_app/model/config_model.dart';
import 'package:hive/hive.dart';

class ConfiguracoesRepository {
  static late Box _box;

  ConfiguracoesRepository._criar();

  static Future<ConfiguracoesRepository> carregar() async {
    if (Hive.isBoxOpen('configuracoes')) {
      _box = Hive.box('configuracoes');
    } else {
      _box = await Hive.openBox('configuracoes');
    }
    return ConfiguracoesRepository._criar();
  }

  void salvar(ConfiguracoesModel configuracoesModel) {
    _box.put('configuracoesModel', {
      'nomeUsuario': configuracoesModel.nomeUsuario,
      'peso': configuracoesModel.peso,
      'altura': configuracoesModel.altura,
      'imc': configuracoesModel.imc,
      'receberNotificacoes': configuracoesModel.receberNotificacoes,
      'temaEscuro': configuracoesModel.temaEscuro
    });
  }

  ConfiguracoesModel obterDados() {
    if (_box.containsKey('configuracoesModel')) {
      var configuracoes = _box.get('configuracoesModel');
      if (configuracoes is Map) {
        // Certifique-se de que 'imc' seja uma lista válida
        if (configuracoes["imc"] is List) {
          return ConfiguracoesModel(
            configuracoes["nomeUsuario"],
            configuracoes["peso"],
            configuracoes["altura"],
            List<double>.from(configuracoes["imc"]),
            configuracoes["receberNotificacoes"],
            configuracoes["temaEscuro"],
          );
        }
      }
    }
    return ConfiguracoesModel.vazio();
  }
}
