import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/screens/PastPurchasesScreen.dart';
import 'package:grocery_bullet/screens/signin.dart';
import 'package:grocery_bullet/services/AuthService.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    var theme = Theme.of(context).textTheme.headline1;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(user.userName, style: theme),
        Text(user.email, style: theme),
        CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
          radius: 60,
          backgroundColor: Colors.transparent,
        ),
        RaisedButton(
          child: Text('Shop Past Purchases'),
          color: Colors.indigoAccent,
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PastPurchasesScreen()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.indigoAccent),
          ),
        ),
        RaisedButton(
          child: Text('Log out'),
          color: Colors.indigoAccent,
          onPressed: () async {
            await AuthService.signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignInPage()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.indigoAccent),
          ),
        )
      ],
    ));
  }
}
