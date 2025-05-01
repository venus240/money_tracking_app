import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_tracking_app/constants/color_constant.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/user_api.dart';
import 'package:money_tracking_app/widgets/custom_button.dart';
import 'package:money_tracking_app/widgets/custom_textformfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  File? userFile;
  DateTime? selectedDate;
  TextEditingController userfullNameCtrl = TextEditingController();
  TextEditingController userPasswordCtrl = TextEditingController();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController userBirthdayCtrl = TextEditingController();

  Future<void> openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    setState(() {
      userFile = File(image.path);
    });
  }

  showWarningSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(mainColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'ลงทะเบียน',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'ข้อมูลผู้ใช้',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      await openCamera();
                    },
                    child:
                        userFile == null
                            ? Image.asset(
                              'assets/images/user_camera.png',
                              width: 150,
                              height: 150,
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                userFile!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    fieldKey: const Key('fullNameKey'),
                    controller: userfullNameCtrl,
                    labelText: "ชื่อ-สกุล",
                    hintText: "YOUR NAME",
                    validateText: 'กรุณาใส่ชื่อ-สกุลให้ถูกต้อง',
                  ),
                  CustomTextFormField(
                    fieldKey: const Key('birthdayKey'),
                    controller: userBirthdayCtrl,
                    labelText: "วัน-เดือน-ปี เกิด",
                    iconSuffix: Icons.calendar_month,
                    hintText: "YOUR  BIRTHDAY",
                    validateText: 'กรุณาใส่วัน-เดือน-ปี เกิดให้ถูกต้อง',
                  ),
                  CustomTextFormField(
                    fieldKey: const Key('userNameKey'),
                    controller: userNameCtrl,
                    labelText: "ชื่อผู้ใช้งาน",
                    hintText: "Username",
                    validateText: 'กรุณาใส่ชื่อผู้ใช้ให้ถูกต้อง',
                  ),
                  CustomTextFormField(
                    fieldKey: const Key('passwordKey'),
                    controller: userPasswordCtrl,
                    obscureText: true,
                    iconSuffix: Icons.lock,
                    labelText: "รหัสผ่าน",
                    hintText: "Password",
                    validateText: 'กรุณาใส่รหัสผ่านให้ถูกต้อง',
                  ),
                  CustomButton(
                    text: 'บันทึกการลงทะเบียน',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        User user = User(
                          userFullname: userfullNameCtrl.text.trim(),
                          userBirthDate: userBirthdayCtrl.text.trim(),
                          userName: userNameCtrl.text.trim(), // ← อันนี้แก้!
                          userPassword: userPasswordCtrl.text.trim(),
                        );

                        if (await UserApi().registerUser(user, userFile)) {
                          Navigator.pop(context);
                        } else {
                          showWarningSnackBar(context, "ลงทะเบียนไม่สําเร็จ");
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
      ),
    );
  }
}
