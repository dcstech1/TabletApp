
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabletapp/data/models/dineintable_model.dart';
import 'package:tabletapp/data/models/tablegroup_model.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/Repository/HomeModuleRepository.dart';
import '../../../utils/constant.dart';
import '../../Widgets/dialog_helper.dart';
import '../global.dart';
import '../home/home.dart';
import '../recall/dinein_recall.dart';

class dine_in extends StatefulWidget {
  List<TableGroupModel> tableGroupModelList;

  dine_in(this.tableGroupModelList);

  @override
  State<dine_in> createState() => _dineinState();
}

class _dineinState extends State<dine_in> {
  final List<Tab> _tabs = <Tab>[];

  List<Tab> getTabs() {
    _tabs.clear();
    for (int i = 0; i < widget.tableGroupModelList.length; i++) {
      _tabs.add(Tab(
        text:
        "   ${widget.tableGroupModelList[i].name}   ",
      ));
    }
    return _tabs;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tableGroupModelList.length ?? 0,
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
            tabAlignment: TabAlignment.center,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicator: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        body: TabBarView(
          children: List.generate(
            widget.tableGroupModelList.length ?? 0,
                (index) => ApiDisplayWidget(index),
          ),
        ),
      ),

    );
  }
}
class ApiDisplayWidget extends StatefulWidget {
  int pos = 1;

  ApiDisplayWidget(int this.pos);

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
          ); // or a loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          dineinTableModelList = snapshot.data!;
          return

            MyHomePage( tableData: dineinTableModelList, cardWidth: MediaQuery.of(context).size.width * 0.125, // Adjust the width of each card
              cardHeight: MediaQuery.of(context).size.width * 0.15,);

        }
      },
    );
  }
}
class MyHomePage extends StatelessWidget {
  final List<DineInTableModel> tableData;
  final double cardWidth;
  final double cardHeight;

  MyHomePage({
    required this.tableData,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    int maxRow = 0;
    int maxColumn = 0;

    for (final table in tableData) {
      if (table.row > maxRow) {
        maxRow = table.row;
      }
      if (table.column > maxColumn) {
        maxColumn = table.column;
      }
    }

    List<List<DineInTableModel?>> grid = List.generate(
      maxRow + 1,
          (_) => List<DineInTableModel?>.filled(maxColumn + 1, null),
    );

    for (final table in tableData) {
      grid[table.row][table.column] = table;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: (maxColumn + 1) * cardWidth,
          child: GridView.builder(
            shrinkWrap: true, // Important for proper vertical scrolling
            physics: NeverScrollableScrollPhysics(), // Disable internal scroll
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maxColumn + 1,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
              childAspectRatio: cardWidth / cardHeight, // Ensures correct aspect ratio
            ),
            itemCount: (maxRow + 1) * (maxColumn + 1),
            itemBuilder: (BuildContext context, int index) {
              final row = index ~/ (maxColumn + 1);
              final column = index % (maxColumn + 1);

              final table = grid[row][column];
              return table != null
                  ? GestureDetector(
                onTap: () {
                  if (table.tableOrdersInfo != null &&
                      table.tableOrdersInfo!.isNotEmpty &&
                      !GlobalDala.isOrderTypeEdit) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DineInRacall(table)));
                  } else {
                    int guestNumber = 0;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: StatefulBuilder(
                            builder: (BuildContext context,
                                StateSetter setState) {
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
                                        GlobalDala.cartPayNowDataList[Constant.tableIdMain] = table.id;
                                        GlobalDala.cartPayNowDataList[Constant.tableNameMain] = table.name;
                                        GlobalDala.cartPayNowDataList[Constant.guestNoMain] = guestNumber;
                                        GlobalDala.cartPayNowDataList[Constant.tableInfoMain] = table.tableDescription;
                                        if (!GlobalDala.isOrderTypeEdit) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => home("dineIn")));
                                        } else {
                                          Navigator.pop(context, "Task completed!");
                                        }
                                      } else {
                                        showSnackBarInDialog(context, "Enter valid guest number.");
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
                child: SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: buildTableCard(table),
                ),
              )
                  : SizedBox();
            },
          ),
        ),
      ),
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
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(   child: Text(
              '${table.name}',
              style: TextStyle(
                fontSize: 9.0,
                fontWeight: FontWeight.bold,
                color: fontColor,
              ),
            ))
         ,
            SizedBox(height: 2.0),
            table.tableOrdersInfo!.isEmpty ? Text('G: ${table.seatsNumber}', style: TextStyle(color: fontColor, fontSize: 9),textAlign:TextAlign.center ,):SizedBox(),
            if (table.tableOrdersInfo != null && table.tableOrdersInfo!.isNotEmpty)
              ...[
                SizedBox(height: 2.0),
               // Text('Orders:', style: TextStyle(fontWeight: FontWeight.bold, color: fontColor)),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: table.tableOrdersInfo!.length,
                    itemBuilder: (context, index) {
                      var order = table.tableOrdersInfo![index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child:
                        Text(
                          '${order.userName}:[${order.guests.toString()}]:${getOrderTimeDifference('${order.onDate} ${order.onTime}')}',
                          style: TextStyle(color: fontColor, fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),
              ],

          ],
        ),
      ),
    );
  }
  String getOrderTimeDifference(String dateTimeString) {

    DateFormat format = DateFormat('dd/MM/yyyy HH:mm:ss');
    DateTime orderDateTime = format.parse(dateTimeString);
    Duration difference = DateTime.now().difference(orderDateTime);
    String differenceString;
    if (difference.inDays > 0) {
      differenceString = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      differenceString = '${difference.inHours} hours ago';
    } else {
      differenceString = '${difference.inMinutes} minutes ago';
    }

    return differenceString;
  }
}
