enum ApiServices {
  getUser,
  installRepository,
  loginAccess,
  getOrderType,
  walkIn,
  variations, recall,recallDelivery,recallDeliveryPost, barTab,barTabEdit,pickupFromPhoneNo,searchFromPhoneNo,pickupFromJsonData,pickupFromJsonDataWithClientId, deliveryFromJsonDataWithClientId ,submitOrder,takeAway,
  tabelGroup,dineInTable,recallDineIn,voidOrder,deliveryCharge,testConnection,payment

  // Add more API services here...
}

extension ApiServiceExtension on ApiServices {
  String get endPoint {
    switch (this) {
      case ApiServices.loginAccess:
        return '/User?accesscode=\$accesscode';
      case ApiServices.pickupFromPhoneNo:
        return '/Customer?phoneNo=\$phoneNo';
        //return '/Customer/byphone?phoneNo=\$phoneNo';
      case ApiServices.searchFromPhoneNo:
        //return '/Customer?phoneNo=\$phoneNo';
        return '/Customer/byphone?phoneNo=\$phoneNo';
      case ApiServices.deliveryCharge:
        return '/order?address=\$address';
      case ApiServices.pickupFromJsonData:
        return '/Customer';
      case ApiServices.testConnection:
        return '/company/testconnection';
      case ApiServices.takeAway:
        return '/Customer/ById?id=1';
      case ApiServices.pickupFromJsonDataWithClientId:
        return '/Customer/UpdateCustomer?id=\$clientId&orderType=pickup';
      case ApiServices.deliveryFromJsonDataWithClientId:
        return '/Customer/UpdateCustomer?id=\$clientId&orderType=delivery';
      case ApiServices.walkIn:
        return '/Product/\$p/WalkIn';
      case ApiServices.variations:
        return '/Variations/\$id';
      case ApiServices.getOrderType:
        return '/ProductCategory/test';
      case ApiServices.getUser:
        return '/user';
      case ApiServices.submitOrder:
        return '/TableOrder';
      case ApiServices.barTabEdit:
        return '/TableOrder/BarTabOrder';
      case ApiServices.voidOrder:
        return '/TableOrder/void';
      case ApiServices.payment:
        return '/PaymentSimulation/updatePayment';
      case ApiServices.dineInTable:
        return '/Table/\$id';
      case ApiServices.tabelGroup:
        return '/TableGroup';
      case ApiServices.recall:
        return '/TableOrder?userId=\$userId';
      case ApiServices.recallDelivery:
        return '/RecallDelivery/\$userId';
      case ApiServices.recallDeliveryPost:
        return '/RecallDelivery';
      case ApiServices.barTab:
        return '/TableOrder/GetBartabOrder?userId=\$userId';
      case ApiServices.recallDineIn:
        return '/TableOrder/GetOrderById?orderid=\$orderId';
      case ApiServices.installRepository:
        return '/servers/\$serverId/sites/\$siteId/git';

      default:
        return '';
    }
  }

  String get method {
    switch (this) {
      case ApiServices.loginAccess:
        return 'GET';
      case ApiServices.walkIn:
        return 'GET';
      case ApiServices.getOrderType:
        return 'GET';
      case ApiServices.getUser:
        return 'GET';
      case ApiServices.variations:
        return 'GET';
      case ApiServices.recall:
        return 'GET';
      case ApiServices.recallDelivery:
        return 'GET';
      case ApiServices.recallDeliveryPost:
        return 'POST';
      case ApiServices.barTab:
        return 'GET';
      case ApiServices.recallDineIn:
        return 'GET';
      case ApiServices.pickupFromPhoneNo:
        return 'GET';
      case ApiServices.searchFromPhoneNo:
        return 'GET';
      case ApiServices.deliveryCharge:
        return 'GET';
      case ApiServices.testConnection:
        return 'GET';
      case ApiServices.takeAway:
        return 'GET';
      case ApiServices.pickupFromJsonData:
        return 'POST';
      case ApiServices.submitOrder:
        return 'POST';
      case ApiServices.barTabEdit:
        return 'POST';
      case ApiServices.voidOrder:
        return 'POST';
      case ApiServices.payment:
        return 'POST';
      case ApiServices.tabelGroup:
        return 'GET';
      case ApiServices.dineInTable:
        return 'GET';
      case ApiServices.pickupFromJsonDataWithClientId:
        return 'POST';
      case ApiServices.deliveryFromJsonDataWithClientId:
        return 'POST';
      case ApiServices.installRepository:
        return 'POST';
    }
  }

  bool get shouldInterpolate {
    switch (this) {
      case ApiServices.installRepository:
        return true;
      case ApiServices.loginAccess:
        return true;

      case ApiServices.walkIn:
        return true;
      case ApiServices.dineInTable:
        return true;
      case ApiServices.variations:
        return true;
      case ApiServices.recall:
        return true;
      case ApiServices.barTab:
        return true;
      case ApiServices.recallDineIn:
        return true;
      case ApiServices.pickupFromPhoneNo:
        return true;
      case ApiServices.searchFromPhoneNo:
        return true;
      case ApiServices.deliveryCharge:
        return true;
      case ApiServices.pickupFromJsonDataWithClientId:
        return true;
      case ApiServices.deliveryFromJsonDataWithClientId:
        return true;
      case ApiServices.recallDelivery:
        return true;

      default:
        return false;
    }
  }
}
