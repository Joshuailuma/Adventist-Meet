//No models import should be found here

import 'package:adventist_meet/components/local_notification.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:adventist_meet/chat_screens/chat_home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(); //Instantiate googleSignIn
final GoogleSignInAccount? googleAccount = googleSignIn.currentUser;

final usersRef = FirebaseFirestore.instance
    .collection('users'); //To make a reference to Users collection in firestore

final DateTime timestamp =
    DateTime.now(); // To get the date user created the account

// User? userDetail;

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
//We will store our user data here and pass it to diferent pages

  bool isAuth = false;
  bool isLoading = false;
  String? sharedPreferenceUserId;
  // String? notificationToken;

  @override
  void initState() {
    super.initState();

    checkForSharedPreference();
  }

//Check if user exists in phone before execution of other functions at the bottom of this function
  checkForSharedPreference() async {
    sharedPreferenceUserId = await MySharedPreferences().getId();
    if (sharedPreferenceUserId != null) {
      setState(() {
        isAuth = true;
      });
    } else {
      doThisOnInactiveSharedPreference();
      setState(() {
        isAuth = false;
      });
    }
  }

  configurePushNotification() {
    // //Open app from terminated state when user tap on notification
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     print('Appp received');
    //     Navigator.pushNamed(context, '/ChatHomeScreen');
    //   }
    // });

    final GoogleSignInAccount? googleAccount = googleSignIn.currentUser;

    FirebaseMessaging.instance.getToken().then((notificationToken) => {
          MySharedPreferences.setNotificationToken(notificationToken!),
          usersRef
              .doc(googleAccount!.id)
              .update({'notificationToken': notificationToken})
        });
    // //Notification for foreground
    // FirebaseMessaging.onMessage.listen((message) {
    //   if (message.notification != null) {
    //     // LocalNotificationService.display(
    //     //     message); // to display headsup when app is opened
    //   }
    // });

    // //Notification for background but app running
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   if (message.notification != null) {
    //     print('App received');
    //     Navigator.pushNamed(context, '/ChatHomeScreen');
    //   }
    // });
  }

//This is suppose to happen in initState when user is not in sharedpreferences

  doThisOnInactiveSharedPreference() {
// This signs into our google account

    handleSignIn(GoogleSignInAccount? account) async {
      if (account != null) {
        print('Acc not null');
        print(account.id);
        print(account.email);
      } else {
        print('Acc is null');
        await googleSignIn.signIn();

        print('Acc is null');
        // setState(() {
        //   isLoading = false;
        // });
      }
    }

    //This logs into(verifies) our google account before we can check if it exists in firestore
    googleSignIn.signInSilently(suppressErrors: false).then(
      (account) {
        handleSignIn(account);
      },
    );

    // googleSignIn.onCurrentUserChanged.listen((account) {
    //   handleSignIn(account);
    // });
  }

  //To display error on fetchin document
  catchError2() {
    final snackBar = SnackBar(
      content: Text(
        'Please tap on the \'SIGN IN\' button again.',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.deepPurple,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//To display an error during signin in using a scaffold widget
  catchError() {
    final snackBar = SnackBar(
      content: Text(
        'Your phone is not connected to the internet⚠️',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.deepPurple,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//To finally login, also checking if user exists in firestore
  login() async {
    checkUserInFirestore();
  }

  checkUserInFirestore() async {
    final GoogleSignInAccount? googleAccount = googleSignIn.currentUser;

    setState(() {
      // Show loading during valiation
      isLoading = true;
    });

    await googleSignIn.signIn().then((value) {
      var userIf = usersRef.doc(googleAccount!.id).get();
    }).catchError((e) {
      setState(() {
        isLoading = false;
        isAuth = false;
      });
      catchError2();
    });

    //To get the Google account id from firestore
    DocumentSnapshot userId =
        await usersRef.doc(googleAccount!.id).get().catchError((e) {
      print(e);
      setState(() {
        isLoading = false;
        isAuth = false;
      });
      catchError2();
    });

    ///To get the user id from documents

    //if user doesn't have an ID in document in firestore, generate his details and take him to create username page
    if (userId.exists == false) {
      print('This ID doesn\'t exist in firestore');

      usersRef.doc(googleAccount.id).set({
        "id": googleAccount.id,
        "username": '',
        "photoUrl": googleAccount.photoUrl,
        "displayName": googleAccount.displayName,
        "email": googleAccount.email,
        "location": '',
        "bio": '',
        "age": '',
        "timestamp": timestamp,
        // "notificationToken": notificationToken,
      });
      configurePushNotification();

      // Store each details in sharedPreferences

      await MySharedPreferences.setId(googleAccount.id);
      await MySharedPreferences.setPhotoUrl(googleAccount.photoUrl);

      await MySharedPreferences.setEmail(googleAccount.email);

      await MySharedPreferences.setTimestamp(timestamp);

      Navigator.pushNamed(context, '/UsernameScreen');
      setState(() {
        // Stop loading circularProgress during valiation
        isLoading = false;
      });
    } else if (userId.exists == true) {
      print('This ID exists in firestore');

      configurePushNotification();

      await MySharedPreferences.setId(googleAccount.id);

      await MySharedPreferences.setPhotoUrl(googleAccount.photoUrl);

      await MySharedPreferences.setEmail(googleAccount.email);

      await MySharedPreferences.setTimestamp(timestamp);

      Navigator.pushNamed(context, '/UsernameScreen');

      setState(() {
        isLoading = false;
      });
    }
    // }
  }

  Scaffold signInScreen() {
    //Todo implement hero animation
    return Scaffold(
      body: isLoading
          ? Center(
              child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  child: CircularProgressIndicator(
                    //if isLoading is true return circulaProgressIndicator..
                    //else (i.e if false) return container
                    backgroundColor: Color(0xFFE3319D),
                    valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 130,
                  height: 130,
                  child: Text(
                    'Signing in...',
                    style: TextStyle(
                      decoration: TextDecoration.overline,
                      decorationThickness: 0.4,
                      fontSize: 18,
                      fontFamily: 'Castoro',
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ],
            ))
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.purple,
                    Color(0xFF512E5F),
                    Colors.teal,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 27,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  Text(
                    'Adventist Meet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Castora',
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.double,
                      decorationThickness: 0.2,
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: login,
                    child: Container(
                      width: 260,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          )
                        ],
                        image: DecorationImage(
                          image: AssetImage('assets/images/google_signIn.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isAuth == false) {
      return signInScreen();
    } else {
      return ChatHomeScreen();
    }
  } //if isAuth is true, ChatHomeScreen will display if false signInScreen will be displayed
}
