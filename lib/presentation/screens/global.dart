import 'package:tabletapp/data/models/walkin_model.dart';

import '../../data/models/home_model.dart';
import '../../data/models/clientdetail_model.dart';
import '../../data/models/recall_model.dart';
import '../../data/models/tablegroup_model.dart';
import '../../data/models/walkin_model.dart';


import '../../../data/models/variations_model.dart';

class GlobalDala
{

  static HomeModel? homeModel;
  static String baseUrl="";
  static WalkInModel? walkInModel;

  static ClientDetailModel? clientDetailModel;
  static TableGroupModel? tableGroupModel;

  static bool isEdite=false;
  static bool isRecall=false;
  static bool isOrderTypeEdit=false;
  static int editIndex=0;
  static int itemCount=0;

  static List<String> orderTypeArray = <String>[];
  static Map<String,dynamic> cartData ={};
  static Map<String,dynamic> cartPayNowDataList ={};



  static List<Map<String, dynamic>>? cartDataListHold = [];


  static List<Map<String, dynamic>> cartDataList = [];

/*
  static Map<int, List<Datum>> selectedItemsLevel = {};*/
  static List<List<Map<String, dynamic>>> selectedItemsLevelList = [];

  // Other global variables or methods can be added here...

  // For example, you might want to clear all data when needed
  static void clearAllData() {
    cartDataList.clear();
    selectedItemsLevelList.clear();
  }




  // default store


}
