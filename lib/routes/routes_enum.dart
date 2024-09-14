enum Routes {
  login,
  home,
  dashboard,
  cart,
  debugMenu, root,orderType,recall;
}

final Map<Routes, String> routeNames = {
  Routes.login: '/login',
  Routes.dashboard: '/dashboard',
  Routes.home: '/home',
  Routes.debugMenu: '/debugMenu',
  Routes.cart: '/cart',
  Routes.recall: '/recall',
  Routes.orderType: '/orderType'
};
