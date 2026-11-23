import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/perfil.dart';
import '../models/preferencia_sensorial.dart';
import '../services/perfil_service.dart';
import '../routes/app_routes.dart';

class PerfilController extends GetxController {
  final PerfilService _perfilService = PerfilService();

  final RxList<Perfil> perfis = <Perfil>[].obs;
  final Rx<Perfil?> perfilSelecionado = Rx<Perfil?>(null);
  final RxBool isLoading = false.obs;
  final RxString mensagemErro = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllPerfis();
  }

  Future<void> loadAllPerfis() async {
    try {
      isLoading.value = true;
      mensagemErro.value = '';
      final lista = await _perfilService.getPerfis(1);
      perfis.assignAll(lista);
      
      if (perfilSelecionado.value != null) {
        final atualizado = perfis.firstWhereOrNull((p) => p.id == perfilSelecionado.value!.id);
        if (atualizado != null) {
          perfilSelecionado.value = atualizado;
        }
      }
    } catch (e) {
      mensagemErro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> criarPerfil({
    required String nome,
    required int idade,
    required int idAvatar,
    required String preferenciaCor,
    required bool temEfeitosSom,
    required double velocidadeAnimacao,
    required List<String> focosAprendizado,
  }) async {
    try {
      isLoading.value = true;
      
      final perfil = Perfil(
        idResponsavel: 1, 
        idAvatar: idAvatar,
        nome: nome,
        idade: idade,
      );

      final preferencia = PreferenciaSensorial(
        idPerfil: 0,
        corPreferida: preferenciaCor,
        somAtivado: temEfeitosSom,
        velocidadeAnimacao: velocidadeAnimacao.toString(),
      );

      await _perfilService.createPerfilCompleto(
        perfil: perfil,
        preferencia: preferencia,
        focos: focosAprendizado,
      );
      
      await loadAllPerfis();
      Get.back();
      Get.snackbar('Sucesso', 'Perfil de $nome criado!', 
        backgroundColor: Colors.green.withOpacity(0.7), colorText: Colors.white);
    } catch (e) {
      mensagemErro.value = e.toString();
      Get.snackbar('Erro ao Salvar', e.toString(), 
        backgroundColor: Colors.red.withOpacity(0.7), colorText: Colors.white, duration: const Duration(seconds: 5));
      print("ERRO SQL: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> atualizarPerfil({
    required int id,
    required String nome,
    required int idade,
    required int idAvatar,
    required String preferenciaCor,
    required bool temEfeitosSom,
    required double velocidadeAnimacao,
    required List<String> focosAprendizado,
  }) async {
    try {
      isLoading.value = true;
      
      final perfil = Perfil(
        id: id,
        idResponsavel: 1,
        idAvatar: idAvatar,
        nome: nome,
        idade: idade,
      );

      final preferencia = PreferenciaSensorial(
        idPerfil: id,
        corPreferida: preferenciaCor,
        somAtivado: temEfeitosSom,
        velocidadeAnimacao: velocidadeAnimacao.toString(),
      );

      await _perfilService.updatePerfilCompleto(
        perfil: perfil,
        preferencia: preferencia,
        focos: focosAprendizado,
      );

      await loadAllPerfis();
      Get.back();
      Get.snackbar('Sucesso', 'Perfil atualizado!', 
        backgroundColor: Colors.green.withOpacity(0.7), colorText: Colors.white);
    } catch (e) {
      mensagemErro.value = e.toString();
      Get.snackbar('Erro ao Atualizar', e.toString(), 
        backgroundColor: Colors.red.withOpacity(0.7), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletarPerfil(int id, String nome) async {
    try {
      isLoading.value = true;
      final sucesso = await _perfilService.deletePerfil(id);
      if (sucesso) {
        perfis.removeWhere((p) => p.id == id);
        if (perfilSelecionado.value?.id == id) {
          perfilSelecionado.value = null;
        }
      }
    } catch (e) {
      mensagemErro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void prepararNovoPerfil() {
    perfilSelecionado.value = null;
    Get.toNamed(AppRoutes.criarPerfil);
  }

  void selecionarPerfil(Perfil perfil) {
    perfilSelecionado.value = perfil;
  }

  void clearMessages() => mensagemErro.value = '';
}
