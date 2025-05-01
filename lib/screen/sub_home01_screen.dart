import 'package:flutter/material.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/services/money_api.dart';
import 'package:money_tracking_app/widgets/custom_button.dart';
import 'package:money_tracking_app/widgets/custom_textformfield.dart';

class SubHome01Screen extends StatefulWidget {
  final int userId;
  final Function refreshData;
  const SubHome01Screen({
    required this.userId,
    required this.refreshData,
    super.key,
  });

  @override
  State<SubHome01Screen> createState() => _SubHome01ScreenState();
}

class _SubHome01ScreenState extends State<SubHome01Screen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController moneyDetailCtrl = TextEditingController();
  TextEditingController moneyIncomeCtrl = TextEditingController();
  TextEditingController moneyDateIncomeCtrl = TextEditingController();

  showSnackBar(context, message, color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'เงินเข้า',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'รายการเงินเข้า',
                  hintText: 'DETAIL',
                  controller: moneyDetailCtrl,
                  fieldKey: Key('detal'),
                  validateText: 'กรุณากรอกรายการเงินเข้า',
                ),
                CustomTextFormField(
                  labelText: 'จำนวนเงินเข้า',
                  hintText: '0.0',
                  controller: moneyIncomeCtrl,
                  fieldKey: Key('moneyIn'),
                  validateText: 'กรุณากรอกจำนวนเงินเข้า',
                ),
                CustomTextFormField(
                  labelText: 'วัน เดือน ปีที่เงินเข้า',
                  iconSuffix: Icons.calendar_month,
                  hintText: 'DATE INCOME',
                  controller: moneyDateIncomeCtrl,
                  fieldKey: Key('dateIncome'),
                  validateText: 'กรุณากรอกวัน เดือน ปีที่เงินเข้า',
                ),
                CustomButton(
                  text: 'บันทึกเงินเข้า',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Money moneyIncome = Money(
                        moneyDetail: moneyDetailCtrl.text.trim(),
                        moneyInOut: double.parse(moneyIncomeCtrl.text.trim()),
                        moneyDate: moneyDateIncomeCtrl.text.trim(),
                        moneyType: 1,
                        userId: widget.userId,
                      );
                      if (await MoneyApi().inOutMoney(moneyIncome)) {
                        showSnackBar(context, "บันทึกสําเร็จ", Colors.green);

                        moneyDetailCtrl.clear();
                        moneyIncomeCtrl.clear();
                        moneyDateIncomeCtrl.clear();
                        widget.refreshData();
                      } else {
                        showSnackBar(context, "บันทึกไม่สําเร็จ", Colors.red);
                      }
                    }
                  },
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
