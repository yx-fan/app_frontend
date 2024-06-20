class User {
  final String userId;
  final String nickname;
  final String email;
  final bool emailVerified;
  final String role;
  final Profile profile;
  final NotificationSettings notificationSettings;

  User({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.emailVerified,
    required this.role,
    required this.profile,
    required this.notificationSettings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      nickname: json['nickname'],
      email: json['email'],
      emailVerified: json['emailVerified'],
      role: json['role'],
      profile: Profile.fromJson(json['profile']),
      notificationSettings: NotificationSettings.fromJson(json['notificationSettings']),
    );
  }
}

class Profile {
  final String nickname;

  Profile({required this.nickname});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(nickname: json['nickname']);
  }
}

class NotificationSettings {
  final EmailNotifications emailNotifications;
  final PushNotifications pushNotifications;
  final InboxMessageToggle inboxMessageToggle;

  NotificationSettings({
    required this.emailNotifications,
    required this.pushNotifications,
    required this.inboxMessageToggle,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      emailNotifications: EmailNotifications.fromJson(json['emailNotifications']),
      pushNotifications: PushNotifications.fromJson(json['pushNotifications']),
      inboxMessageToggle: InboxMessageToggle.fromJson(json['inboxMessageToggle']),
    );
  }
}

class EmailNotifications {
  final bool enabled;
  final String frequency;

  EmailNotifications({required this.enabled, required this.frequency});

  factory EmailNotifications.fromJson(Map<String, dynamic> json) {
    return EmailNotifications(
      enabled: json['enabled'],
      frequency: json['frequency'],
    );
  }
}


class PushNotifications {
  final bool enabled;
  final String frequency;

  PushNotifications({required this.enabled, required this.frequency});

  factory PushNotifications.fromJson(Map<String, dynamic> json) {
    return PushNotifications(
      enabled: json['enabled'],
      frequency: json['frequency'],
    );
  }
}

class InboxMessageToggle {
  final bool enabled;

  InboxMessageToggle({required this.enabled});

  factory InboxMessageToggle.fromJson(Map<String, dynamic> json) {
    return InboxMessageToggle(enabled: json['enabled']);
  }
}