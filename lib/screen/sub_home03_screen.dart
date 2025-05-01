import 'package:flutter/material.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/services/money_api.dart';
import 'package:money_tracking_app/widgets/custom_button.dart';
import 'package:money_tracking_app/widgets/custom_textformfield.dart';

class SubHome03Screen extends StatefulWidget {
  final int userId;
  final Function refreshData;
  const SubHome03Screen({
    required this.userId,
    required this.refreshData,
    super.key,
  });

  @override
  State<SubHome03Screen> createState() => _SubHome03ScreenState();
}

class _SubHome03ScreenState extends State<SubHome03Screen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController moneyDetailCtrl = TextEditingController();
  TextEditingController moneyExpenseCtrl = TextEditingController();
  TextEditingController moneyDateExpenseCtrl = TextEditingController();

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
                  'เงินออก',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'รายการเงินออก',
                  hintText: 'DETAIL',
                  controller: moneyDetailCtrl,
                  fieldKey: Key('detal'),
                  validateText: 'กรุณากรอกรายการเงินออก',
                ),
                CustomTextFormField(
                  labelText: 'จำนวนเงินออก',
                  hintText: '0.0',
                  controller: moneyExpenseCtrl,
                  fieldKey: Key('moneyIn'),
                  validateText: 'กรุณากรอกจำนวนเงินออก',
                ),
                CustomTextFormField(
                  labelText: 'วัน เดือน ปีที่เงินออก',
                  iconSuffix: Icons.calendar_month,
                  hintText: 'DATE EXPENSE',
                  controller: moneyDateExpenseCtrl,
                  fieldKey: Key('dateExpense'),
                  validateText: 'กรุณากรอกวัน เดือน ปีที่เงินออก',
                ),
                CustomButton(
                  text: 'บันทึกเงินออก',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Money moneyExpanse = Money(
                        moneyDetail: moneyDetailCtrl.text.trim(),
                        moneyInOut: double.parse(moneyExpenseCtrl.text.trim()),
                        moneyDate: moneyDateExpenseCtrl.text.trim(),
                        moneyType: 2,
                        userId: widget.userId,
                      );
                      if (await MoneyApi().inOutMoney(moneyExpanse)) {
                        showSnackBar(context, "บันทึกเงินออก", Colors.green);
                        moneyDetailCtrl.clear();
                        moneyExpenseCtrl.clear();
                        moneyDateExpenseCtrl.clear();
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
