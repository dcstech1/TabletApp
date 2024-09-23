import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/Repository/HomeModuleRepository.dart';
import '../../../data/models/dineintable_model.dart';
import '../../../data/models/tablegroup_model.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../global.dart';
import '../home/home.dart';
import '../recall/dinein_recall.dart';

class DineInListScreen extends StatefulWidget {
  final List<TableGroupModel> tableGroupModelList;

  DineInListScreen(this.tableGroupModelList);

  @override
  State<DineInListScreen> createState() => _DineInState();
}

class _DineInState extends State<DineInListScreen> {
  final List<Tab> _tabs = <Tab>[];

  List<Tab> getTabs() {
    _tabs.clear();
    for (int i = 0; i < widget.tableGroupModelList.length; i++) {
      _tabs.add(Tab(
        text: "   ${widget.tableGroupModelList[i].name}   ",
      ));
    }
    return _tabs;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tableGroupModelList.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tablet App'),
          centerTitle: true,
          backgroundColor: AppColors.appColor,
          foregroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            tabs: getTabs(),
            labelColor: Colors.red,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicator: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        body: TabBarView(
          children: List.generate(
            widget.tableGroupModelList.length,
                (index) => ApiDisplayWidget(index),
          ),
        ),
      ),
    );
  }
}

class ApiDisplayWidget extends StatefulWidget {
  final int pos;

  ApiDisplayWidget(this.pos);

  @override
  _ApiDisplayWidgetState createState() => _ApiDisplayWidgetState();
}

class _ApiDisplayWidgetState extends State<ApiDisplayWidget> {
  late List<DineInTableModel> dineinTableModelList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DineInTableModel>>(
      future: HomeRepository().getDineInTableList(pos: (widget.pos + 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          dineinTableModelList = snapshot.data!;
          return MyHomePage(
            tableData: dineinTableModelList,
          );
        }
      },
    );
  }
}
/*

class MyHomePage extends StatelessWidget {
  final List<DineInTableModel> tableData;

  MyHomePage({
    required this.tableData,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tableData.length,
      itemBuilder: (BuildContext context, int index) {
        final table = tableData[index];
        return GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            List<String>? cartDataList = [];
            prefs.setStringList('cartDataList', cartDataList);
            GlobalDala.itemCount = cartDataList.length;
            if (table.tableOrdersInfo != null &&
                table.tableOrdersInfo!.isNotEmpty &&
                !GlobalDala.isOrderTypeEdit) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DineInRacall(table)),
              );
            } else {
              int guestNumber = 0; // Default value
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  guestNumber = int.tryParse(value) ?? 0;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Number of Guests',
                                errorText: guestNumber > table.seatsNumber
                                    ? 'Maximum guest allowed is: ${table.seatsNumber}'
                                    : null,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                if (guestNumber <= table.seatsNumber && guestNumber > 0) {
                                  GlobalDala.cartPayNowDataList[Constant.tableIdMain] = table.id;
                                  GlobalDala.cartPayNowDataList[Constant.tableNameMain] = table.name;
                                  GlobalDala.cartPayNowDataList[Constant.guestNoMain] = guestNumber;
                                  GlobalDala.cartPayNowDataList[Constant.tableInfoMain] = table.tableDescription;
                                  if (!GlobalDala.isOrderTypeEdit) {


                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                home("dineIn")));
                                  } else {
                                    Navigator.pop(
                                        context, "Task completed!");
                                  }
                                } else {
                                  showSnackBarInDialog(
                                      context, "Enter valid guest number.!");
                                }
                              },
                              child: Text('Done'),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
          child: buildTableCard(table),
        );
      },
    );
  }

  Widget buildTableCard(DineInTableModel table) {
    Color backgroundColor = table.bgColor != null && table.bgColor!.isNotEmpty
        ? Color(int.parse(table.bgColor!))
        : Colors.white;
    Color fontColor = table.fontColor!.isNotEmpty
        ? Color(int.parse(table.fontColor!))
        : Colors.black;

    return SingleChildScrollView(
      child: Card(
        color: backgroundColor,
        child: SizedBox(// Adjusted width to account for padding
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ensure the column size is small
              children: [
                Text(
                  '${table.name}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                  ),
                ),
                SizedBox(height: 4.0), // Reduced height for better spacing
                Text('Guests: ${table.seatsNumber}',
                    style: TextStyle(color: fontColor)),
                if (table.tableOrdersInfo != null &&
                    table.tableOrdersInfo!.isNotEmpty)
                  ...[
                    SizedBox(height: 4.0),
                    Text('Orders:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: fontColor)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var order in table.tableOrdersInfo!)
                          Text(
                            '${order.orderNo} - ${order.userName}',
                            style: TextStyle(
                              color: fontColor,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/

class MyHomePage extends StatelessWidget {
  final List<DineInTableModel> tableData;

  MyHomePage({
    required this.tableData,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 records in a row
        crossAxisSpacing: 8.0, // Horizontal spacing between items
        mainAxisSpacing: 8.0, // Vertical spacing between items
        childAspectRatio: 2, // Aspect ratio of each item (width / height)
      ),
      padding: const EdgeInsets.all(8.0), // Padding around the grid
      itemCount: tableData.length,
      itemBuilder: (BuildContext context, int index) {
        final table = tableData[index];
        return GestureDetector(
          onTap: () {
            if (table.tableOrdersInfo != null &&
                table.tableOrdersInfo!.isNotEmpty &&
                !GlobalDala.isOrderTypeEdit) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DineInRacall(table)),
              );
            } else {
              int guestNumber = 0; // Default value
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  guestNumber = int.tryParse(value) ?? 0;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Number of Guests',
                                errorText: guestNumber > table.seatsNumber
                                    ? 'Maximum guest allowed is: ${table.seatsNumber}'
                                    : null,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                if (guestNumber <= table.seatsNumber &&
                                    guestNumber > 0) {
                                  GlobalDala.cartPayNowDataList[
                                  Constant.tableIdMain] = table.id;
                                  GlobalDala.cartPayNowDataList[
                                  Constant.tableNameMain] = table.name;
                                  GlobalDala.cartPayNowDataList[
                                  Constant.guestNoMain] = guestNumber;
                                  GlobalDala.cartPayNowDataList[
                                  Constant.tableInfoMain] =
                                      table.tableDescription;
                                  if (!GlobalDala.isOrderTypeEdit) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => home("dineIn")));
                                  } else {
                                    Navigator.pop(context, "Task completed!");
                                  }
                                } else {
                                  showSnackBarInDialog(
                                      context, "Enter valid guest number.!");
                                }
                              },
                              child: Text('Done'),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
          child: buildTableCard(table),
        );
      },
    );
  }

  Widget buildTableCard(DineInTableModel table) {
    Color backgroundColor = table.bgColor != null && table.bgColor!.isNotEmpty
        ? Color(int.parse(table.bgColor!))
        : Colors.white;
    Color fontColor = table.fontColor!.isNotEmpty
        ? Color(int.parse(table.fontColor!))
        : Colors.black;

    return Card(
      color: backgroundColor,
      child: SizedBox(
        height: 150.0, // Fixed height for each item
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${table.name}',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: fontColor,
                ),
              ),
              SizedBox(height: 4.0),
              Text('Guests: ${table.seatsNumber}',
                  style: TextStyle(color: fontColor)),
              if (table.tableOrdersInfo != null && table.tableOrdersInfo!.isNotEmpty)
                ...[
                  SizedBox(height: 4.0),
                  Text('Orders:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: fontColor)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var order in table.tableOrdersInfo!)
                        Text(
                          '${order.orderNo} - ${order.userName}',
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
