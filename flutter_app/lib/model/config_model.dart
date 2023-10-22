class ConfiguracoesModel {
  String nomeUsuario = "";
  double peso = 0;
  double altura = 0;
  List<double> imc = [];
  bool receberNotificacoes = false;
  bool temaEscuro = false;

  ConfiguracoesModel.vazio() {
    nomeUsuario = "";
    peso = 0;
    altura = 0;
    imc = [];
    receberNotificacoes = false;
    temaEscuro = false;
  }

  ConfiguracoesModel(this.nomeUsuario, this.peso, this.altura, this.imc,
      this.receberNotificacoes, this.temaEscuro);
}
