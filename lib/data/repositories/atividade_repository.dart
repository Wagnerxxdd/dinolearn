import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';

class AtividadeRepository {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> seedInitialData() async {
    final db = await _db.database;
    print("--- INICIANDO SEED DE DADOS ---");

    // 1. Responsável
    await db.insert('responsavel', {
      'id_responsavel': 1,
      'nome': 'Responsável de demonstração',
      'email': 'responsavel@example.invalid',
      'senha_hash': 'demo-account-no-login',

      'data_criacao': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // 2. Avatares
    await db.insert('avatar', {
      'id_avatar': 1,
      'nome': 'Menino',
      'imagem_base': 'assets/images/avatars/base_menino.png',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('avatar', {
      'id_avatar': 2,
      'nome': 'Menina',
      'imagem_base': 'assets/images/avatars/base_menina.png',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // 3. Itens
    await db.insert('item_avatar', {
      'id_item_avatar': 1,
      'nome': 'Boné Dino',
      'categoria': 'Bonés',
      'imagem': 'assets/images/avatars/bone_dino.png',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('item_avatar', {
      'id_item_avatar': 2,
      'nome': 'Óculos',
      'categoria': 'Acessórios',
      'imagem': 'assets/images/avatars/oculos.png',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('item_avatar', {
      'id_item_avatar': 3,
      'nome': 'Fone',
      'categoria': 'Acessórios',
      'imagem': 'assets/images/avatars/fone.png',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('item_avatar', {
      'id_item_avatar': 4,
      'nome': 'Mochila',
      'categoria': 'Mochilas',
      'imagem': 'assets/images/avatars/mochila.png',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // Recompensa unica do ciclo implementado no prototipo.
    await db.insert('recompensa', {
      'id_recompensa': 1,
      'nome': 'Bone de Dinossauro',
      'descricao': 'Item cosmetico concedido ao concluir os tres blocos.',
      'tipo': 'avatar',
      'imagem': 'assets/images/avatars/bone_dino.png',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // 4. Dificuldades
    await db.insert('dificuldade', {
      'id_dificuldade': 1,
      'nome': 'Matemática',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('dificuldade', {
      'id_dificuldade': 2,
      'nome': 'Português',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('dificuldade', {
      'id_dificuldade': 3,
      'nome': 'Cotidiano',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // 5. Atividades (Inserção individual para garantir sucesso)
    await _garantirAtividade(
      db,
      1,
      1,
      'Conte os dinossauros',
      'assets/atividades/matematica/dino_contagem.json',
    );
    await _garantirAtividade(
      db,
      2,
      1,
      'Encontre a palavra',
      'assets/atividades/portugues/dino_palavra.json',
    );
    await _garantirAtividade(
      db,
      3,
      1,
      'Ajudando o amigo',
      'assets/atividades/cotidiano/dino_ajuda.json',
    );

    await _garantirAtividade(
      db,
      1,
      2,
      'Capivaras no rio',
      'assets/atividades/matematica/capivara_soma.json',
    );
    await _garantirAtividade(
      db,
      2,
      2,
      'Onde está a capivara?',
      'assets/atividades/portugues/capivara_leitura.json',
    );
    await _garantirAtividade(
      db,
      3,
      2,
      'Pedindo para brincar',
      'assets/atividades/cotidiano/capivara_brinquedo.json',
    );

    await _garantirAtividade(
      db,
      1,
      3,
      'Axolotes nos aquários',
      'assets/atividades/matematica/axolote_soma_sub.json',
    );
    await _garantirAtividade(
      db,
      2,
      3,
      'Organize a frase',
      'assets/atividades/portugues/axolote_frase.json',
    );
    await _garantirAtividade(
      db,
      3,
      3,
      'Pedindo ajuda',
      'assets/atividades/cotidiano/axolote_ajuda.json',
    );

    print("--- SEED CONCLUÍDO COM SUCESSO ---");
  }

  Future<void> _garantirAtividade(
      Database db,
      int idDif,
      int nivel,
      String titulo,
      String path,
      ) async {
    final result = await db.query(
      'atividade',
      where: 'caminho_json = ?',
      whereArgs: [path],
    );
    if (result.isEmpty) {
      await db.insert('atividade', {
        'id_dificuldade': idDif,
        'titulo': titulo,
        'descricao': 'Nível $nivel',
        'tipo': 'padrao',
        'nivel': nivel,
        'caminho_json': path,
        'ativa': 1,
      });
      print("Atividade Inserida: $titulo");
    }
  }

  Future<List<Map<String, dynamic>>> getAllAtivas() async {
    final db = await _db.database;
    return await db.query('atividade', where: 'ativa = ?', whereArgs: [1]);
  }
}
