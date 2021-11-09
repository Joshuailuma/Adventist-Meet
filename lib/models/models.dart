import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(); //Instantiate googleSignIn

UserModel? userModel;

// Making data accesible throuout our app regardless wether user is signed in or not

class UserModel {
  String id;
  String username;
  String photourl;
  String displayName;
  String email;
  String location;
  String bio;
  String age;
  var timestamp;

  UserModel({
    required this.id,
    required this.username,
    required this.photourl,
    required this.displayName,
    required this.email,
    required this.location,
    required this.bio,
    required this.age,
    required this.timestamp,
  });
// To fetch user details from firestore
  factory UserModel.fromFireStore(DocumentSnapshot userId) {
    return UserModel(
        id: userId.id,
        username: userId['username'],
        photourl: userId['photoUrl'],
        displayName: userId['displayName'],
        email: userId['email'],
        location: userId['location'],
        bio: userId['bio'],
        age: userId['age'],
        timestamp: userId['timestamp']);
  }
}
