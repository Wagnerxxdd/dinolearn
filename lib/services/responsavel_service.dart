import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import '../models/responsavel.dart';
import '../data/repositories/responsavel_repository.dart';

class ResponsavelService {
  final ResponsavelRepository _repository = ResponsavelRepository();

  String _hashSenha(String senha) {
    final bytes = utf8.encode(senha);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Responsavel> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    if (nome.isEmpty) throw 'O nome é obrigatório';
    if (!GetUtils.isEmail(email)) throw 'E-mail inválido';
    if (senha.length < 8) throw 'A senha deve ter no mínimo 8 caracteres';

    final existente = await _repository.getByEmail(email);
    if (existente != null) throw 'Este e-mail já está cadastrado';

    final responsavel = Responsavel(
      nome: nome,
      email: email,
      senhaHash: _hashSenha(senha),
    );

    final id = await _repository.create(responsavel);
    return responsavel.copyWith(id: id);
  }

  Future<Responsavel?> login(String email, String senha) async {
    if (email.isEmpty) throw 'Informe o e-mail';
    if (senha.isEmpty) throw 'Informe a senha';
    
    final responsavel = await _repository.getByEmail(email);
    if (responsavel == null) throw 'Usuário não encontrado';

    if (responsavel.senhaHash != _hashSenha(senha)) {
      throw 'Senha incorreta';
    }

    return responsavel;
  }
}
