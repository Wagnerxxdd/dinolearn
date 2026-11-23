import '../models/perfil.dart';
import '../models/preferencia_sensorial.dart';
import '../data/repositories/perfil_repository.dart';
import '../data/database/app_database.dart';

class PerfilService {
  final PerfilRepository _perfilRepository = PerfilRepository();

  Future<int> createPerfilCompleto({
    required Perfil perfil,
    required PreferenciaSensorial preferencia,
    required List<String> focos,
  }) async {
    final db = await AppDatabase.instance.database;

    return await db.transaction((txn) async {
      // 1. Salva o Perfil
      final idPerfil = await txn.insert('perfil', perfil.toMap());
      
      // 2. Salva a Preferência Sensorial vinculada
      final novaPreferencia = preferencia.copyWith(idPerfil: idPerfil);
      await txn.insert('preferencia_sensorial', novaPreferencia.toMap());

      // 3. Salva os Focos (Dificuldades)
      for (int i = 0; i < focos.length; i++) {
        final List<Map<String, dynamic>> difResult = await txn.query(
          'dificuldade',
          where: 'nome = ?',
          whereArgs: [focos[i]],
        );

        if (difResult.isNotEmpty) {
          await txn.insert('perfil_dificuldade', {
            'id_perfil': idPerfil,
            'id_dificuldade': difResult.first['id_dificuldade'],
            'prioridade': i + 1,
          });
        }
      }

      // 4. Inicializa os itens de avatar desbloqueados (Kit Inicial vazio ou básico)
      // Por padrão não desbloqueia nada até os 3 blocos, conforme regras.

      return idPerfil;
    });
  }

  Future<void> updatePerfilCompleto({
    required Perfil perfil,
    required PreferenciaSensorial preferencia,
    required List<String> focos,
  }) async {
    final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      // 1. Atualiza o Perfil
      await txn.update(
        'perfil',
        perfil.toMap(),
        where: 'id_perfil = ?',
        whereArgs: [perfil.id],
      );
      
      // 2. Atualiza a Preferência Sensorial
      await txn.update(
        'preferencia_sensorial',
        preferencia.toMap(),
        where: 'id_perfil = ?',
        whereArgs: [perfil.id],
      );

      // 3. Atualiza os Focos (Remove antigos e insere novos)
      await txn.delete(
        'perfil_dificuldade',
        where: 'id_perfil = ?',
        whereArgs: [perfil.id],
      );

      for (int i = 0; i < focos.length; i++) {
        final List<Map<String, dynamic>> difResult = await txn.query(
          'dificuldade',
          where: 'nome = ?',
          whereArgs: [focos[i]],
        );

        if (difResult.isNotEmpty) {
          await txn.insert('perfil_dificuldade', {
            'id_perfil': perfil.id,
            'id_dificuldade': difResult.first['id_dificuldade'],
            'prioridade': i + 1,
          });
        }
      }
    });
  }

  Future<List<Perfil>> getPerfis(int idResponsavel) async {
    final db = await AppDatabase.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, ps.cor_preferida, ps.som_ativado, ps.velocidade_animacao
      FROM perfil p
      LEFT JOIN preferencia_sensorial ps ON p.id_perfil = ps.id_perfil
      WHERE p.id_responsavel = ?
    ''', [idResponsavel]);

    List<Perfil> perfis = [];
    
    for (var map in maps) {
      final idPerfil = map['id_perfil'] as int;
      
      final List<Map<String, dynamic>> focosResult = await db.rawQuery('''
        SELECT d.nome
        FROM dificuldade d
        JOIN perfil_dificuldade pd ON d.id_dificuldade = pd.id_dificuldade
        WHERE pd.id_perfil = ?
        ORDER BY pd.prioridade ASC
      ''', [idPerfil]);
      
      final focos = focosResult.map((f) => f['nome'] as String).toList();
      
      perfis.add(Perfil.fromMap(map).copyWith(focosAprendizado: focos));
    }

    return perfis;
  }

  Future<bool> deletePerfil(int id) async {
    final rows = await _perfilRepository.delete(id);
    return rows > 0;
  }
}
