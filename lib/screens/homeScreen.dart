import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unsolved_qb/models/fileModel.dart';
import 'package:unsolved_qb/screens/pdfViewScreen.dart';
import 'package:unsolved_qb/screens/rightDrawerScreen.dart';
import 'package:unsolved_qb/utils/colors.dart';
import 'package:unsolved_qb/utils/fireBaseHelper.dart';
import 'package:unsolved_qb/utils/globalData.dart';
import 'package:unsolved_qb/utils/localDataBaseHelper.dart';
import 'package:unsolved_qb/utils/notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import 'leftDrawerScreen.dart';

class homeScreen extends StatefulWidget {
  homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: leftDrawerScreen(),
      endDrawer: rightDrawerScreen(),
      onDrawerChanged: (isOpen) {
        isOpen ? SizedBox() : {setState(() {})};
      },
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 1.25,
      key: drawerKey,
      appBar: homeScreenAppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(color: backgroundColor[300]),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(10, 10, 8, 0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: docMap.isEmpty
                    ? const Center(
                        child: Text("swipe right to search"),
                      )
                    : ListView.builder(
                        itemCount: docMap.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = docMap.keys.elementAt(index);
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pdfViewScreen(
                                          pdfName: key,
                                          isOnline: true,
                                        ))),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      // color: Colors.grey[350],
                                      //   borderRadius:
                                      //       BorderRadius.all(Radius.circular(5)),
                                      ),
                                  height: 70,
                                  // width: MediaQuery.of(context).size.width,
                                  // margin:
                                  // const EdgeInsets.symmetric(vertical: 3),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 11, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 0),
                                        height: 50,
                                        width: 50,
                                        // color: Colors.grey.withOpacity(0.5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[350],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                        ),
                                        child: previewImage(context,
                                            docMap[key]!["image"].toString()),
                                      ),
                                      SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              key.length < 26
                                                  ? key
                                                  : key.substring(0, 25) +
                                                      "...",
                                              textScaleFactor: 1.4),
                                          SizedBox(height: 5),
                                          Expanded(
                                            child: Row(children: [
                                              Text(
                                                docMap[key]!["pages"] == null
                                                    ? "pages : 0"
                                                    : "pages : " +
                                                        docMap[key]!["pages"]
                                                            .toString(),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                  docMap[key]!["size"] == null
                                                      ? "size : 0 MB"
                                                      : "size : " +
                                                          docMap[key]!["size"]
                                                              .toString() +
                                                          " MB",
                                                  style:
                                                      TextStyle(fontSize: 12))
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                    height: 0,
                                    color: Colors.black.withOpacity(0.1))
                              ],
                            ),
                          );
                        }),
              ),
            ),
          ),
          //  Expanded(
          //       flex: 1,
          //       child: Container(
          //         decoration: BoxDecoration(color: Colors.red[100]),
          //         child: Center(child: Text("ADDS section")),
          //       ))
        ],
      ),
    ));
  }

  AppBar homeScreenAppBar() {
    return AppBar(
      shadowColor: Colors.transparent,
      foregroundColor: appBarTextColor,
      backgroundColor: backgroundColor[300],
      leading: TextButton(
          style: homeScreenButtonStyle(),
          child: Icon(Icons.menu, color: appBarTextColor),
          onPressed: () => drawerKey.currentState!.openDrawer()),
      title: Text("Unsolved QB"),
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ),
      ],
    );
  }

  Image previewImage(context, imageURL) {
    return Image.network(
      imageURL,
      fit: BoxFit.cover,
      errorBuilder: (context, exception, stackTrace) {
        return Icon(Icons.picture_as_pdf);
      },
      // loadingBuilder: (context, child, loadingProgress) {
      //   if (loadingProgress == null) {
      //     return child;
      //   }
      //   return Center(
      //     child: CircularProgressIndicator(
      //       value: loadingProgress.expectedTotalBytes != null
      //           ? loadingProgress.cumulativeBytesLoaded /
      //               loadingProgress.expectedTotalBytes!
      //           : null,
      //     ),
      //   );
      // },
    );
  }

  ButtonStyle homeScreenButtonStyle() {
    return ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith(
          (states) => appBarTextColor.withOpacity(0.2)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      )),
    );
  }
}
