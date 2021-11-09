import 'package:adventist_meet/components/constants.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:adventist_meet/components/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  final usersRef = FirebaseFirestore.instance.collection('users');
  final storageRef = FirebaseStorage.instance.ref();
  String? photoUrlFromSP;
  String? usernameFromSP;
  String? ageFromSP;
  String? locationFromSP;
  String? bioFromSP;
  String? idFromSP;

  @override
  void initState() {
    getDetailsFromSP();

    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   //To make controllers have a value
    //   // usernameController.text = provider.first.username;
    //   locationController.text = locationFromSP!;
    //   bioController.text = bioFromSP!;
    // });
  }

//Get details from shared preferences
  getDetailsFromSP() async {
    idFromSP = await MySharedPreferences().getId();
    photoUrlFromSP = await MySharedPreferences().getPhotoUrl();
    usernameFromSP = await MySharedPreferences().getUsername();
    ageFromSP = await MySharedPreferences().getAge();
    locationFromSP = await MySharedPreferences().getLocation();
    bioFromSP = await MySharedPreferences().getBio();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 4.5.w, top: 5.0.h, bottom: 7.0.h),
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 18.75.sp,
                  color:
                      ThemeProvider().isLightMode ? Colors.black : Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.5.w, bottom: 1.4.h),
              alignment: Alignment.topLeft,
              child: Text(
                'Edit your',
                style: TextStyle(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Theme.of(context).primaryColor.withRed(4)
                      : Colors.white,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.5.w, bottom: 4.0.h),
              alignment: Alignment.topLeft,
              child: Text(
                'Profile.',
                style: TextStyle(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Theme.of(context).primaryColor.withRed(4)
                      : Colors.white,
                  fontSize: 25.3.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ProfilePicture');
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 4.5.w),
                    alignment: Alignment(1, 1),
                    height: 7.0.h,
                    width: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider('${photoUrlFromSP}'),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.7.w,
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 2.0.h),
              padding:
                  EdgeInsets.only(left: 4.5.w, right: 4.5.w, bottom: 1.0.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.white
                    : Colors.blue,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 4),
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 12.6.sp,
                ),
                controller: usernameController,
                validator: (value) {
                  if (value!.trim().length < 3) {
                    return 'Username must be longer than 2 characters';
                  } else if (value.length > 12) {
                    return 'Username too long';
                  }
                  return null; //else return null
                },
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText:
                      usernameFromSP == null ? 'New username' : usernameFromSP,
                  hintStyle: TextStyle(
                    fontSize: 12.6.sp,
                  ),
                ),
                onFieldSubmitted: (String value) {
                  if (usernameController.text.trim().length > 2) {
                    setState(() {
                      usersRef.doc(idFromSP).update({
                        "username": value,
                      });
                      MySharedPreferences.setUsername(value);
                    });

                    final snackBar = SnackBar(
                      content: Text(
                        'Username updated😎',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.grey.withOpacity(1.0),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  ;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 2.0.h),
              padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 4),
                    color: Color(0xFF98FB98).withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextField(
                onSubmitted: (String value) {
                  if (value.length < 18) {
                    setState(() {
                      usersRef.doc(idFromSP).update({
                        "location": value,
                      });
                      MySharedPreferences.setLocation(value);
                    });

                    final snackBar = SnackBar(
                      content: Text(
                        'Location updated😎',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Color(0xFF009E60).withOpacity(1.0),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                      content: Text(
                        'Your Location details is too long',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 12.6.sp,
                ),
                controller: locationController,
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText:
                      locationFromSP == null ? 'Location' : locationFromSP,
                  hintStyle: TextStyle(
                    fontSize: 12.6.sp,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 2.0.h),
              padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 4),
                    color: Color(0xFFEC5800).withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (String value) {
                  if (bioController.text.trim().length < 355) {
                    setState(() {
                      usersRef.doc(idFromSP).update({
                        "bio": value,
                      });
                      MySharedPreferences.setBio(value);
                    });

                    final snackBar = SnackBar(
                      content: Text(
                        'Bio updated😎',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Color(0xFFEC5800).withOpacity(0.7),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                      content: Text(
                        'Your Bio is too long',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 12.6.sp,
                ),
                controller: bioController,
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: bioFromSP == null
                      ? 'Say something to the public'
                      : bioFromSP,
                  hintStyle: TextStyle(
                    fontSize: 12.6.sp,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 2.0.h),
              padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 4),
                    color: Color(0xFFFF00FF).withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                onSubmitted: (String value) {
                  if (ageController.text.trim().length < 3) {
                    setState(() {
                      usersRef.doc(idFromSP).update({
                        "age": value,
                      });
                      MySharedPreferences.setAge(value);
                    });

                    final snackBar = SnackBar(
                      content: Text(
                        'Age updated😎',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Color(0xFFFF00FF).withOpacity(0.7),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                      content: Text(
                        'Age should not be more than 2 digits',
                        textAlign: TextAlign.center,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 12.6.sp,
                ),
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: ageFromSP == null ? 'Age' : ageFromSP,
                  hintStyle: TextStyle(
                    fontSize: 12.6.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
