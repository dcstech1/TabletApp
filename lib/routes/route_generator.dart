import 'package:flutter/material.dart';
import 'package:tabletapp/presentation/screens/cart/cart.dart';
import 'package:tabletapp/presentation/screens/home/home.dart';
import 'package:tabletapp/presentation/screens/login/login.dart';
import 'package:tabletapp/presentation/screens/order_type/order_type.dart';
import 'package:tabletapp/presentation/screens/recall/recall.dart';
import 'package:tabletapp/routes/routes_enum.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var route = routeNames.entries
        .firstWhere((entry) => entry.value == settings.name,
            orElse: () => throw Exception("Invalid route: ${settings.name}"))
        .key;

    switch (route) {
      case Routes.root:
        return MaterialPageRoute(builder: (_) => login());
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => cart());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => home("route"));
      case Routes.orderType:
        return MaterialPageRoute(builder: (_) => order_type());
      case Routes.recall:
        return MaterialPageRoute(builder: (_) => recall());
      default:
        return MaterialPageRoute(builder: (_) => login());
    }
  }
}
