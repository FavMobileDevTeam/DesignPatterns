class UserProfile {
  final String avatar;
  final String status;

  UserProfile(this.avatar, this.status);
}

class User {
  final String name;
  final UserProfile profile;

  User(this.name, this.profile);
}

class UserService {
  final Map<String, UserProfile> _profiles = {};

  UserProfile getProfile(String avatar, String status) {
    final key = '$avatar:$status';
    if (!_profiles.containsKey(key)) {
      _profiles[key] = UserProfile(avatar, status);
    }
    return _profiles[key]!;
  }

  User getUser(String name, String avatar, String status) {
    final profile = getProfile(avatar, status);
    return User(name, profile);
  }
}
