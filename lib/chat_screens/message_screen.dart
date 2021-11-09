import 'package:adventist_meet/chat_screens/second_user_profile.dart';
import 'package:adventist_meet/components/constants.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

class MessageScreen extends StatefulWidget {
  final String secondUserName;
  final String secondUserEmail;
  final String secondUserImageUrl;
  final String secondUserNotificationToken;
  final String firstUserName;
  final String firstUserImageUrl;
  final String firstUserNotificationToken;

  const MessageScreen({
    required this.secondUserName,
    required this.secondUserEmail,
    required this.secondUserImageUrl,
    required this.secondUserNotificationToken,
    required this.firstUserName,
    required this.firstUserImageUrl,
    required this.firstUserNotificationToken,
  });

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController messageController = TextEditingController();

  String messageId = '';
  String? chatRoomId;
  String? myLocation;
  String? myPhotoUrl;
  String? myUsername;
  String? myEmail;
  Stream<QuerySnapshot<Object?>>? messageStream;
  DateTime now = DateTime.now(); //To get the current date and time
  DateFormat? timeFormat;

//To get data from shared preference
  getDataFromSharedPreference() async {
    myUsername = await MySharedPreferences().getUsername();
    myPhotoUrl = await MySharedPreferences().getPhotoUrl();
    myLocation = await MySharedPreferences().getLocation();
    myEmail = await MySharedPreferences().getEmail();
    chatRoomId = getChatRoomIdByUsersEmail(widget.secondUserEmail, myEmail);
  }

//A method to create a combined strings e.g josh_dennis, It will accept emails. Check up;
  getChatRoomIdByUsersEmail(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

//To get our stream of messages from our firestore database. We should call it on initState too
  getMessageStream() async {
    messageStream = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
    setState(() {});
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  messageBox(String message, bool isMe, String messageTimestampString,
      bool isYesterday, String yesterdayTimeFromJiffy) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: isMe
                ? EdgeInsets.only(
                    top: 0.8.h, bottom: 0.8.h, left: 18.w, right: 2.25.w)
                : EdgeInsets.only(
                    top: 0.8.h, bottom: 0.8.h, right: 18.w, left: 2.25.w),
            padding: EdgeInsets.symmetric(horizontal: 3.375.w, vertical: 1.0.h),
            decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).primaryColor
                    : Color(0xFF5F9EA0).withOpacity(0.7),
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      )),
            child: isMe
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          isYesterday
                              ? '${yesterdayTimeFromJiffy} at ${messageTimestampString}'
                              : messageTimestampString,
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 6.4.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(message,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            )),
                      ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            '${yesterdayTimeFromJiffy} at ${messageTimestampString}',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 6.3.sp,
                              fontWeight: FontWeight.w400,
                            )),
                        // SizedBox(height: 5),
                        Text(message,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.7),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            )),
                      ]),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    getDataFromSPAndFirestore();
    super.initState();
  }

//DO this function onlaunch
  getDataFromSPAndFirestore() async {
    await getDataFromSharedPreference();
    getMessageStream();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          widget.secondUserName,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SecondUserProfile(
                            secondUserName: widget.secondUserName,
                            secondUserImageUrl: widget.secondUserImageUrl,
                          )));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 3.375.w),
              child: CircleAvatar(
                radius: 2.3.h,
                child: CircleAvatar(
                  radius: 2.2.h,
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(
                    '${widget.secondUserImageUrl}',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Column(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    reverse: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot ds =
                                          snapshot.data!.docs[index];
                                      String message = ds['message'];
                                      bool isMe = ds['sendBy'] == myEmail;
                                      Timestamp messageTimestamp =
                                          ds['timestamp'];

                                      DateTime dateTime = messageTimestamp
                                          .toDate(); //Coverting timestamp to DateTime object

                                      if (MediaQuery.of(context)
                                          .alwaysUse24HourFormat) {
                                        //To check if our device is using 12 or 24 hr
                                        timeFormat = DateFormat(
                                            'kk:mm'); //Format this way if the device is 24 hrs
                                      } else {
                                        timeFormat = DateFormat(
                                            'KK:mm a'); //Format this way if the device is 12 hrs

                                      }
                                      bool isYesterday =
                                          now.difference(dateTime).inHours > 24;
                                      String yesterdayTimeFromJiffy =
                                          Jiffy(dateTime).format(
                                              'MMM do'); //Using Jiffy package

                                      String messageTimestampString =
                                          timeFormat!.format(
                                              dateTime); //Converting it to string using intl package

                                      return messageBox(
                                          message,
                                          isMe,
                                          messageTimestampString,
                                          isYesterday,
                                          yesterdayTimeFromJiffy);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 2.25.w, right: 2.25.w, bottom: 0.5.h),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Color(0xFF512E5F),
                    Colors.teal,
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
            child: Row(children: [
              IconButton(
                icon: Icon(Icons.photo),
                iconSize: 15.9.sp,
                color: Colors.white,
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  minLines: 1,
                  maxLines: 6,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Send a message...',
                      hintStyle: TextStyle(color: Colors.white54)),
                  autocorrect: true,
                  controller: messageController,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                color: Colors.white,
                iconSize: 15.9.sp,
                onPressed: () {
                  if (messageController.text != '') {
                    DateTime messageTimestamp = now;

                    String message = messageController.text; //Our message input

                    Map<String, dynamic> messageInfoMap = {
                      //This map will be uploaded in a colletion called chats which is inside  a chat room
                      "message": message, //The message text
                      "sendBy": myEmail, //Person who sent the message
                      "timestamp": messageTimestamp, // Time message was sent
                      // "secondUserImageUrl": widget
                      //     .secondUserImageUrl, //The image of the user u are chatting with
                    };

                    if (messageId == '') {
                      messageId = randomAlphaNumeric(12);
                    }

                    //Add message to database
                    FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(chatRoomId)
                        .collection("chats")
                        .doc(messageId)
                        .set(messageInfoMap)
                        .then((value) {
                      Map<String, dynamic> lastMessageInfoMap = {
                        "lastMessage": message,
                        "lastMessageTimestamp": messageTimestamp,
                        "lastMessageSendBy": myUsername,
                        "secondUserImageUrl": widget.secondUserImageUrl,
                        "secondUserUsername": widget.secondUserName,
                        "secondUserToken": widget.secondUserNotificationToken,
                        "firstUsername": widget.firstUserName,
                        "firstUserImageUrl": widget.firstUserImageUrl,
                        "firstUserToken": widget.firstUserNotificationToken,
                      };

                      //To update the last message sent
                      FirebaseFirestore.instance
                          .collection("chatrooms")
                          .doc(chatRoomId)
                          .update(lastMessageInfoMap);
                    });

                    messageController.clear(); //Clear text in input field
                    messageId = ''; //Regenerate new message id on next message

                  }
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
