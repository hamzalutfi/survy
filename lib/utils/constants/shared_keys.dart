import 'dart:convert';

class SharedKeys {
  static String UID = "id";
  static String FIRST_NAME = "first_name";
  static String LAST_NAME = "last_name";
  static String EMAIL = "email";
  static String SERVICES_TYPE = "services_type";
  static String LOCATIONS = "locations";
  static String TYPE = "type";
  static String IS_LOGGED_IN = "is_logged_in";
  static String ACCOUNT_STATUS = "account_status";
  static String PROFILE_URL = "profile_url";

  static String encode(List<String> services) => json.encode(
        services.map<String>((service) => service).toList(),
      );

  static List<String> decode(String services) =>
      (json.decode(services) as List<dynamic>)
          .map<String>((item) => item)
          .toList();
}
