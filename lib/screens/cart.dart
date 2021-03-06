import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/services/PaymentsService.dart';
import 'package:grocery_bullet/services/StorageService.dart';
import 'package:grocery_bullet/widgets/BuyButton.dart';
import 'package:grocery_bullet/widgets/CartContents.dart';
import 'package:grocery_bullet/widgets/CartTotal.dart';
import 'package:grocery_bullet/widgets/CurrentLocationBuilder.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  CartModel _cartModel;
  int unitNumber;
  Location currentLocation;
  User user;

  @override
  Widget build(BuildContext context) {
    _cartModel = Provider.of(context);
    user = Provider.of<User>(context);
    return CurrentLocationBuilder(
      asyncWidgetBuilder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: kPrimaryColor,
          );
        }
        currentLocation = snapshot.data;
        return Container(
          color: kPrimaryColor,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: CartContents(),
                ),
              ),
              Divider(height: 10, color: kDividerColor),
              CartTotal(),
              Container(
                width: 250,
                child: TextField(
                  style: TextStyle(color: kTextColor),
                  decoration: InputDecoration(
                    labelText: 'Enter your unit number',
                    labelStyle: TextStyle(color: kTextColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kDividerColor),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: kDividerColor),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly],
                  onSubmitted: (newUnitNumber) {
                    setState(() {
                      unitNumber = int.parse(newUnitNumber);
                    });
                  },
                ),
              ),
              BuyButton(
                  onPressed: _cartModel.isEmpty() || unitNumber == null
                      ? null
                      : () {
                          PaymentsService.executePaymentFlow(
                              _cardEntryComplete, () {});
                        }),
            ],
          ),
        );
      },
    );
  }

  void _cardEntryComplete() async {
    await StorageService.removeCartItemsFromLocationGrocery(
        _cartModel, currentLocation, user);
    await user.loadValue();
    _cartModel.resetCart();
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Your items are on the way!!')));
  }
}
