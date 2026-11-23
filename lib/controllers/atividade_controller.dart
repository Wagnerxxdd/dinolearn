import 'package:get/get.dart';
import '../models/atividade.dart';
import '../models/atividade_conteudo.dart';
import '../models/sessao.dart';
import '../models/resultado_atividade.dart';
import '../services/atividade_service.dart';
import '../data/repositories/sessao_repository.dart';
import '../data/repositories/resultado_atividade_repository.dart';
import '../data/repositories/avatar_repository.dart';
import '../routes/app_routes.dart';
import 'perfil_controller.dart';
import 'avatar_controller.dart';
import '../data/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

class AtividadeController extends GetxController {
  final AtividadeService _service = AtividadeService();
  final SessaoRepository _sessaoRepo = SessaoRepository();
  final ResultadoAtividadeRepository _resultadoRepo =
  ResultadoAtividadeRepository();
  final AvatarRepository _avatarRepo = AvatarRepository();

  final RxList<Atividade> atividades = <Atividade>[].obs;
  final Rx<AtividadeConteudo?> conteudoAtual = Rx<AtividadeConteudo?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;

  final RxInt nivelAtual = 1.obs;
  final RxList<Atividade> blocoAtual = <Atividade>[].obs;
  final RxInt indexAtividadeNoBloco = (-1).obs;
  final RxList<int> blocosConcluidos = <int>[].obs;

  /// Alterado sempre que um resultado e persistido, permitindo que as telas
  /// de progresso e relatorio sejam atualizadas imediatamente.
  final RxInt versaoProgresso = 0.obs;

  late final Worker _perfilWorker;

  int? sessaoAtualId;
  final RxInt tentativasAtuais = 1.obs;
  DateTime? tempoInicioAtividade;
  final RxInt pontuacaoTotalSessao = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _perfilWorker = ever(
      Get.find<PerfilController>().perfilSelecionado,
          (_) => recuperarProgresso(),
    );
    carregarAtividades();
  }

  @override
  void onClose() {
    _perfilWorker.dispose();
    super.onClose();
  }

  Future<void> carregarAtividades() async {
    try {
      isLoading.value = true;
      final lista = await _service.getAtividadesAtivas();
      atividades.assignAll(lista);
      await recuperarProgresso();
    } catch (e) {
      print("Erro ao carregar atividades: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Recuperação de progresso corrigida com nomes de colunas exatos
  Future<void> recuperarProgresso() async {
    final perfil = Get.find<PerfilController>().perfilSelecionado.value;
    if (perfil == null || perfil.id == null) {
      blocosConcluidos.clear();
      return;
    }

    final db = await AppDatabase.instance.database;
    blocosConcluidos.clear();

    for (int n = 1; n <= 3; n++) {
      // Query robusta para contar atividades concluídas por nível
      final List<Map<String, dynamic>> res = await db.rawQuery(
        '''
        SELECT COUNT(DISTINCT r.id_atividade) as total 
        FROM resultado_atividade r
        INNER JOIN sessao s ON r.id_sessao = s.id_sessao
        INNER JOIN atividade a ON r.id_atividade = a.id_atividade
        WHERE s.id_perfil = ? AND a.nivel = ? AND r.acertou = 1
      ''',
        [perfil.id, n],
      );

      int count = Sqflite.firstIntValue(res) ?? 0;
      if (count >= 3 && !blocosConcluidos.contains(n)) {
        blocosConcluidos.add(n);
      }
    }

    await _avatarRepo.sincronizarRecompensaJornada(
      perfil.id!,
      jornadaCompleta: blocosConcluidos.length >= 3,
    );

    if (Get.isRegistered<AvatarController>()) {
      await Get.find<AvatarController>().loadAvatarData();
    }
  }

  int get proximoNivelDisponivel {
    if (blocosConcluidos.isEmpty) return 1;
    if (blocosConcluidos.contains(1) && !blocosConcluidos.contains(2)) return 2;
    if (blocosConcluidos.contains(2) && !blocosConcluidos.contains(3)) return 3;
    return 4;
  }

  void iniciarProximoBloco() async {
    int nivel = proximoNivelDisponivel;
    if (nivel <= 3) {
      iniciarBloco(nivel);
    } else {
      Get.toNamed(AppRoutes.criancaResumoJornada);
    }
  }

  void iniciarBloco(int nivel) async {
    sessaoAtualId = null;
    pontuacaoTotalSessao.value = 0;
    indexAtividadeNoBloco.value = -1;
    nivelAtual.value = nivel;
    isProcessing.value = false;

    final perfilId = Get.find<PerfilController>().perfilSelecionado.value?.id;
    if (perfilId != null) {
      final novaSessao = Sessao(idPerfil: perfilId, pontuacao: 0);
      sessaoAtualId = await _sessaoRepo.create(novaSessao);
    }

    final listaNivel = atividades.where((a) => a.nivel == nivel).toList();
    listaNivel.sort((a, b) => a.idDificuldade.compareTo(b.idDificuldade));
    blocoAtual.assignAll(listaNivel);

    Get.toNamed(AppRoutes.criancaBlocoIntro);
  }

  Future<void> proximaAtividadeNoBloco() async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    indexAtividadeNoBloco.value++;

    if (indexAtividadeNoBloco.value < blocoAtual.length) {
      final atividade = blocoAtual[indexAtividadeNoBloco.value];
      tentativasAtuais.value = 1;
      tempoInicioAtividade = DateTime.now();
      await _carregarConteudoAtividade(atividade);
      isProcessing.value = false;
      if (Get.currentRoute != AppRoutes.criancaAtividadePlay) {
        Get.toNamed(AppRoutes.criancaAtividadePlay);
      }
    } else {
      if (sessaoAtualId != null) {
        await _sessaoRepo.finalizar(sessaoAtualId!, pontuacaoTotalSessao.value);
      }
      await recuperarProgresso();
      isProcessing.value = false;
      Get.offNamed(AppRoutes.criancaBlocoConclusao);
    }
  }

  Future<void> registrarSucesso() async {
    if (sessaoAtualId == null || tempoInicioAtividade == null) return;
    if (indexAtividadeNoBloco.value < 0 ||
        indexAtividadeNoBloco.value >= blocoAtual.length) {
      return;
    }

    final atividade = blocoAtual[indexAtividadeNoBloco.value];
    final tempoGasto = DateTime.now()
        .difference(tempoInicioAtividade!)
        .inSeconds;

    final resultado = ResultadoAtividade(
      idSessao: sessaoAtualId!,
      idAtividade: atividade.id!,
      acertou: true,
      tentativas: tentativasAtuais.value,
      tempoGastoSegundos: tempoGasto,
      pontuacaoObtida: 10,
    );

    await _resultadoRepo.create(resultado);
    pontuacaoTotalSessao.value += 10;
    versaoProgresso.value++;
  }

  Future<void> registrarErro() async {
    tentativasAtuais.value++;
  }

  Future<void> _carregarConteudoAtividade(Atividade atividade) async {
    final conteudo = await _service.carregarConteudo(atividade.caminhoJson);
    conteudoAtual.value = conteudo;
  }

  void limparEstadoDaSessao() {
    sessaoAtualId = null;
    pontuacaoTotalSessao.value = 0;
    indexAtividadeNoBloco.value = -1;
    conteudoAtual.value = null;
  }
}
