class UserProfile {
  final String id;
  final String username;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  static UserProfile fromMap(Map<String, dynamic> data) {
    print("Mapping data: $data");  // Debugging line
    return UserProfile(
      id: data['id'],
      username: data['username'] ?? 'Guest',  // Fallback to 'Guest' if username is null
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
