import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:sizer/sizer.dart';

class HymnContainer extends StatelessWidget {
  //Constructor for the home screen

  HymnContainer(
      {required this.image1,
      required this.text,
      required this.image2,
      required this.height,
      required this.width,
      this.press});
  final String image1, text, image2;
  final double height, width;

  final void Function()? press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //To get size of screen
    return Expanded(
      child: InkWell(
        //To make wave on screen when pressed
        onTap: press,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          width: size.width,
          height: size.height / 4, //One fourth of height of screen
          decoration: BoxDecoration(
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Color(0XFF00933)
                : Color(0xFF51414F),
            borderRadius: BorderRadius.all(
              Radius.circular(kDefaultPadding),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 50,
                color: kPrimaryColor.withOpacity(0.5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 6.5.w, right: 4.5.w),
                  width: 16.5.w,
                  height: 12.0.h,
                  child: Image.asset(image1),
                ),
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.black
                        : Colors.white38),
              ),
              Expanded(
                child: Container(
                  height: height,
                  width: width,
                  child: Image.asset(image2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// padding: const EdgeInsets.only(top: kDefaultPadding+ 20, left: kDefaultPadding, right: kDefaultPadding -5),