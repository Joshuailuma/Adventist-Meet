import 'package:adventist_meet/chat_screens/second_user_image.dart';
import 'package:adventist_meet/components/constants.dart';
import 'package:adventist_meet/components/profile_cards.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SecondUserProfile extends StatelessWidget {
  final String secondUserName;
  final String secondUserImageUrl;

  const SecondUserProfile({
    required this.secondUserName,
    required this.secondUserImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          '${secondUserImageUrl}',
                          maxWidth: MediaQuery.of(context).size.width.toInt(),
                          maxHeight: MediaQuery.of(context).size.width.toInt(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.85),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.3.w),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 1.125.w,
                              right: 1.125.w,
                              top: 1.0.h,
                              bottom: 0.5.h,
                            ),
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.arrow_back,
                              color: kBackgroundColor,
                              size: 18.75.sp,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 1.125.w,
                            vertical: 1.0.h,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${secondUserName}\'s Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.8,
                              fontSize: 15.9.sp,
                              color: kBackgroundColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SecondUserImage(
                                          secondUserImageUrl:
                                              secondUserImageUrl)));
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 13.h,
                                  width: 29.25.w,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            child: CircleAvatar(
                                              radius: 6.0.h,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      '${secondUserImageUrl}'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.0.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Test,',
                                      style: TextStyle(
                                        color: kBackgroundColor,
                                        fontSize: 12.9.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.25.w,
                                    ),
                                    Text(
                                      '12',
                                      style: TextStyle(
                                        color: kBackgroundColor,
                                        fontSize: 12.9.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_city,
                                      color: kBackgroundColor,
                                      size: 18.75.sp,
                                    ),
                                    SizedBox(
                                      width: 2.25.w,
                                    ),
                                    Text(
                                      'Delta',
                                      style: TextStyle(
                                        color: kBackgroundColor,
                                        fontSize: 12.9.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.0.h,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 1.0.w,
                                        right: 1.0.w,
                                        bottom: 1.0.h),
                                    height: 2.0.h,
                                    child: Text(
                                        'I am so glad i am a part of the family of God, and be washed in the fountain, cleansed by His blood. Join hands with Jesus as we travel this far, i am soi',
                                        style: TextStyle(
                                          color: Colors.white,
                                          height: 0.25.h,
                                          fontSize: 10.sp,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(height: 2.0.h),
                    ProfileCard(
                        containerColor: Color(0xFFD70040).withOpacity(0.3),
                        text: 'Send a Message',
                        icon: Icons.message,
                        iconColor: Color(0xFFD70040),
                        press: () => Navigator.pop(context)),
                  ],
                ))),
          ),
        ],
      ),
    ])));
  }
}
