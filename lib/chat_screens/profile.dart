import 'package:adventist_meet/chat_screens/edit_profile.dart';
import 'package:adventist_meet/components/constants.dart';
import 'package:adventist_meet/components/profile_cards.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:adventist_meet/components/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? photoUrlFromSP;
  String? usernameFromSP;
  String? ageFromSP;
  String? locationFromSP;
  String? bioFromSP;
  bool checkBox1 = false;
  bool checkBox2 = false;
  bool checkBox3 = false;

  @override
  void initState() {
    waitForSPDetails();

    super.initState();
  }

  waitForSPDetails() async {
    await getDetailsFromSP();
    setState(() {});
  }

  getDetailsFromSP() async {
    photoUrlFromSP = await MySharedPreferences().getPhotoUrl();
    usernameFromSP = await MySharedPreferences().getUsername();
    ageFromSP = await MySharedPreferences().getAge();
    locationFromSP = await MySharedPreferences().getLocation();
    bioFromSP = await MySharedPreferences().getBio();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    bool lightM =
        MediaQuery.of(context).platformBrightness == Brightness.light &&
            provider.isLightMode == true;

    return Scaffold(
      body: Stack(
        children: [
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
                              '${photoUrlFromSP}',
                              errorListener: () {
                                Icon(Icons.error);
                              },
                              maxWidth:
                                  MediaQuery.of(context).size.width.toInt(),
                              maxHeight:
                                  MediaQuery.of(context).size.width.toInt(),
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
                        padding: EdgeInsets.only(left: 4.5.w, right: 4.5.w),
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
                                alignment: Alignment.centerLeft,
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
                              alignment: Alignment.topLeft,
                              child: Text(
                                'My Profile',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.8,
                                  fontSize: 15.9.sp,
                                  color: kBackgroundColor,
                                ),
                              ),
                            ),
                            Expanded(
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
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/ProfilePicture');
                                              },
                                              child: Container(
                                                child: CircleAvatar(
                                                  radius: 6.0.h,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          '${photoUrlFromSP}'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.0.h),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfile()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${usernameFromSP},',
                                          style: TextStyle(
                                            color: kBackgroundColor,
                                            fontSize: 12.9.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.25.w,
                                        ),
                                        Text(
                                          ageFromSP == null
                                              ? ''
                                              : '${ageFromSP}',
                                          style: TextStyle(
                                            color: kBackgroundColor,
                                            fontSize: 12.9.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfile()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          locationFromSP == null
                                              ? ''
                                              : '${locationFromSP}',
                                          style: TextStyle(
                                            color: kBackgroundColor,
                                            fontSize: 12.9.sp,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                          bioFromSP == null
                                              ? ''
                                              : '${bioFromSP}',
                                          style: TextStyle(
                                            height: 0.25.h,
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                          )),
                                    ),
                                  ),
                                ],
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
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 2.0.h),
                        ProfileCard(
                            containerColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.light
                                    ? Color(0xFFD70040).withOpacity(0.3)
                                    : Colors.black.withOpacity(0.3),
                            text: 'Edit Profile',
                            icon: Icons.person,
                            iconColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.light
                                    ? Color(0xFFD70040)
                                    : Colors.black,
                            press: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()))),
                        ProfileCard(
                          containerColor:
                              MediaQuery.of(context).platformBrightness ==
                                      Brightness.light
                                  ? Color(0xFF5D3FD3).withOpacity(0.3)
                                  : Colors.black.withOpacity(0.3),
                          text: 'Create Section',
                          icon: Icons.add_business,
                          iconColor:
                              MediaQuery.of(context).platformBrightness ==
                                      Brightness.light
                                  ? Color(0xFF5D3FD3)
                                  : Colors.black,
                          press: () {
                            //Create a section
                          },
                        ),
                        ProfileCard(
                          containerColor:
                              MediaQuery.of(context).platformBrightness ==
                                      Brightness.light
                                  ? Color(0xFFFF7F50).withOpacity(0.3)
                                  : Colors.black.withOpacity(0.3),
                          text: 'Change Theme',
                          icon: Icons.color_lens,
                          iconColor:
                              MediaQuery.of(context).platformBrightness ==
                                      Brightness.light
                                  ? Color(0xFFFF7F50)
                                  : Colors.black,
                          press: () {
                            final provider = Provider.of<ThemeProvider>(context,
                                listen: false);
                            showDialog(
                                context: context,
                                builder: (_) {
                                  print(provider.isSystemMode);
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                    return SimpleDialog(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, bottom: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      title: Text('Change Theme'),
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                                value:
                                                    themeProvider.isSystemMode,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    provider.toogleSystemTheme(
                                                        value!);
                                                  });
                                                }),
                                            Text(
                                              'System Default',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(children: [
                                          Checkbox(
                                              value: themeProvider.isLightMode,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  provider
                                                      .toogleLightTheme(value!);
                                                });
                                              }),
                                          Text(
                                            'light',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ]),
                                        Row(children: [
                                          Checkbox(
                                              value: themeProvider.isDarkMode,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  provider
                                                      .toogleDarkTheme(value!);
                                                });
                                              }),
                                          Text(
                                            'Dark',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ]),
                                      ],
                                    );
                                  });
                                });
                          },
                        ),
                        Divider(),
                        ProfileCard(
                          containerColor: Colors.black.withOpacity(0.3),
                          text: 'Privacy Policy',
                          icon: Icons.security,
                          iconColor: Colors.black,
                          press: () {
                            //Go to privacy policy site
                          },
                        ),
                        ProfileCard(
                            containerColor: Colors.black.withOpacity(0.3),
                            text: 'Log out',
                            icon: Icons.logout,
                            iconColor: Colors.black,
                            press: () => Navigator.popUntil(
                                context, ModalRoute.withName('/HomeScreen'))),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
