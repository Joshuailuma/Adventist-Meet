import 'package:adventist_meet/components/constants.dart';
import 'package:adventist_meet/components/storage.dart';
import 'package:adventist_meet/hymn_screens/dailPad_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:adventist_meet/hymn_screens/searchScreen.dart';
import 'package:sizer/sizer.dart';

class HymnScreen extends StatefulWidget {
  @override
  _HymnScreenState createState() => _HymnScreenState();
}

class _HymnScreenState extends State<HymnScreen> {
  int fileNumber = 1;
  int index = 1;

  @override
  void initState() {
    getHymns();
    super.initState();
  }

  List<String> getHymns() {
    return Storage().hymnNo;
  }

  ///To assign the number gotten from searchScreen and dailPasScreen to fileNo and index then update the screen with the new number
  updateHymn(int numberGotten) {
    if (numberGotten > 0) {
      setState(() {
        fileNumber = numberGotten;
        index = numberGotten;
        pageController.jumpToPage(numberGotten -
            1); //It wil go to the page of the no gotten from search
      });
    } else {
      pageController.jumpToPage(
          0); //When we click List 0 from search/dailpad screen we want SDAH1 (index + 1)to display
    }
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    String currentNumber = fileNumber.toString();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'SDAH $currentNumber',
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 0.5.h,
                  horizontal: 1.125.w,
                ),
                height: MediaQuery.of(context).size.height / 1.18,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  itemCount: getHymns().length -
                      1, //The last hymnn should not be displayed to prevent error
                  itemBuilder: (BuildContext context, int index) {
                    return displayMarkdown(
                      getFile(),
                    );
                  },
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      fileNumber = index + 1;
                      print(index);
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 5.0.h,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  //Search Icon
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          spreadRadius: -0.5,
                          offset: Offset(-5, -5),
                          blurRadius: 30,
                        ),
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.4),
                          spreadRadius: 2,
                          offset: Offset(7, 7),
                          blurRadius: 20,
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    height: 5.0.h,
                    width: 11.25.w,
                    child: InkWell(
                      onTap: () async {
                        final numberGotten = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchScreen())); //To get the text inputed...
                        // ...from searchScreen
                        updateHymn(numberGotten);
                      },
                      child: Icon(
                        Icons.search_rounded,
                        size: 25.sp,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 4.5.w, bottom: 1.5.h),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          spreadRadius: -0.5,
                          offset: Offset(-5, -5),
                          blurRadius: 30,
                        ),
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.4),
                          spreadRadius: 2,
                          offset: Offset(7, 7),
                          blurRadius: 20,
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    height: 5.0.h,
                    width: 11.25.w,
                    child: InkWell(
                      onTap: () async {
                        final numberGotten = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DailPad())); //To get the number inputed...
                        //...from dailpadScreen
                        updateHymn(numberGotten);
                      },
                      child: Icon(Icons.dialpad_rounded,
                          color: Colors.black, size: 25.sp),
                    ),
                    margin: EdgeInsets.only(right: 4.5.w, bottom: 1.5.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<String> displayMarkdown(String hymnNo) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString("assets/markdown/" + hymnNo),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Markdown(
            data: snapshot
                .data!, //To render the data exclamation mark (!) makes it nonNull
            styleSheet: MarkdownStyleSheet(
              h1: TextStyle(
                fontFamily: 'Castoro',
                fontWeight: FontWeight.bold,
                fontSize: 17.sp,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                      blurRadius: 8, color: Colors.green, offset: Offset(1, 4)),
                ],
              ),
              blockSpacing: 20,
              h2: TextStyle(
                color: Color(0xFF880E4F),
                fontSize: 15.3.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Castoro',
              ),
              p: TextStyle(
                height: 1.6,
                fontFamily: '2ndFont',
                fontWeight: FontWeight.w500,
                fontSize: 14.6.sp,
              ),
              strong: TextStyle(color: Colors.indigo, fontSize: 14.6.sp),
              h3: TextStyle(
                  fontFamily: 'Castora',
                  color: Colors.indigo,
                  fontSize: 14.6.sp),
              h3Align: WrapAlignment.center,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ),
        );
      },
    );
  }

  String getFile() {
    return getHymns()[fileNumber];
  }

  String setFile(String name) {
    getHymns()[fileNumber] = name;
    return getHymns()[fileNumber];
  }
}
