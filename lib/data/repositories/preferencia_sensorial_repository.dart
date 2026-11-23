import '../../models/preferencia_sensorial.dart';
import '../database/app_database.dart';

class PreferenciaSensorialRepository {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(PreferenciaSensorial preferencia) async {
    final db = await _db.database;
    return await db.insert('preferencia_sensorial', preferencia.toMap());
  }

  Future<PreferenciaSensorial?> getByPerfil(int idPerfil) async {
    final db = await _db.database;
    final maps = await db.query(
      'preferencia_sensorial',
      where: 'id_perfil = ?',
      whereArgs: [idPerfil],
    );

    if (maps.isNotEmpty) {
      return PreferenciaSensorial.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(PreferenciaSensorial preferencia) async {
    final db = await _db.database;
    return await db.update(
      'preferencia_sensorial',
      preferencia.toMap(),
      where: 'id_perfil = ?',
      whereArgs: [preferencia.idPerfil],
    );
  }
}
