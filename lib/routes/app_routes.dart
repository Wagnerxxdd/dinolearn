import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/perfil_form_view.dart';
import '../views/perfil_detalhes_view.dart';

import '../views/crianca/avatar_view.dart';
import '../views/crianca/dashboard_view.dart';
import '../views/responsavel/dashboard_responsavel_view.dart';
import '../views/responsavel/acompanhamento_detalhado_view.dart';
import '../views/crianca/atividades_lista_view.dart';
import '../views/crianca/atividade_play_view.dart';
import '../views/crianca/bloco_intro_view.dart';

import '../views/crianca/bloco_conclusao_view.dart';
import '../views/crianca/recompensa_view.dart';
import '../views/crianca/resumo_jornada_view.dart';
import '../views/crianca/recompensas_grade_view.dart';
import '../views/responsavel/perfil_responsavel_view.dart';
import '../views/responsavel/relatorio_crianca_view.dart';
import '../views/responsavel/personalizar_interface_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String criarPerfil = '/criar-perfil';
  static const String editarPerfil = '/editar-perfil';
  static const String detalhesPerfil = '/detalhes-perfil';
  static const String criancaDashboard = '/crianca-dashboard';
  static const String criancaAvatar = '/crianca-avatar';
  static const String criancaAtividades = '/atividades';
  static const String criancaAtividadePlay = '/atividade-play';
  static const String criancaBlocoIntro = '/bloco-intro';
  static const String criancaBlocoConclusao = '/bloco-conclusao';
  static const String criancaRecompensa = '/recompensa';
  static const String criancaResumoJornada = '/resumo-jornada';
  static const String responsavelDashboard = '/responsavel-dashboard';
  static const String perfilResponsavel = '/perfil-responsavel';
  static const String relatorioCrianca = '/relatorio-crianca';
  static const String personalizarInterface = '/personalizar-interface';
  static const String acompanhamentoDetalhado = '/acompanhamento-detalhado';
  static const String criancaPremios = '/meus-premios';

  static final pages = [
    GetPage(
      name: home,
      page: () => const HomeView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: criancaDashboard,
      page: () => const CriancaDashboardView(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: criancaAvatar,
      page: () => const AvatarView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: criancaAtividades,
      page: () => const AtividadesListaView(),
    ),
    GetPage(
      name: criancaAtividadePlay,
      page: () => const AtividadePlayView(),
    ),
    GetPage(
      name: criancaBlocoIntro,
      page: () => const BlocoIntroView(),
    ),
    GetPage(
      name: criancaBlocoConclusao,
      page: () => const BlocoConclusaoView(),
    ),
    GetPage(
      name: criancaRecompensa,
      page: () => const RecompensaView(),
    ),
    GetPage(
      name: responsavelDashboard,
      page: () => const DashboardResponsavelView(),
    ),
    GetPage(
      name: perfilResponsavel,
      page: () => const PerfilResponsavelView(),
    ),
    GetPage(
      name: relatorioCrianca,
      page: () => const RelatorioCriancaView(),
    ),
    GetPage(
      name: personalizarInterface,
      page: () => const PersonalizarInterfaceView(),
    ),
    GetPage(
      name: acompanhamentoDetalhado,
      page: () => const AcompanhamentoDetalhadoView(),
    ),
    GetPage(
      name: criancaResumoJornada,
      page: () => const ResumoJornadaView(),
    ),
    GetPage(
      name: criancaPremios,
      page: () => const RecompensasGradeView(),
    ),
    GetPage(
      name: criarPerfil,
      page: () => const PerfilFormView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: editarPerfil,
      page: () => const PerfilFormView(modoEdicao: true),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: detalhesPerfil,
      page: () => const PerfilDetalhesView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
