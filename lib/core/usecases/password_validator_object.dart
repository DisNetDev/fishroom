PasswordValidatorObject isPasswordsValid(String password1, String password2) {
  if (password1.length < 8) {
    return PasswordValidatorObject(
        isValid: false, message: "Password must be at least 8 characters");
  }
  if (password1 != password2) {
    return PasswordValidatorObject(
        isValid: false, message: "Passwords do not match");
  }

  return PasswordValidatorObject(isValid: true, message: "");
}

class PasswordValidatorObject {
  final bool isValid;
  final String message;

  PasswordValidatorObject({required this.isValid, required this.message});
}
