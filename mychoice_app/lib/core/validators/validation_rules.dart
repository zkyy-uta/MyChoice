/// Email validation using RFC 5322 pattern
bool isValidEmail(String email) {
  // RFC 5322 simplified pattern
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

/// Password strength validation
/// Requires: 8+ characters, at least 1 uppercase letter, at least 1 digit
bool isStrongPassword(String password) {
  if (password.length < 8) return false;
  if (!password.contains(RegExp(r'[A-Z]'))) return false;
  if (!password.contains(RegExp(r'[0-9]'))) return false;
  return true;
}

/// Get password strength indicator
/// Returns: 'weak', 'medium', 'strong'
String getPasswordStrength(String password) {
  if (password.isEmpty) return 'weak';

  int strength = 0;

  // Length check
  if (password.length >= 8) strength++;
  if (password.length >= 12) strength++;

  // Character variety
  if (password.contains(RegExp(r'[a-z]'))) strength++;
  if (password.contains(RegExp(r'[A-Z]'))) strength++;
  if (password.contains(RegExp(r'[0-9]'))) strength++;
  if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

  if (strength <= 2) return 'weak';
  if (strength <= 4) return 'medium';
  return 'strong';
}

/// Validate email format
/// Returns error message if invalid, null if valid
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  }
  if (!isValidEmail(email)) {
    return 'Invalid email format';
  }
  return null;
}

/// Validate password strength
/// Returns error message if invalid, null if valid
String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  }
  if (password.length < 8) {
    return 'Password must be at least 8 characters';
  }
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!password.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one digit';
  }
  return null;
}

/// Validate name field
String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'Name is required';
  }
  if (name.length < 2) {
    return 'Name must be at least 2 characters';
  }
  return null;
}

/// Validate date of birth
String? validateDateOfBirth(DateTime? date) {
  if (date == null) {
    return 'Date of birth is required';
  }
  final now = DateTime.now();
  final age = now.year - date.year;
  if (age < 13) {
    return 'You must be at least 13 years old';
  }
  if (age > 120) {
    return 'Please enter a valid date of birth';
  }
  return null;
}
