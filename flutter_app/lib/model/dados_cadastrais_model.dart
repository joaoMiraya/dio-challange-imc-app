import 'package:hive/hive.dart';

part 'dados_cadastrais_model.g.dart';

@HiveType(typeId: 0)
class DadosCadastraisModel extends HiveObject {
  @HiveField(0)
  String? nome;
  String? peso;
  String? altura;

  @HiveField(1)
  DateTime? dataNascimento;

  DadosCadastraisModel();

  DadosCadastraisModel.vazio() {
    nome = "";
    peso = "";
    altura = "";
    dataNascimento = null;
   }
}
