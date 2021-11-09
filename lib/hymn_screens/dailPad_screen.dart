import 'package:adventist_meet/components/storage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DailPad extends StatefulWidget {
  @override
  _DailPadState createState() => _DailPadState();
}

class _DailPadState extends State<DailPad> {
  List<String> getHymns() {
    replaceTitle();
    return Storage().hymnTitle;
  }

  List<String> filteredHymns = [];

  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    getHymns();
    super.initState();
  }

  void filterText(String query) {
    List<String> _getHymns = [];
    _getHymns.addAll(getHymns());

    if (query.isNotEmpty) {
      List<String> newList = [];
      _getHymns.forEach((hymn) {
        if (hymn.contains(query)) {
          newList.add(hymn);
        }
      });

      setState(() {
        filteredHymns.clear();
        filteredHymns.addAll(newList);
      });
      return;
    } else {
      setState(() {
        filteredHymns.clear();
        filteredHymns.addAll(_getHymns);
      });
    }
  }

  void replaceTitle() =>
      Storage().hymnNo.replaceRange(0, 4, Storage().hymnTitle);

  @override
  Widget build(BuildContext context) {
    bool isSearching = numberController.text.isNotEmpty;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Type a number'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 7.0.h,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(2.0.h),
                child: TextField(
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12.sp,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    filterText(value);
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.red.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.dialpad,
                    ),
                    suffixIcon: Icon(Icons.star),
                    hintText: 'Type a hymn number',
                    hintStyle: TextStyle(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  controller: numberController,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: isSearching == true
                        ? filteredHymns.length
                        : getHymns().length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          if (isSearching == true) {
                            Navigator.pop(
                              context,
                              Storage().hymnTitle.indexOf(
                                    filteredHymns.elementAt(index),
                                  ), // Finds the element present in the hymnTitle(a list) at the index of the element present at filtered hymns. We're trying to compare the two lists to return the title of filteredHymns (2nd list) at the index of the hymnNo (1st list)
                            );
                          } else
                            Navigator.pop(context, index);
                        },
                        child: Container(
                          height: 7.0.h,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 4.5.w, vertical: 1.0.h),
                            elevation: 10,
                            child: Container(
                              margin: EdgeInsets.only(left: 4.5.w, top: 1.3.h),
                              child: Text(
                                isSearching == true
                                    ? filteredHymns[index]
                                    : getHymns()[index],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
