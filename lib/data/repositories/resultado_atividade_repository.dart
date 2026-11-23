import '../../models/resultado_atividade.dart';
import '../database/app_database.dart';

class ResultadoAtividadeRepository {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(ResultadoAtividade resultado) async {
    final db = await _db.database;
    return await db.insert('resultado_atividade', resultado.toMap());
  }

  Future<List<ResultadoAtividade>> getBySessao(int idSessao) async {
    final db = await _db.database;
    final result = await db.query(
      'resultado_atividade',
      where: 'id_sessao = ?',
      whereArgs: [idSessao],
    );
    return result.map((json) => ResultadoAtividade.fromMap(json)).toList();
  }
}
