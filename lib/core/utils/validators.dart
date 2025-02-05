class Validators {
  static String? name(String value) {
    if (value.isEmpty) return "Nome não pode ser vazio";
    return null;
  }

  static String? email(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (email.isEmpty) return "Email não pode ser vazio";
    if (!emailRegex.hasMatch(email)) return "Email inválido";

    return null;
  }

  static String? password(String password) {
    RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (password.isEmpty) return "Senha não pode ser vazia";
    if (!specialCharRegex.hasMatch(password)) return "Senha deve conter pelo menos um caractere especial";
    if (password.length < 6) return "Senha deve ter pelo menos 6 caracteres";

    return null;
  }

  static String? repeatPassword(String password, String repeatPassword) {
    if (password.isEmpty) return "Senha não pode ser vazia";
    if (password != repeatPassword) return "Senhas devem ser iguais";

    return null;
  }

  static String? phone(String phone) {
    if (phone.isEmpty) return "Telefone não pode ser vazio";
    if (phone.length < 10) return "Telefone inválido";

    return null;
  }

  static String? cpf(String cpf) {
    final cleanedCPF = cpf.replaceAll(RegExp(r'\D'), '');
    if (cleanedCPF.isEmpty) return "CPF não pode ser vazio";
    if (cleanedCPF.length != 11) return "CPF inválido";

    return null;
  }

  static String? notEmpty(String value, String fieldName) {
    if (value.isEmpty) return "$fieldName não pode ser vazio";
    return null;
  }

  static String? dateRange(DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate)) {
      return "A data de atualização não pode ser anterior à data de registro";
    }
    return null;
  }

  static String? futureDate(DateTime date, String fieldName) {
    if (date.isAfter(DateTime.now())) {
      return "$fieldName não pode ser no futuro";
    }
    return null;
  }
}
