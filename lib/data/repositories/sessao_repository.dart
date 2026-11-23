import '../../models/sessao.dart';
import '../database/app_database.dart';

class SessaoRepository {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(Sessao sessao) async {
    final db = await _db.database;
    return await db.insert('sessao', sessao.toMap());
  }

  Future<void> update(Sessao sessao) async {
    final db = await _db.database;
    await db.update(
      'sessao',
      sessao.toMap(),
      where: 'id_sessao = ?',
      whereArgs: [sessao.id],
    );
  }

  Future<void> finalizar(int idSessao, int pontuacao) async {
    final db = await _db.database;
    await db.update(
      'sessao',
      {'data_fim': DateTime.now().toIso8601String(), 'pontuacao': pontuacao},
      where: 'id_sessao = ?',
      whereArgs: [idSessao],
    );
  }
}
