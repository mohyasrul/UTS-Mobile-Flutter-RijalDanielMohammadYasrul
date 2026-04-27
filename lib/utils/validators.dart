class AppValidators {
  static String? validateEmail(String? value) {
    final String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email wajib diisi';
    }

    final RegExp emailPattern = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailPattern.hasMatch(email)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    final String password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'Password wajib diisi';
    }

    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }
}
