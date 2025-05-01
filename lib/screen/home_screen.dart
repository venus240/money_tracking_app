import 'package:flutter/material.dart';
import 'package:money_tracking_app/constants/baseurl_constant.dart';
import 'package:money_tracking_app/constants/color_constant.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/screen/sub_home01_screen.dart';
import 'package:money_tracking_app/screen/sub_home02_screen.dart';
import 'package:money_tracking_app/screen/sub_home03_screen.dart';
import 'package:money_tracking_app/services/money_api.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  final String? userImage;
  final int? userId;

  const HomeScreen({super.key, this.userName, this.userImage, this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  late Future<List<Money>> moneyAllData;
  List showUI = [];
  Future<List<Money>> getMoneyByUserId() async {
    return await MoneyApi().getMoneyByUserId(widget.userId!);
  }

  void refreshData() {
    setState(() {
      moneyAllData = getMoneyByUserId(); // Trigger a refresh of the data
    });
  }

  @override
  void initState() {
    // moneyAllData = getMoneyByUserId();
    refreshData();
    showUI = [
      SubHome01Screen(userId: widget.userId!, refreshData: refreshData),
      SubHome02Screen(userId: widget.userId!),
      SubHome03Screen(userId: widget.userId!, refreshData: refreshData),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalMoney = 0.0;
    double totalIncome = 0.0;
    double totalExpanse = 0.0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              widget.userName.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          widget.userImage == null
              ? Image.asset(
                'assets/images/user_camera.png',
                width: 50,
                height: 50,
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  '$baseUrl/images/users/${widget.userImage}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
          SizedBox(width: 25),
        ],
        backgroundColor: Color(mainColor),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Color(mainColor)),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[350],
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_downward_outlined, size: 45),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 45),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_upward_outlined, size: 45),
              label: '',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            FutureBuilder(
              future: moneyAllData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  ); // แสดง loading
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  // ตัวแปรนี้จะทำการคำนวณยอดเงินคงเหลือ
                  snapshot.data!.forEach((x) {
                    if (x.moneyType == 1) {
                      totalMoney += x.moneyInOut!;
                      totalIncome += x.moneyInOut!;
                    } else {
                      totalExpanse += x.moneyInOut!;
                      totalMoney -= x.moneyInOut!;
                    }
                  });
                  return Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 25,
                    ),
                    decoration: BoxDecoration(
                      color: Color(mainColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "ยอดเงินคงเหลือ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "$totalMoney บาท",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_downward_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),

                                    Text(
                                      "ยอดเงินเข้าร่วม",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "$totalIncome บาท",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "ยอดเงินออกร่วม",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_upward_outlined,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Text(
                                  "$totalExpanse บาท",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return Center(child: Text('ไม่มีข้อมูล'));
              },
              // childre:
            ),
            Expanded(child: showUI[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}
