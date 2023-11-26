import 'package:fitnessapp/common_widgets/contact_box.dart';
import 'package:fitnessapp/common_widgets/round_textfield.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/db/db_init.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  List contactList = [];

  @override
  void initState() {
    getContactList();
  }

  void getContactList() async{
    Database db = await DatabaseInit().database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM Contact ORDER BY name ASC");
    setState(() {
      contactList = result;
    });
  }

  bool validationCheck() {
    return nameController.text.isNotEmpty && contactController.text.isNotEmpty;
  }

  void createContact(String name, String contact) async{
    Database db = await DatabaseInit().database;
    print('name: ${nameController.text}, contact: ${contactController.text}');
    await db.rawQuery("""INSERT INTO Contact (name, contact, notificationAvailability) VALUES ('${name}', '${contact}', false)""");
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundTextField(
                  hintText: "이름",
                  icon: "assets/icons/user_icon.png",
                  textInputType: TextInputType.name,
                  textEditingController: nameController,
                ),
                Container(
                  margin: EdgeInsets.all(3),
                ),
                RoundTextField(
                  hintText: "전화번호",
                  icon: "assets/icons/p_contact.png",
                  textInputType: TextInputType.phone,
                  textEditingController: contactController,
                ),
              ],
            ),
            actions: [
              FloatingActionButton(
                child: Text("등록"),
                onPressed: () {
                  if(validationCheck()) {
                    createContact(nameController.text, contactController.text);
                    getContactList();
                    nameController.clear();
                    contactController.clear();
                    Navigator.pop(context);
                  }
                }
              ),
              FloatingActionButton(
                  child: Text("나가기"),
                  onPressed: () {
                    nameController.clear();
                    contactController.clear();
                    Navigator.pop(context);
                  }
              ),
            ],
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Text(
          "보호자 메뉴",
          style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.normal),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
                contactList.length,
                    (index) => ContactBox(
                        id: contactList[index]['id'],
                        name: contactList[index]['name'],
                        contact: contactList[index]['contact'],
                        notificationAvailability: contactList[index]['notificationAvailability'])
            )
          ],
        )
      ),
      floatingActionButton: InkWell(
        onTap: () {
          _showRegisterDialog(context);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SleepAddAlarmView(
          //       date: _selectedDateAppBBar,
          //     ),
          //   ),
          // );
        },
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.secondaryG),
              borderRadius: BorderRadius.circular(27.5),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
              ]),
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            size: 20,
            color: AppColors.whiteColor,
          ),

        ),
      ),
    );
  }
}
