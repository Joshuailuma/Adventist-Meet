import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Section extends StatelessWidget {
  final void Function()? press;
  final Text? text1;
  final Text? text2;
  final Widget? image;
  final Color? containerColor;

  const Section({
    @required this.press,
    @required this.text1,
    this.image,
    this.containerColor,
    @required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.375.w, vertical: 1.0.h),
      child: InkWell(
        onTap: press,
        child: Container(
          padding: EdgeInsets.all(15),
          color: Theme.of(context).errorColor,
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 5.8.h,
                    width: 12.5.w,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1.8.w, top: 0.8.h),
                    child: Container(height: 4.0.h, width: 8.5.w, child: image),
                  ),
                ],
              ),
              SizedBox(
                width: 4.3.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text1!,
                  text2!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
