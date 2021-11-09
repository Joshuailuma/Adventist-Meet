import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Color containerColor;
  final void Function() press;
  const ProfileCard(
      {required this.text,
      required this.icon,
      required this.iconColor,
      required this.containerColor,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.25.w, vertical: 0.5.h),
        child: Padding(
          padding: EdgeInsets.only(
              left: 4.5.w, top: 1.0.h, bottom: 1.0.h, right: 4.5.w),
          child: Row(
            children: [
              Container(
                height: 5.8.h,
                width: 12.3.w,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Icon(
                  icon,
                  size: 21.9.sp,
                  color: iconColor,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 11.4.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.8.sp,
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.red
                    : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
