import 'package:adventist_meet/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class BusinessSection extends StatefulWidget {
  @override
  _BusinessSectionState createState() => _BusinessSectionState();
}

class _BusinessSectionState extends State<BusinessSection> {
  final TextEditingController messageController = TextEditingController();

  String? myPhotoUrl;
  String? myUsername;
  Stream<QuerySnapshot<Object?>>? messageStream;
  DateTime now = DateTime.now(); //To get the current date and time
  DateFormat? timeFormat;

  @override
  void initState() {
    getDataFromSPAndFirestore();
    super.initState();
  }

//DO this function onlaunch
  getDataFromSPAndFirestore() async {
    await getDataFromSharedPreference();
    getMessageStream();
  }

  //To get data from shared preference
  getDataFromSharedPreference() async {
    myUsername = await MySharedPreferences().getUsername();
    myPhotoUrl = await MySharedPreferences().getPhotoUrl();
  }

//To get our stream of messages from our firestore database. We should call it on initState too
  getMessageStream() async {
    messageStream = await FirebaseFirestore.instance
        .collection('sections')
        .doc('business')
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

  messageBox(
    String msgSendBy,
    String message,
    bool isMe,
    String messageTimestampString,
    String yesterdayTimeFromJiffy,
    bool isYesterday,
  ) {
    return Container(
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0, right: 10)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0, left: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
              text: msgSendBy,
              style: TextStyle(
                color: isMe ? Colors.white38 : Colors.black54,
                fontSize: 15,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: isYesterday
                      ? ' ${yesterdayTimeFromJiffy} at ${messageTimestampString}'
                      : '  at ${messageTimestampString}',
                  style: TextStyle(
                    color: isMe ? Colors.white38 : Colors.black38,
                    fontSize: 10,
                    decoration: TextDecoration.none,
                  ),
                ),
              ]),
        ),
        SizedBox(height: 5),
        Text(message,
            style: TextStyle(
              color: isMe ? Colors.white : Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            )),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Business'),
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
                child: StreamBuilder(
                    stream: messageStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData && snapshot.data.docs.length == 0) {
                        return Container(
                          child: Center(
                            child: Text(
                              'No messages here yet',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data.docs.length != 0) {
                        return Column(
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
                                    bool isMe = ds['sendBy'] == myUsername;
                                    Timestamp messageTimestamp =
                                        ds['timestamp'];
                                    String msgSendBy = ds['sendBy'];

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

                                    String messageTimestampString = timeFormat!
                                        .format(
                                            dateTime); //Converting it to string using intl package

                                    return messageBox(
                                        msgSendBy,
                                        message,
                                        isMe,
                                        messageTimestampString,
                                        yesterdayTimeFromJiffy,
                                        isYesterday);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else
                        return Center(
                            child: Text('Something went wrong',
                                style: TextStyle(
                                  fontSize: 18,
                                )));
                    }),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
            padding: EdgeInsets.only(left: 8),
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
            alignment: Alignment.bottomCenter,
            child: Row(children: [
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
                iconSize: 25,
                onPressed: () {
                  if (messageController.text != '') {
                    DateTime messageTimestamp =
                        now; //Turning time msg was sent into a String

                    String message = messageController.text; //Our message input

                    Map<String, dynamic> messageInfoMap = {
                      //This map will be uploaded in a colletion called chats which is inside  a chat room
                      "message": message, //The message text
                      "sendBy": myUsername, //Person who sent the message
                      "timestamp": messageTimestamp, // Time message was sent
                    };

                    //Add message to database
                    FirebaseFirestore.instance
                        .collection("sections")
                        .doc('business')
                        .collection("chats")
                        .doc()
                        .set(messageInfoMap);

                    messageController.clear(); //Clear text in input field

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
