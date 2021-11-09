import 'package:adventist_meet/components/hymn_container.dart';
import 'package:adventist_meet/components/local_notification.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? photoUrlFromSP;
  String? usernameFromSP;

  @override
  void initState() {
    //Open app from terminated state when user tap on notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message);
        Navigator.pushNamed(context, '/ChatHomeScreen');
      }
    });

    // //Notification for foreground
    // FirebaseMessaging.onMessage.listen((message) {
    //   if (message.notification != null) {
    //     LocalNotificationService.display(
    //         message); // to display headsup when app is opened
    //   }
    // });

    //Notification for background but app running
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print(message);
        Navigator.pushNamed(context, '/ChatHomeScreen');
      }
    });

    getDetailsFromSP();
    super.initState();
  }

  getDetailsFromSP() async {
    photoUrlFromSP = await MySharedPreferences().getPhotoUrl();
    usernameFromSP = await MySharedPreferences().getUsername();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
          title: Text(
            usernameFromSP == null ? 'Hi there' : 'Hi ${usernameFromSP}',
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          ),
          actions: [
            photoUrlFromSP == null
                ? Text('')
                : Padding(
                    padding: EdgeInsets.only(right: 1.5.w),
                    child: CircleAvatar(
                      radius: 2.3.h,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 2.2.h,
                        backgroundImage: CachedNetworkImageProvider(
                          '${photoUrlFromSP}',
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Image.asset('assets/images/Untitled2.png'),
            ),
            HymnContainer(
              image1: 'assets/images/chat.png',
              text: 'Meet someone',
              image2: 'assets/images/Chat_Icon.png',
              height: 2.0.h,
              width: 4.5.w,
              press: () {
                Navigator.pushNamed(context, '/SignInScreen');
              },
            ),
            HymnContainer(
              image1: 'assets/images/hymn1.jpg',
              text: 'Sing praises to God',
              image2: 'assets/images/microphone.png',
              height: 2.0.h,
              width: 4.5.w,
              press: () {
                Navigator.pushNamed(context, '/HymnScreen');
              },
            ),
            HymnContainer(
              image1: 'assets/images/bible.png',
              text: 'Study God\'s Word',
              image2: 'assets/images/Jesus.png',
              height: 2.4.h,
              width: 54.w,
              press: () {
                Navigator.pushNamed(context, '/Hello');
              },
            ),
          ],
        ),
      ),
    );
  }
}
