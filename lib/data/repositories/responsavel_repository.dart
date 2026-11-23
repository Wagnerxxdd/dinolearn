import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../models/responsavel.dart';
import '../database/app_database.dart';

class ResponsavelRepository {
  final AppDatabase _db = AppDatabase.instance;

  // Gerar Hash da Senha (SHA-256)
  String hashSenha(String senha) {
    final bytes = utf8.encode(senha);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<int> create(Responsavel responsavel) async {
    final db = await _db.database;
    return await db.insert('responsavel', responsavel.toMap());
  }

  Future<Responsavel?> getById(int id) async {
    final db = await _db.database;
    final maps = await db.query(
      'responsavel',
      where: 'id_responsavel = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Responsavel.fromMap(maps.first);
    }
    return null;
  }

  Future<Responsavel?> getByEmail(String email) async {
    final db = await _db.database;
    final maps = await db.query(
      'responsavel',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return Responsavel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Responsavel responsavel) async {
    final db = await _db.database;
    return await db.update(
      'responsavel',
      responsavel.toMap(),
      where: 'id_responsavel = ?',
      whereArgs: [responsavel.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete(
      'responsavel',
      where: 'id_responsavel = ?',
      whereArgs: [id],
    );
  }
}
