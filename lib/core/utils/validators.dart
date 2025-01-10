class Validators {
  static String? name(String value) {
    if (value.isEmpty) {
      return "Nome não pode ser vazio";
    }

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

    if (!specialCharRegex.hasMatch(password)) return "Senha deve conter pelo menos um caractere especial";

    if (password.isEmpty) return "Senha não pode ser vazia";

    if (password.length < 6) return "Senha deve ter pelo menos 6 caracteres";

    return null;
  }

  static String? repeatPassword(String password, String repeatPassword) {
    if (password.isEmpty) return "Senha não pode ser vazia";

    if (password != repeatPassword) return "Senhas devem ser iguais";

    return null;
  }
}
