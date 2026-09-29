class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email obbligatoria';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Email non valida';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Telefono obbligatorio';
    if (value.length < 9) return 'Numero troppo corto';
    return null;
  }

  static String? required(String? value, String field) {
    if (value == null || value.isEmpty) return '$field obbligatorio';
    return null;
  }
}