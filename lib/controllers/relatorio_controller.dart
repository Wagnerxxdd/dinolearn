import 'package:get/get.dart';
import '../services/relatorio_service.dart';
import '../models/resumo_progresso.dart';
import '../models/relatorio_consolidado.dart';
import 'perfil_controller.dart';
import 'atividade_controller.dart';

class RelatorioController extends GetxController {
  final RelatorioService _service = RelatorioService();

  final RxList<RelatorioAtividadeModel> detalhes = <RelatorioAtividadeModel>[].obs;
  final RxBool isLoading = false.obs;

  final Rx<ResumoProgresso?> resumoAtivo = Rx<ResumoProgresso?>(null);
  final Rx<RelatorioConsolidado?> relatorioConsolidado = Rx<RelatorioConsolidado?>(null);
  final RxString dificuldadeRecorrente = "Nenhuma identificada".obs;

  late final Worker _perfilWorker;
  late final Worker _progressoWorker;
  int _ultimaRequisicao = 0;

  @override
  void onInit() {
    super.onInit();
    final perfilController = Get.find<PerfilController>();
    final atividadeController = Get.find<AtividadeController>();

    _perfilWorker = ever(
      perfilController.perfilSelecionado,
          (_) => carregarDados(),
    );
    _progressoWorker = ever<int>(
      atividadeController.versaoProgresso,
          (_) => carregarDados(),
    );
    carregarDados();
  }

  @override
  void onClose() {
    _perfilWorker.dispose();
    _progressoWorker.dispose();
    super.onClose();
  }

  Future<void> carregarDados() async {
    final requisicao = ++_ultimaRequisicao;
    final perfil = Get.find<PerfilController>().perfilSelecionado.value;
    if (perfil == null || perfil.id == null) {
      resumoAtivo.value = null;
      relatorioConsolidado.value = null;
      detalhes.clear();
      dificuldadeRecorrente.value = "Nenhuma identificada";
      isLoading.value = false;
      return;
    }

    final perfilId = perfil.id!;

    try {
      isLoading.value = true;

      // Sincroniza o progresso do AtividadeController antes de ler o banco
      await Get.find<AtividadeController>().recuperarProgresso();

      final resumo = await _service.getResumoPerfil(perfilId);
      final consolidado = await _service.getRelatorioConsolidado(perfilId);
      final dif = await _service.getDificuldadeRecorrente(perfilId);
      final listaDetalhes = await _service.getHistoricoCompleto(perfilId);

      // Evita exibir dados do perfil anterior quando o usuario troca a
      // selecao enquanto as consultas ainda estao em andamento.
      if (requisicao != _ultimaRequisicao ||
          Get.find<PerfilController>().perfilSelecionado.value?.id != perfilId) {
        return;
      }

      resumoAtivo.value = resumo;
      relatorioConsolidado.value = consolidado;
      detalhes.assignAll(listaDetalhes);
      dificuldadeRecorrente.value = dif;

    } catch (e) {
      print("Erro ao carregar relatório: $e");
    } finally {
      if (requisicao == _ultimaRequisicao) {
        isLoading.value = false;
      }
    }
  }
}
