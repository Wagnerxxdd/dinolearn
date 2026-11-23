import '../data/database/app_database.dart';
import 'package:sqflite/sqflite.dart';
import '../models/resumo_progresso.dart';
import '../models/relatorio_consolidado.dart';

class RelatorioAtividadeModel {
  final int idAtividade;
  final String area;
  final int nivel;
  final String titulo;
  final int tentativas;
  final int erros;
  final int dicas;
  final int tempoSegundos;
  final bool concluida;

  RelatorioAtividadeModel({
    required this.idAtividade,
    required this.area,
    required this.nivel,
    required this.titulo,
    required this.tentativas,
    required this.erros,
    required this.dicas,
    required this.tempoSegundos,
    required this.concluida,
  });
}

class RelatorioService {
  final AppDatabase _db = AppDatabase.instance;

  Future<ResumoProgresso> getResumoPerfil(int idPerfil) async {
    final db = await _db.database;

    final List<Map<String, dynamic>> ativResult = await db.rawQuery(
      '''
      SELECT COUNT(DISTINCT r.id_atividade) as total
      FROM resultado_atividade r
      INNER JOIN sessao s ON r.id_sessao = s.id_sessao
      WHERE s.id_perfil = ? AND r.acertou = 1
    ''',
      [idPerfil],
    );
    int concluidas = Sqflite.firstIntValue(ativResult) ?? 0;

    int blocos = 0;
    for (int n = 1; n <= 3; n++) {
      final List<Map<String, dynamic>> nivelResult = await db.rawQuery(
        '''
        SELECT COUNT(DISTINCT r.id_atividade) as total
        FROM resultado_atividade r
        INNER JOIN atividade a ON r.id_atividade = a.id_atividade
        INNER JOIN sessao s ON r.id_sessao = s.id_sessao
        WHERE s.id_perfil = ? AND a.nivel = ? AND r.acertou = 1
      ''',
        [idPerfil, n],
      );

      if ((Sqflite.firstIntValue(nivelResult) ?? 0) >= 3) {
        blocos++;
      }
    }

    final recompensaResult = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM perfil_recompensa
      WHERE id_perfil = ? AND id_recompensa = 1
    ''',
      [idPerfil],
    );
    final recompensaDesbloqueada =
        (Sqflite.firstIntValue(recompensaResult) ?? 0) > 0;

    return ResumoProgresso(
      blocosConcluidos: blocos,
      atividadesConcluidas: concluidas,
      estrelas: blocos,
      recompensaDesbloqueada: recompensaDesbloqueada,
    );
  }

  Future<RelatorioConsolidado> getRelatorioConsolidado(int idPerfil) async {
    final db = await _db.database;

    final List<Map<String, dynamic>> totais = await db.rawQuery(
      '''
      SELECT 
        SUM(r.tentativas) as tent,
        SUM(r.tentativas - 1) as err,
        SUM(CASE WHEN r.tentativas = 2 THEN 1 WHEN r.tentativas >= 3 THEN 2 ELSE 0 END) as dic,
        SUM(r.tempo_gasto_segundos) as tempo
      FROM resultado_atividade r
      INNER JOIN sessao s ON r.id_sessao = s.id_sessao
      WHERE s.id_perfil = ?
    ''',
      [idPerfil],
    );

    final rGeral = totais.first;

    List<ResumoBlocoConsolidado> blocosList = [];
    final temas = {1: 'Dinossauros', 2: 'Capivaras', 3: 'Axolotes'};

    for (int n = 1; n <= 3; n++) {
      final List<Map<String, dynamic>> bRes = await db.rawQuery(
        '''
        SELECT 
          COUNT(DISTINCT r.id_atividade) as conc,
          SUM(r.tentativas) as tent,
          SUM(r.tentativas - 1) as err,
          SUM(CASE WHEN r.tentativas = 2 THEN 1 WHEN r.tentativas >= 3 THEN 2 ELSE 0 END) as dic
        FROM resultado_atividade r
        INNER JOIN atividade a ON r.id_atividade = a.id_atividade
        INNER JOIN sessao s ON r.id_sessao = s.id_sessao
        WHERE s.id_perfil = ? AND a.nivel = ?
      ''',
        [idPerfil, n],
      );

      final b = bRes.first;
      blocosList.add(
        ResumoBlocoConsolidado(
          nivel: n,
          tema: temas[n]!,
          concluidas: b['conc'] ?? 0,
          tentativas: b['tent'] ?? 0,
          erros: b['err'] ?? 0,
          dicas: b['dic'] ?? 0,
          concluido: (b['conc'] ?? 0) >= 3,
        ),
      );
    }

    final List<Map<String, dynamic>> areasRes = await db.rawQuery(
      '''
      SELECT 
        d.nome as area,
        COUNT(DISTINCT r.id_atividade) as conc,
        SUM(r.tentativas) as tent,
        SUM(CASE WHEN r.tentativas = 2 THEN 1 WHEN r.tentativas >= 3 THEN 2 ELSE 0 END) as dic
      FROM resultado_atividade r
      INNER JOIN atividade a ON r.id_atividade = a.id_atividade
      INNER JOIN dificuldade d ON a.id_dificuldade = d.id_dificuldade
      INNER JOIN sessao s ON r.id_sessao = s.id_sessao
      WHERE s.id_perfil = ?
      GROUP BY d.nome
    ''',
      [idPerfil],
    );

    List<ResumoAreaConsolidada> areasList = areasRes
        .map(
          (a) => ResumoAreaConsolidada(
        area: a['area'],
        concluidas: a['conc'] ?? 0,
        tentativas: a['tent'] ?? 0,
        dicas: a['dic'] ?? 0,
      ),
    )
        .toList();

    return RelatorioConsolidado(
      totalTentativas: rGeral['tent'] ?? 0,
      totalErros: rGeral['err'] ?? 0,
      totalDicas: rGeral['dic'] ?? 0,
      tempoTotalSegundos: rGeral['tempo'] ?? 0,
      blocos: blocosList,
      areas: areasList,
    );
  }

  Future<List<RelatorioAtividadeModel>> getHistoricoCompleto(
      int idPerfil,
      ) async {
    final db = await _db.database;

    final List<Map<String, dynamic>> todas = await db.rawQuery('''
      SELECT a.*, d.nome as area_nome FROM atividade a 
      INNER JOIN dificuldade d ON a.id_dificuldade = d.id_dificuldade
      ORDER BY a.nivel ASC, a.id_dificuldade ASC
    ''');

    List<RelatorioAtividadeModel> historico = [];
    for (var ativ in todas) {
      final int idAtiv = ativ['id_atividade'];

      final List<Map<String, dynamic>> res = await db.rawQuery(
        '''
        SELECT r.* FROM resultado_atividade r
        INNER JOIN sessao s ON r.id_sessao = s.id_sessao
        WHERE s.id_perfil = ? AND r.id_atividade = ?
        ORDER BY r.data_execucao DESC LIMIT 1
      ''',
        [idPerfil, idAtiv],
      );

      if (res.isNotEmpty) {
        final r = res.first;
        final int tent = r['tentativas'];
        historico.add(
          RelatorioAtividadeModel(
            idAtividade: idAtiv,
            area: ativ['area_nome'],
            nivel: ativ['nivel'],
            titulo: ativ['titulo'],
            tentativas: tent,
            erros: tent - 1,
            dicas: tent == 2 ? 1 : (tent >= 3 ? 2 : 0),
            tempoSegundos: r['tempo_gasto_segundos'],
            concluida: r['acertou'] == 1,
          ),
        );
      } else {
        historico.add(
          RelatorioAtividadeModel(
            idAtividade: idAtiv,
            area: ativ['area_nome'],
            nivel: ativ['nivel'],
            titulo: ativ['titulo'],
            tentativas: 0,
            erros: 0,
            dicas: 0,
            tempoSegundos: 0,
            concluida: false,
          ),
        );
      }
    }
    return historico;
  }

  Future<String> getDificuldadeRecorrente(int idPerfil) async {
    final db = await _db.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT d.nome, SUM(r.tentativas - 1) as total_erros
      FROM resultado_atividade r
      INNER JOIN atividade a ON r.id_atividade = a.id_atividade
      INNER JOIN dificuldade d ON a.id_dificuldade = d.id_dificuldade
      INNER JOIN sessao s ON r.id_sessao = s.id_sessao
      WHERE s.id_perfil = ?
      GROUP BY d.nome
      ORDER BY total_erros DESC
      LIMIT 1
    ''',
      [idPerfil],
    );

    if (result.isNotEmpty && (result.first['total_erros'] ?? 0) > 0) {
      return result.first['nome'];
    }
    return "Nenhuma identificada";
  }
}
