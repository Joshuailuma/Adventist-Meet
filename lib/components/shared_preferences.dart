import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static const _keyUserId = 'id';
  static const _keyUsername = 'username';
  static const _keyPhotoUrl = 'photoUrl';
  static const _keyDisplayName = 'displayName';
  static const _keyEmail = 'email';
  static const _keyLocation = 'location';
  static const _keyBio = 'bio';
  static const _keyAge = 'age';
  static const _keyTimeStamp = 'timestamp';
  static const _keyNotificationToken = 'notificationToken';

//TO set shared pereference for this field (id) and store the string to phone
  static Future setId(String id) async {
    SharedPreferences preferences =
        await SharedPreferences.getInstance(); //Instantiate SharedPref
    return preferences.setString(_keyUserId, id); //Store string data to phone
  }

  static Future setUsername(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_keyUsername, username);
  }

  static Future setPhotoUrl(String? photoUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_keyPhotoUrl, photoUrl!);
  }

  static Future setDisplayName(String displayName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_keyDisplayName, displayName);
  }

  static Future setEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_keyEmail, email);
  }

  static Future setLocation(String location) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_keyLocation, location);
  }

  static Future setBio(String bio) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_keyBio, bio);
  }

  static Future setAge(String age) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_keyAge, age);
  }

  static Future setTimestamp(DateTime timestampp) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final timestamp = timestampp.toIso8601String();
    return preferences.setString(_keyTimeStamp, timestamp);
  }

  static Future setNotificationToken(String notificationToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(_keyNotificationToken, notificationToken);
  }

//TO get String Id stored
  Future<String?> getId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyUserId);
  }

  Future<String?> getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyUsername);
  }

  Future<String?> getPhotoUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyPhotoUrl);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyDisplayName);
  }

  Future<String?> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyEmail);
  }

  Future<String?> getBio() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyBio);
  }

  Future<String?> getAge() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyAge);
  }

  Future<String?> getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyLocation);
  }

  Future<String?> getTimestamp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyTimeStamp);
  }

  Future<String?> getNotificationToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyNotificationToken);
  }
}
