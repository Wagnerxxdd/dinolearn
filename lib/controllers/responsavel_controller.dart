import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/responsavel.dart';
import '../services/responsavel_service.dart';
import '../routes/app_routes.dart';

class ResponsavelController extends GetxController {
  final ResponsavelService _service = ResponsavelService();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final Rx<Responsavel?> usuarioLogado = Rx<Responsavel?>(null);

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  Future<void> login(String email, String senha) async {
    try {
      isLoading.value = true;
      final user = await _service.login(email, senha);
      usuarioLogado.value = user;
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar(
        'Erro no Login', 
        e.toString(), 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
  }) async {
    if (senha != confirmarSenha) {
      Get.snackbar('Erro', 'As senhas não coincidem');
      return;
    }

    try {
      isLoading.value = true;
      final user = await _service.cadastrar(nome: nome, email: email, senha: senha);
      usuarioLogado.value = user;
      Get.snackbar('Sucesso', 'Conta criada com sucesso!');
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Erro no Cadastro', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
