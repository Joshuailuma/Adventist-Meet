import 'package:adventist_meet/chat_screens/sign_in_screen.dart';
import 'package:adventist_meet/components/constants.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:flutter/material.dart';

class UsernameScreen extends StatefulWidget {
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  // TextEditingController controller = TextEditingController();

  String username = '';

  submit() async {
    _formKey.currentState!.save();
    if (username.trim().length > 2) {
      String? sharedPreferenceUserId = await MySharedPreferences().getId();

      usersRef.doc(sharedPreferenceUserId).update({
        "username": username,
      });

      MySharedPreferences.setUsername(username);

      Navigator.pushNamed(context, '/ChatHomeScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/HomeScreen'));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text('Write your username'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 20,
                      color: kPrimaryColor.withOpacity(0.5),
                    )
                  ],
                ),
                child: TextFormField(
                  onSaved: (value) {
                    username = value!;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().length < 5) {
                      return 'Name must be longer than 5 letters. You can use spaces';
                    } else if (value.length > 15) {
                      return 'Username too long';
                    }

                    return null; //else return null
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Please type in your real name',
                    hintStyle: TextStyle(
                      color: Colors.blue.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              submit();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color(0xFFB93B8F),
                  Color(0xFFE3319D),
                  Color(0xFFFF00FF),
                ]),
              ),
              child: Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
