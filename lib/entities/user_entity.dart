class UserEntity {
  final String token;
  final String firstName;
  final String lastName;
  final String email;
  final String profileURL;
  String accountStatus;
  final List<String> servicesType;
  final List<String> locations;
  int type;

  UserEntity(
      {required this.token,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.type,
      required this.locations,
      required this.servicesType,
      required this.profileURL,
      required this.accountStatus
      });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      token: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      servicesType: json['services'],
      locations: json['locations'].toList(),
      type: json['type'],
      accountStatus: json['accountStatus'],
      profileURL: json['profileURL'],
    );
  }

  @override
  String toString() {
    return 'UserEntity{token: $token, firstName: $firstName, lastName: $lastName, email: $email, accountStatus: $accountStatus, servicesType: $servicesType, locations: $locations, type: $type}';
  }
}
