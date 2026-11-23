import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  static const String dbName = 'jogo_educativo_tea.db';
  static const int dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeUnique = 'TEXT NOT NULL UNIQUE';
    const boolType = 'INTEGER NOT NULL';

    // 1. Responsavel
    await db.execute('''CREATE TABLE responsavel (
      id_responsavel $idType,
      nome $textType,
      email $textTypeUnique,
      senha_hash $textType,
      data_criacao $textType
    )''');

    // 2. Avatar
    await db.execute('''CREATE TABLE avatar (
      id_avatar $idType,
      nome $textType,
      imagem_base $textType
    )''');

    // 3. Perfil
    await db.execute('''CREATE TABLE perfil (
      id_perfil $idType,
      id_responsavel INTEGER NOT NULL,
      id_avatar INTEGER NOT NULL,
      nome $textType,
      idade INTEGER NOT NULL,
      data_criacao $textType,
      FOREIGN KEY (id_responsavel) REFERENCES responsavel (id_responsavel) ON DELETE CASCADE,
      FOREIGN KEY (id_avatar) REFERENCES avatar (id_avatar)
    )''');

    // 4. Preferencia Sensorial
    await db.execute('''CREATE TABLE preferencia_sensorial (
      id_preferencia $idType,
      id_perfil INTEGER NOT NULL UNIQUE,
      cor_preferida $textType,
      som_ativado $boolType,
      velocidade_animacao $textType,
      FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil) ON DELETE CASCADE
    )''');

    // 5. Dificuldade
    await db.execute('''CREATE TABLE dificuldade (
      id_dificuldade $idType,
      nome $textTypeUnique,
      descricao TEXT
    )''');

    // 6. Perfil Dificuldade
    await db.execute('''CREATE TABLE perfil_dificuldade (
      id_perfil_dificuldade $idType,
      id_perfil INTEGER NOT NULL,
      id_dificuldade INTEGER NOT NULL,
      prioridade INTEGER NOT NULL,
      FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil) ON DELETE CASCADE,
      FOREIGN KEY (id_dificuldade) REFERENCES dificuldade (id_dificuldade) ON DELETE CASCADE,
      UNIQUE (id_perfil, id_dificuldade),
      UNIQUE (id_perfil, prioridade)
    )''');

    // 7. Item Avatar
    await db.execute('''CREATE TABLE item_avatar (
      id_item_avatar $idType,
      nome $textType,
      categoria $textType,
      imagem $textType
    )''');

    // 8. Avatar Item
    await db.execute('''CREATE TABLE avatar_item (
      id_avatar_item $idType,
      id_perfil INTEGER NOT NULL,
      id_item_avatar INTEGER NOT NULL,
      equipado $boolType,
      FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil) ON DELETE CASCADE,
      FOREIGN KEY (id_item_avatar) REFERENCES item_avatar (id_item_avatar) ON DELETE CASCADE,
      UNIQUE (id_perfil, id_item_avatar)
    )''');

    // 9. Atividade
    await db.execute('''CREATE TABLE atividade (
      id_atividade $idType,
      id_dificuldade INTEGER NOT NULL,
      titulo $textType,
      descricao $textType,
      tipo $textType,
      nivel INTEGER NOT NULL,
      caminho_json $textType,
      ativa $boolType,
      FOREIGN KEY (id_dificuldade) REFERENCES dificuldade (id_dificuldade)
    )''');

    // 10. Sessao
    await db.execute('''CREATE TABLE sessao (
      id_sessao $idType,
      id_perfil INTEGER NOT NULL,
      data_inicio $textType,
      data_fim TEXT,
      pontuacao INTEGER NOT NULL,
      FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil) ON DELETE CASCADE
    )''');

    // 11. Resultado Atividade
    await db.execute('''CREATE TABLE resultado_atividade (
      id_resultado $idType,
      id_sessao INTEGER NOT NULL,
      id_atividade INTEGER NOT NULL,
      acertou $boolType,
      tentativas INTEGER NOT NULL,
      tempo_gasto_segundos INTEGER NOT NULL,
      pontuacao_obtida INTEGER NOT NULL,
      data_execucao $textType,
      FOREIGN KEY (id_sessao) REFERENCES sessao (id_sessao) ON DELETE CASCADE,
      FOREIGN KEY (id_atividade) REFERENCES atividade (id_atividade)
    )''');

    // 12. Recompensa
    await db.execute('''CREATE TABLE recompensa (
      id_recompensa $idType,
      nome $textType,
      descricao TEXT,
      tipo $textType,
      imagem $textType
    )''');

    // 13. Perfil Recompensa
    await db.execute('''CREATE TABLE perfil_recompensa (
      id_perfil_recompensa $idType,
      id_perfil INTEGER NOT NULL,
      id_recompensa INTEGER NOT NULL,
      data_desbloqueio $textType,
      FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil) ON DELETE CASCADE,
      FOREIGN KEY (id_recompensa) REFERENCES recompensa (id_recompensa) ON DELETE CASCADE,
      UNIQUE (id_perfil, id_recompensa)
    )''');

    // 14. Atividade Recompensa
    await db.execute('''CREATE TABLE atividade_recompensa (
      id_atividade_recompensa $idType,
      id_atividade INTEGER NOT NULL,
      id_recompensa INTEGER NOT NULL,
      FOREIGN KEY (id_atividade) REFERENCES atividade (id_atividade) ON DELETE CASCADE,
      FOREIGN KEY (id_recompensa) REFERENCES recompensa (id_recompensa) ON DELETE CASCADE,
      UNIQUE (id_atividade, id_recompensa)
    )''');

    // 15. Plano Aprendizagem
    await db.execute('''CREATE TABLE plano_aprendizagem (
      id_plano $idType,
      id_perfil INTEGER NOT NULL,
      data_criacao $textType,
      ativo $boolType,
      FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil) ON DELETE CASCADE
    )''');

    // 16. Plano Atividade
    await db.execute('''CREATE TABLE plano_atividade (
      id_plano_atividade $idType,
      id_plano INTEGER NOT NULL,
      id_atividade INTEGER NOT NULL,
      ordem INTEGER NOT NULL,
      concluida $boolType,
      FOREIGN KEY (id_plano) REFERENCES plano_aprendizagem (id_plano) ON DELETE CASCADE,
      FOREIGN KEY (id_atividade) REFERENCES atividade (id_atividade) ON DELETE CASCADE,
      UNIQUE (id_plano, ordem)
    )''');
  }
}
