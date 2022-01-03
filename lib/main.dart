import 'package:adventist_meet/chat_screens/edit_profile.dart';
import 'package:adventist_meet/chat_screens/profile.dart';
import 'package:adventist_meet/chat_screens/profile_picture.dart';
import 'package:adventist_meet/chat_screens/sign_in_screen.dart';
import 'package:adventist_meet/chat_screens/username_screen.dart';
import 'package:adventist_meet/components/local_notification.dart';
import 'package:adventist_meet/components/theme_provider.dart';
import 'package:adventist_meet/hymn_screens/dailPad_screen.dart';
import 'package:adventist_meet/hymn_screens/hymn_screen.dart';
import 'package:adventist_meet/hymn_screens/searchScreen.dart';
import 'package:adventist_meet/screens/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:adventist_meet/chat_screens/alert_dialog.dart';
import 'package:adventist_meet/chat_screens/chat_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'notes/note_home.dart';

//Receive firebase message when app is in background
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

//create channel
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'adventistmeet', //iid
  'adventistmeet', //Title
  importance: Importance.high,
);
//initialize flutter notif
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // LocalNotificationService.initialize();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
      ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return SomethingWentWrong();
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            // final FirestoreStreamPro/vider yo = FirestoreStreamProvider();
            return Sizer(
              builder: (BuildContext context, Orientation orientation,
                  DeviceType deviceType) {
                return MaterialApp(
                  initialRoute: '/HomeScreen', //The first route
                  routes: {
                    '/HomeScreen': (context) => HomeScreen(),
                    '/SignInScreen': (context) => SignInScreen(),
                    '/ChatHomeScreen': (context) => ChatHomeScreen(),
                    '/ProfileScreen': (context) => Profile(),
                    '/DailPadScreen': (context) => DailPad(),
                    '/HymnScreen': (context) => HymnScreen(),
                    '/SearchScreen': (context) => SearchScreen(),
                    '/NoteHome': (context) => NoteHome(),
                    '/UsernameScreen': (context) => UsernameScreen(),
                    '/EditProfile': (context) => EditProfile(),
                    '/ProfilePicture': (context) => ProfilePicture(),
                    // '/MessageScreen': (context) => MessageScreen(),
                  },
                  debugShowCheckedModeBanner: false,
                  title: 'Adventist Meet',
                  themeMode: themeProvider.themeMode,
                  theme: MyThemes.lightTheme,
                  darkTheme: MyThemes.darkTheme,
                  // theme: ThemeData(
                  //   appBarTheme: AppBarTheme(
                  //     backgroundColor: kPrimaryColor,
                  //   ),
                  //   scaffoldBackgroundColor: kBackgroundColor,
                  //   primaryColor: kPrimaryColor,
                  //   textTheme: Theme.of(context)
                  //       .textTheme
                  //       .apply(bodyColor: kTextColor),
                  //   visualDensity: VisualDensity.adaptivePlatformDensity,
                  // ),
                  // home: LoggedInState(),
                );
              },
            );
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return Loading();
        });
  }
}

//Defining Loading. Modify later to a circularProgress
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF512E5F),
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Container(
            child: Center(
              child: Column(
                children: [
                  Container(
                    child: Text(
                      'Welcome😁',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Castoro',
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.purple,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 40,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.greenAccent,
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                      minHeight: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Definind SomethingWentWrong. Modify later
class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Something went wrong😔\n Please restart Adventist Meet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
