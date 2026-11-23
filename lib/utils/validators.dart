/// Validadores de formulário com regras de negócio
class ValidadorFormulario {
  /// Valida o nome
  static String? validarNome(String? nome) {
    if (nome == null || nome.isEmpty) {
      return 'Nome é obrigatório';
    }
    if (nome.length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }
    if (nome.length > 100) {
      return 'Nome deve ter no máximo 100 caracteres';
    }
    return null;
  }

  /// Valida a idade
  static String? validarIdade(int? idade) {
    if (idade == null) {
      return 'Idade é obrigatória';
    }
    if (idade < 3) {
      return 'Idade mínima é 3 anos';
    }
    if (idade > 18) {
      return 'Idade máxima é 18 anos';
    }
    return null;
  }

  /// Valida a cor
  static String? validarCor(String? cor) {
    if (cor == null || cor.isEmpty) {
      return 'Cor é obrigatória';
    }
    return null;
  }

  /// Valida o som
  static String? validarSom(String? som) {
    if (som == null || som.isEmpty) {
      return 'Som é obrigatório';
    }
    return null;
  }

  /// Valida a velocidade
  static String? validarVelocidade(double? velocidade) {
    if (velocidade == null) {
      return 'Velocidade é obrigatória';
    }
    if (velocidade < 0.5) {
      return 'Velocidade mínima é 0.5';
    }
    if (velocidade > 2.0) {
      return 'Velocidade máxima é 2.0';
    }
    return null;
  }

  /// Valida as dificuldades
  static String? validarDificuldades(String? dificuldades) {
    if (dificuldades == null || dificuldades.isEmpty) {
      return 'Dificuldades são obrigatórias';
    }
    if (dificuldades.length > 500) {
      return 'Dificuldades deve ter no máximo 500 caracteres';
    }
    return null;
  }
}
