import 'package:adventist_meet/chat_screens/bible_study_section.dart';
import 'package:adventist_meet/chat_screens/business_section.dart';
import 'package:adventist_meet/chat_screens/jobs_section.dart';
import 'package:adventist_meet/chat_screens/love_section.dart';
import 'package:adventist_meet/chat_screens/message_screen.dart';
import 'package:adventist_meet/chat_screens/profile.dart';
import 'package:adventist_meet/components/section_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isSearching = false;
  String? sharedPreferencePhotoUrl;
  String? sharedPreferenceEmail;
  String? sharedPreferenceUsername;
  String? secondUserEmailFromChatroom;
  String? sharedPreferenceNotificationToken;
  bool? isMyEmail;
  DateFormat? timeFormat;
  DateTime now = DateTime.now(); //To get the current date and time
  bool isRead = false;

  // String? secondUserEmailFromChatroom;
  QuerySnapshot<Map<String, dynamic>>? secondUserEmailFromUsers;
  String? secondUserImageUrlFromUsers;
  String? secondUserUsernameFromUsers;
  String? secondUserNotificationTokenFromUsers;

  Stream<QuerySnapshot<Map<String, dynamic>>>? searchResultStream,
      chatRoomListStream;

  TextEditingController searchController = TextEditingController();

  int _selectedIndex = 0;

  bool showWidgetFor1Sec = true;
  Timer? _timer;

  startTimer() {
    _timer = Timer(Duration(seconds: 5), () {
      setState(() {
        showWidgetFor1Sec = false;
      });
    });
  }

  List<Widget> list = [
    Tab(
      child: Text('Messages',
          style: TextStyle(
            fontSize: 9.0.sp,
          )),
      icon: Icon(Icons.message_outlined, size: 15.625.sp),
    ),
    Tab(
      child: Text('Sections',
          style: TextStyle(
            fontSize: 9.0.sp,
          )),
      icon: Icon(Icons.people, size: 15.625.sp),
    ),
    Tab(
      child: Text('Search',
          style: TextStyle(
            fontSize: 9.0.sp,
          )),
      icon: Icon(Icons.search, size: 15.625.sp),
    ),
  ];

//Stuff to do When state is created
  @override
  void initState() {
    super.initState();
    getDataFromSPAndFirestore();
    makeReferenceToSecondUserDatabase();
    startTimer();
    _tabController = TabController(length: list.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

//Do this on initState
  getDataFromSPAndFirestore() async {
    await getDetailsFromSP();
    getRecentChatRoom();
  }

//To get details from sharedPreferences
  getDetailsFromSP() async {
    sharedPreferencePhotoUrl = await MySharedPreferences().getPhotoUrl();
    sharedPreferenceEmail = await MySharedPreferences().getEmail();
    sharedPreferenceUsername = await MySharedPreferences().getUsername();
    sharedPreferenceNotificationToken =
        await MySharedPreferences().getNotificationToken();
    setState(() {});
  }

//To get the recent people you talked with
  getRecentChatRoom() async {
    chatRoomListStream = await FirebaseFirestore.instance
        .collection('chatrooms')
        .orderBy('lastMessageTimestamp', descending: true)
        .where('users', arrayContains: sharedPreferenceEmail)
        .snapshots();
    setState(() {});
  }

  //To make reference to the second user Email from Database of Users. From there we will get hold of his/her photourl and mayble other details if we want to.
  makeReferenceToSecondUserDatabase() async {
    secondUserEmailFromUsers = await usersRef
        .where('email', isEqualTo: secondUserEmailFromUsers)
        .get();
    secondUserImageUrlFromUsers = secondUserEmailFromUsers!.docs[0]['imageUrl'];
    secondUserUsernameFromUsers = secondUserEmailFromUsers!.docs[0]['username'];
    secondUserNotificationTokenFromUsers =
        secondUserEmailFromUsers!.docs[0]['notificationToken'];
    setState(() {});
  }

//A method to create a combined strings e.g josh_dennis, It will accept emails as an argument. Check the function at the top of this;
  getChatRoomIdByEmail(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  catchError2() {
    final snackBar = SnackBar(
      content: Text(
        'You cannot search for yourself',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.deepPurple,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// To search in firebase when search button is clicked
  onTapSearchButton() async {
    bool isSearchMe = searchController.text != sharedPreferenceUsername;

    if (isSearchMe) {
      isSearching = true;
      searchResultStream = await usersRef
          .where('username', isEqualTo: searchController.text)
          .snapshots(); //To search for the exact name in the controller
      setState(() {});
      isSearching = false;
    } else
      return catchError2();
    ;
  }

  Widget ourSearchStreamBuilder() {
    return StreamBuilder(
      stream: searchResultStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData && snapshot.data.docs.length != 0) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 5.625.w, vertical: 2.0.h),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var ds = snapshot.data.docs[index];
              var secondUserName = ds['username'];
              var secondUserEmail = ds['email'];
              var secondUserImageUrl = ds['photoUrl'];
              var secondUserNotificationToken = ds['notificationToken'];
              return GestureDetector(
                onTap: () async {
                  var chatRoomId = getChatRoomIdByEmail(
                      sharedPreferenceEmail, secondUserEmail);

                  Map<String, dynamic> chatRoomInfoMap = {
                    "users": [sharedPreferenceEmail, secondUserEmail]
                  };

                  // To check if a chatroom already exist, if not, create one

                  final snapShot = await FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(chatRoomId)
                      .get();

                  //To check if chatRoom already exist
                  if (snapShot.exists) {
                    //Chat room already exist
                    true;
                  } else {
                    //Chatroom doesn't exist
                    FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(chatRoomId)
                        .set(chatRoomInfoMap);
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MessageScreen(
                                secondUserName: secondUserName,
                                secondUserEmail: secondUserEmail,
                                secondUserImageUrl: secondUserImageUrl,
                                secondUserNotificationToken:
                                    secondUserNotificationToken,
                                firstUserName: sharedPreferenceUsername!,
                                firstUserImageUrl: sharedPreferencePhotoUrl!,
                                firstUserNotificationToken:
                                    sharedPreferenceNotificationToken!,
                              )));
                },
                child: ListTile(
                  title: Text(secondUserName,
                      style: TextStyle(
                        fontSize: 12.6.sp,
                      )),
                  leading: CircleAvatar(
                    child: Image.network(
                      secondUserImageUrl,
                      height: 2.5.h,
                      width: 5.625.w,
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasData && snapshot.data.docs.length == 0) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.625.w, vertical: 2.0.h),
            child: Center(
              child: Text(
                "That username doesn't exist.\n\n"
                "Remember that Usernames are case sensitive.\n\n"
                "A capital letter 'O' is different from a small letter 'o'.\n\n",
                style: TextStyle(
                  fontSize: 11.5.sp,
                ),
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.625.w, vertical: 2.0.h),
            child: Center(
              child: Text(
                  'Search for people using thier usernames and start chatting right away',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                  )),
            ),
          );
        } else
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.625.w, vertical: 2.0.h),
            child: Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 11.5.sp,
                ),
              ),
            ),
          );
      },
    );
  }

  @override
  void dispose() {
    //clean up the controller when the widget is removed from the widget tree
    _tabController.dispose();
    searchController.dispose();
    _timer?.cancel(); //Dispose timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          iconSize: 18.75.sp,
          color: Colors.white,
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/HomeScreen'));
          },
        ),
        bottom: TabBar(
          onTap: (index) {},
          tabs: list,
          controller: _tabController,
        ),
        elevation: 0,
        title: Text(
          'Adventist Meet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.7.sp,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 3.375.w),
              child: showWidgetFor1Sec
                  ? CircleAvatar(
                      radius: 2.2.h,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/images/place_holder.png'),
                    )
                  : CircleAvatar(
                      radius: 2.3.h,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 2.2.h,
                        backgroundColor: Colors.white,
                        backgroundImage: CachedNetworkImageProvider(
                          '${sharedPreferencePhotoUrl}',
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: TabBarView(controller: _tabController, children: [
        StreamBuilder(
          stream: chatRoomListStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data.docs.length == 0) {
              return Container(
                margin:
                    EdgeInsets.symmetric(horizontal: 5.625.w, vertical: 2.0.h),
                child: Center(
                  child: Text(
                    'You have no recent chats yet,\n\n'
                    'You can meet someone from SECTIONS then send them a direct message by searching for them using their USERNAME.\n\n',
                    style: TextStyle(fontSize: 11.5.sp),
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data.docs.length != 0) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];

                      String firstUserEmailFromChatroom = ds.id
                          .replaceAll(sharedPreferenceEmail!, '')
                          .replaceAll('_',
                              ''); //To get email from what used in creating our combined document id in chatroom,
                      //we removed our email (replacing it with an empty string) and left the email of the second user

                      secondUserEmailFromChatroom = ds.id
                          .replaceAll(firstUserEmailFromChatroom, '')
                          .replaceAll('_', '');

                      String secondUserImg = ds['secondUserImageUrl'];

                      String secondUserUsernameFromChatRoom =
                          ds['secondUserUsername'];

                      String secondUserNotificationTokenFromChatRoom =
                          ds['secondUserToken'];

                      bool isMe = sharedPreferenceUsername ==
                          secondUserUsernameFromChatRoom; //To check if the second user is me, so that the same person will not show on the devices of two users

                      String secondUserLastMsg = ds['lastMessage'];

                      Timestamp messageTimestamp = ds['lastMessageTimestamp'];

                      String firstUserUsername = ds['firstUsername'];
                      String firstUserImageUrl = ds['firstUserImageUrl'];
                      String firstUserNotificationToken = ds['firstUserToken'];

                      DateTime dateTime = messageTimestamp
                          .toDate(); //Coverting Timestamp object to DateTime object

                      timeFormat = DateFormat('KK:mm a');

                      if (MediaQuery.of(context).alwaysUse24HourFormat) {
                        //To check if our device is using 12 or 24 hr
                        timeFormat = DateFormat(
                            'kk:mm'); //Format this way if the device is 24 hrs
                      } else {
                        timeFormat = DateFormat(
                            'KK:mm a'); //Format this way if the device is 12 hrs
                      }

                      String lastTimeFromJiffy = Jiffy(dateTime)
                          .startOf(Units.MINUTE)
                          .fromNow(); //Using Jiffy package

                      isMyEmail =
                          secondUserEmailFromChatroom == sharedPreferenceEmail;

                      bool isNull1 = firstUserUsername == null;
                      bool isNull2 = firstUserImageUrl == null;

                      return Container(
                        margin: EdgeInsets.only(
                            top: 0.5.h, bottom: 0.5.h, right: 0.45.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.5.w, vertical: 1.0.h),
                        decoration: BoxDecoration(
                          color: Color(0xFF5F9EA0).withOpacity(0.7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 2.5.h,
                                    backgroundImage: isMe
                                        ? CachedNetworkImageProvider(
                                            isNull2 ? 'jj' : firstUserImageUrl)
                                        : CachedNetworkImageProvider(
                                            secondUserImg),
                                  ),
                                  SizedBox(width: 2.25.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isMe
                                          ? Text(
                                              isNull1
                                                  ? 'Friend'
                                                  : firstUserUsername,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : Text(
                                              secondUserUsernameFromChatRoom,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                      SizedBox(height: 0.45.h),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Text(
                                          secondUserLastMsg,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    lastTimeFromJiffy,
                                    style: TextStyle(
                                      fontSize: 8.8.sp,
                                    ),
                                  ),
                                  Text(isRead ? 'New' : ''),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            print(isMe
                                ? firstUserUsername
                                : secondUserUsernameFromChatRoom);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessageScreen(
                                          secondUserName: isMe
                                              ? firstUserUsername
                                              : secondUserUsernameFromChatRoom, //if i'm not seconduser in database show seconduser name in next screen, if im not show my name
                                          secondUserEmail: isMyEmail!
                                              ? firstUserEmailFromChatroom //Jo
                                              : secondUserEmailFromChatroom!,
                                          secondUserImageUrl: isMe
                                              ? firstUserImageUrl
                                              : secondUserImg,
                                          secondUserNotificationToken: isMe
                                              ? firstUserNotificationToken
                                              : secondUserNotificationTokenFromChatRoom,
                                          firstUserName: isMe
                                              ? secondUserUsernameFromChatRoom
                                              : firstUserUsername,
                                          firstUserImageUrl: isMe
                                              ? secondUserImg
                                              : firstUserImageUrl,
                                          firstUserNotificationToken: isMe
                                              ? secondUserNotificationTokenFromChatRoom
                                              : firstUserNotificationToken,
                                        )));
                          },
                        ),
                      );
                    }),
              );
            } else if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else
              return Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              );
          },
        ),

        //Places
        Padding(
          padding: EdgeInsets.only(top: 2.5.h, left: 4.5.w, right: 4.5.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                ),
              ],
              color: Theme.of(context).errorColor,
            ),
            child: ListView(
              children: [
                SizedBox(height: 2.0.h),
                Section(
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BibleStudySection()));
                  },
                  text1: Text(
                    'Bible study',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  text2: Text(
                    'Study God\'s word with someome',
                    style: TextStyle(
                      fontSize: 9.5.sp,
                    ),
                  ),
                  containerColor: Colors.black.withOpacity(0.2),
                  image: Image.asset('assets/images/bible.png'),
                ),
                Divider(),
                Section(
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => JobsSection()));
                  },
                  text1: Text('Jobs',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  text2: Text('Give a Job to an Adventist',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                      )),
                  containerColor: Colors.black.withOpacity(0.2),
                  image: Image.asset('assets/images/job2.png'),
                ),
                Divider(),
                Section(
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoveSection()));
                  },
                  text1: Text('Love',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  text2: Text('Find a Partner',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                      )),
                  image: Image.asset('assets/images/chat.png'),
                  containerColor: Color(0xFFE34234).withOpacity(0.2),
                ),
                Divider(),
                Section(
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BusinessSection()));
                  },
                  text1: Text(
                    'Business',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                  text2: Text('Advertise your Business',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                      )),
                  image: Image.asset('assets/images/business.png'),
                  containerColor: Color(0xFF6495ED).withOpacity(0.2),
                ),
                Divider(),
              ],
            ),
          ),
        ),

        //Search
        Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.0.h),
              padding:
                  EdgeInsets.symmetric(horizontal: 5.625.w, vertical: 1.0.h),
              child: TextField(
                style: TextStyle(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.blue
                      : Colors.white,
                  fontSize: 12.sp,
                ),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.red.shade100
                      : Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.search,
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? Colors.blue
                          : Colors.white),
                  suffixIcon: Icon(Icons.star,
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? Colors.blue
                          : Colors.white),
                  hintText: 'Type a username',
                  hintStyle: TextStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.blue.withOpacity(0.3)
                        : Color(0xFFCCCCFF),
                  ),
                ),
                controller: searchController,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(33.75.w, 5.0.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {
                if (searchController.text.isNotEmpty) {
                  onTapSearchButton();
                  searchController.clear();
                }
              },
              child: Text(
                'Search',
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
            ),
            isSearching == true
                ? CircularProgressIndicator()
                : SizedBox(height: 20.0.h, child: ourSearchStreamBuilder())
            //Normally show widget here
          ],
        ),
      ]),
    );
  }
}
