import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletapp/data/Repository/HomeModuleRepository.dart';
import 'package:tabletapp/data/models/variation_model.dart';
import 'package:tabletapp/data/models/variations_model.dart';
import 'package:tabletapp/presentation/screens/cart/cart.dart';
import 'package:tabletapp/presentation/screens/login/login.dart';
import 'package:tabletapp/presentation/screens/order_type/order_type.dart';
import 'package:tabletapp/utils/constant.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/home_model.dart';
import '../../../data/models/walkin_model.dart';
import '../../Widgets/material_textform_field.dart';
import '../global.dart';
import '../orderflow/qty_screen.dart';
import '../orderflow/variation_screen.dart';

class home extends StatefulWidget {
   String fromScreen ="";

  home(this.fromScreen);
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with WidgetsBindingObserver {
  int? length = GlobalDala.homeModel?.categories?.length;
  final List<Tab> _tabs = <Tab>[];

  List<Tab> getTabs() {
    _tabs.clear();
    for (int i = 0; i < length!; i++) {
      _tabs.add(Tab(
        text:
            "   ${GlobalDala.homeModel?.categories?[i].categoryDescription}   ",
      ));
    }
    return _tabs;
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('App is dispose');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    print('AdidChangeAppLifecycleState');
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Handle resume
      print('App is resumed');
    } else if (state == AppLifecycleState.paused) {
      // Handle pause
      print('App is paused');
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:() async {
      // Do something here
      Navigator.of(context).pop(true);
      if(GlobalDala.isRecall)
      {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => cart()),
        );
      }
      else if( GlobalDala.cartPayNowDataList[Constant.orderTypeMain]=="DriveThru" || GlobalDala.cartPayNowDataList[Constant.orderTypeMain]=="TO GO" ||GlobalDala.cartPayNowDataList[Constant.orderTypeMain]=="TO STAY")
        {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => order_type()),
          );
        }

      return true;
    },
    child:   DefaultTabController(
      length: GlobalDala.homeModel?.categories?.length ?? 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tablet App'),
          centerTitle: true,
          backgroundColor: AppColors.appColor,
          foregroundColor: Colors.white,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, size: 20),
                  onPressed: () {


                    Navigator.of(context).pop(true);
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (context) => cart()),
                      );

                  },
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red, // Customize the background color
                      borderRadius: BorderRadius.circular(10), // Adjust as needed
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      GlobalDala.itemCount.toString(), // Replace this with the actual text value
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Adjust the font size as needed
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: getTabs(),
            labelColor: Colors.red,
            unselectedLabelColor: Colors.white70,
            tabAlignment: TabAlignment.center,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicator: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        body: TabBarView(
          children: List.generate(
            GlobalDala.homeModel?.categories?.length ?? 0,
                (index) => ApiDisplayWidget(GlobalDala.homeModel?.categories?[index].id),
          ),
        ),
      ),
    ),
    );
  }

  @override
  void initState() {
    super.initState();
   // GlobalDala.clearAllData();
    print('App is initstate');

    GlobalDala.isEdite=false;
    WidgetsBinding.instance.addObserver(this);
    defaultStorage();

  }

}
void defaultStorage() {

/*
  SharedPreferences prefs = await SharedPreferences.getInstance();


 itemCount= prefs.getStringList('cartDataList')?.length ?? 0;
 print('itemCount : $itemCount');*/

  GlobalDala.cartPayNowDataList[Constant.serviceChargePercentageMain] = GlobalDala.homeModel?.serviceChargeAmount;


  // product details

  GlobalDala.cartData[Constant.id] = 0;
  GlobalDala.cartData[Constant.printToKitchen1] = 0;
  GlobalDala.cartData[Constant.printToKitchen2] = 0;
  GlobalDala.cartData[Constant.printToKitchen3] = 0;
  GlobalDala.cartData[Constant.printToKitchen4] = 0;
  GlobalDala.cartData[Constant.printToKitchen5] = 0;
  GlobalDala.cartData[Constant.taxId4] = 0;
  GlobalDala.cartData[Constant.taxId5] = 0;
  GlobalDala.cartData[Constant.taxId6] = 0;
  GlobalDala.cartData[Constant.taxRate4] = 0;
  GlobalDala.cartData[Constant.taxRate5] = 0;
  GlobalDala.cartData[Constant.taxRate6] = 0;
  GlobalDala.cartData[Constant.taxPerUnit4] = 0;
  GlobalDala.cartData[Constant.taxPerUnit5] = 0;
  GlobalDala.cartData[Constant.taxPerUnit6] = 0;
  GlobalDala.cartData[Constant.totalTax4] = 0;
  GlobalDala.cartData[Constant.totalTax5] = 0;
  GlobalDala.cartData[Constant.totalTax6] = 0;
  GlobalDala.cartData[Constant.status] = "new";
  GlobalDala.cartData[Constant.note]="";


  GlobalDala.cartData[Constant.taxRate1] = 0;
  GlobalDala.cartData[Constant.taxRate2] = 0;
  GlobalDala.cartData[Constant.taxRate3] = 0;
  for (int i = 0; i < (GlobalDala.homeModel?.taxes?.length ?? 0); i++) {

    if(i==0)
      {
        GlobalDala.cartData[Constant.taxRate1] =  GlobalDala.homeModel?.taxes?[i].rate;
      }
    if(i==1)
      {
        GlobalDala.cartData[Constant.taxRate2] =  GlobalDala.homeModel?.taxes?[i].rate;
      }
    if(i==2)
      {
        GlobalDala.cartData[Constant.taxRate3] =  GlobalDala.homeModel?.taxes?[i].rate;
      }
  }


}
class ApiDisplayWidget extends StatefulWidget {
  int pos = 1;

  ApiDisplayWidget(int this.pos);

  @override
  _ApiDisplayWidgetState createState() => _ApiDisplayWidgetState();
}

class _ApiDisplayWidgetState extends State<ApiDisplayWidget> {
  late List<WalkInModel> walkInList = [];
  late List<VariationModel> variationList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WalkInModel>>(
      future: HomeRepository().getWalkInCategories(pos: (widget.pos)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          ); // or a loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          walkInList = snapshot.data!;
          return ListView.builder(
            itemCount: walkInList.length,
            itemBuilder: (context, index) {
              return Card(
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the radius as needed
                ),
                elevation: 2,
                child: ListTile(
                    title: Text("${walkInList[index].productName}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: walkInList[index].price != 0.0
                        ? Text("\$${walkInList[index].price}",
                            style: const TextStyle(fontSize: 12))
                        : null,
                    leading: CircleAvatar(
                      backgroundImage: walkInList[index].imageUrl != null
                          ? NetworkImage(walkInList[index].imageUrl!)
                          : null,
                    ),
                    textColor: AppColors.appColor,
                    onTap: () {

                      GlobalDala.cartData[Constant.productId]=walkInList[index].productId;
                      GlobalDala.cartData[Constant.productName]=walkInList[index].productName;
                      GlobalDala.cartData[Constant.actualPrice]=walkInList[index].price;
                      GlobalDala.cartData[Constant.fullDescription]=walkInList[index].productName.toString();

                      GlobalDala.cartData[Constant.taxId1]=walkInList[index].taxId1;
                      GlobalDala.cartData[Constant.taxId2]=walkInList[index].taxId2;
                      GlobalDala.cartData[Constant.taxId3]=walkInList[index].taxId3;


                      _handleItemClick(walkInList[index].productId,
                          walkInList[index], context);
                    }),
              );
            },
          );
        }
      },
    );
  }

  void _handleItemClick(
      int Id, WalkInModel walkInList, BuildContext context) async {

    try {
      List<VariationsModel> variationList =
          await HomeRepository().getVariation(id: Id);

      // Use the data as needed


      GlobalDala.cartData[Constant.variationsPrice]=0.0;
      GlobalDala.cartData[Constant.selectedItemsLevel]=null;
      if (variationList.isNotEmpty) {

        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => VariationsScreen(variationList)));
      } else {


        Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => qty_screen()));
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }
}
