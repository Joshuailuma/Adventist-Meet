import 'package:adventist_meet/components/constants.dart';
import 'package:adventist_meet/components/storage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> getHymns() {
    replaceTitle();
    return Storage().hymnTitle;
  }

  void replaceTitle() => Storage().hymnNo.replaceRange(0, 4,
      Storage().hymnTitle); // Update that range(0-4) with a new list(hymntitle)

  List<String> filteredHymns = []; //Create a new list of filtererd hymns

//This helps us to access the text field
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getHymns();
    super.initState();
  }

  void filterText(String query) {
    //A method that add hymns to the new filter list
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
        filteredHymns
            .addAll(newList); //New list of filtered hymns will be displayed
      });
      return;
    } else {
      setState(() {
        filteredHymns.clear();
        filteredHymns.addAll(_getHymns); //All hymns will be displayed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Search for something'),
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
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    filterText(value);
                  },
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.red.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    suffixIcon: Icon(Icons.star),
                    hintText: 'Type a hymn title',
                    hintStyle: TextStyle(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  controller: searchController,
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
                                ), // Finds the element present in the hymnTitle(a list) at the index of the element present at filtered hymns. We're trying to compare the two lists
                          );
                        } else
                          Navigator.pop(context, index);
                      },
                      child: Container(
                        height: 7.0.h,
                        child: Card(
                          elevation: 10,
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.5.w, vertical: 1.0.h),
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
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
