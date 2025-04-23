class User {
  final bool isLoggedIn;
  final List<String> roles;
  final List<String> policies;

  const User({
    required this.isLoggedIn,
    required this.roles,
    required this.policies,
  });
}

class Action {
  final String requiredRole;
  final String policy;

  const Action({
    required this.requiredRole,
    required this.policy,
  });
}

abstract class AccessHandler {
  AccessHandler? next;

  AccessHandler linkWith(AccessHandler handler) {
    next = handler;
    return handler;
  }

  bool check(User user, Action action);
}

class AuthCheck extends AccessHandler {
  @override
  bool check(User user, Action action) {
    if (!user.isLoggedIn) {
      print("User not logged in");
      return false;
    }
    return next?.check(user, action) ?? true;
  }
}

class RoleCheck extends AccessHandler {
  @override
  bool check(User user, Action action) {
    if (!user.roles.contains(action.requiredRole)) {
      print("Insufficient role");
      return false;
    }
    return next?.check(user, action) ?? true;
  }
}

class PolicyCheck extends AccessHandler {
  @override
  bool check(User user, Action action) {
    if (!user.policies.contains(action.policy)) {
      print("Policy restriction");
      return false;
    }
    return next?.check(user, action) ?? true;
  }
}
