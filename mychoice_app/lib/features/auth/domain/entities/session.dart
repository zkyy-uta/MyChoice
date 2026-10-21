/// Session entity for authentication token management
class Session {
  final String token;
  final String? refreshToken;
  final DateTime expiresAt;
  final DateTime createdAt;

  const Session({
    required this.token,
    this.refreshToken,
    required this.expiresAt,
    required this.createdAt,
  });

  /// Check if session has expired
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Check if session is expiring soon (within 5 minutes)
  bool get isExpiringSoon {
    final now = DateTime.now();
    final warningThreshold = expiresAt.subtract(const Duration(minutes: 5));
    return now.isAfter(warningThreshold) && !isExpired;
  }

  /// Get remaining time in session
  Duration get remainingTime {
    final now = DateTime.now();
    if (isExpired) return Duration.zero;
    return expiresAt.difference(now);
  }

  @override
  String toString() =>
      'Session(token_length: ${token.length}, expires: $expiresAt, expired: $isExpired)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Session && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}
