import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unsolved_qb/screens/pdfViewScreen.dart';
import 'package:unsolved_qb/utils/colors.dart';
import 'package:unsolved_qb/utils/globalData.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/fileModel.dart';
import '../utils/localDataBaseHelper.dart';

class rightDrawerScreen extends StatefulWidget {
  rightDrawerScreen({super.key});

  @override
  State<rightDrawerScreen> createState() => _rightDrawerScreenState();
}

class _rightDrawerScreenState extends State<rightDrawerScreen> {
  // initState() {
  //   super.initState();

  //   LoadDB();
  // }

  Future<List> LoadDB() async {
    List<Map<String, dynamic>> fileDB =
        await DataBaseHelper.instance.querryAll([], 0);

    // id_name[invDB[ind]["id"]] = invDB[ind][DataBaseHelper.inv_Name]

    offlineDocMap.clear();
    // if (fileDB.isNotEmpty) {
    //   for (int index = 0; index < fileDB.length; index++) {
    //     offlineDocMap[fileDB[index][DataBaseHelper.file_name]] = {
    //       "id": fileDB[index]["id"],
    //       "size": fileDB[index][DataBaseHelper.size],
    //       "pages": fileDB[index][DataBaseHelper.pages]
    //     };
    //   }
    // }

    return List.generate(fileDB.length, (index) {
      if (fileDB.isNotEmpty) {
        offlineDocMap[fileDB[index][DataBaseHelper.file_name]] = {
          "id": fileDB[index]["id"],
          "size": fileDB[index][DataBaseHelper.size],
          "pages": fileDB[index][DataBaseHelper.pages],
          "link": fileDB[index][DataBaseHelper.file_link]
        };
      }

      return fileModel(
        fileID: fileDB[index]["id"],
        name: fileDB[index][DataBaseHelper.file_name] == null ||
                fileDB[index][DataBaseHelper.file_name] == ""
            ? "Doc Name"
            : fileDB[index][DataBaseHelper.file_name],
        link: fileDB[index][DataBaseHelper.file_link] == null ||
                fileDB[index][DataBaseHelper.file_link] == ""
            ? "link"
            : fileDB[index][DataBaseHelper.file_link],
        size: fileDB[index][DataBaseHelper.size] ?? "",
        pages: fileDB[index][DataBaseHelper.pages] ?? "",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 1.4,
      decoration: BoxDecoration(color: backgroundColor[100]),
      child: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                decoration: BoxDecoration(color: backgroundColor[300]),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "add_data");
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.star_border_outlined,
                                    color: appBarTextColor,
                                    size: 22,
                                  ),
                                  SizedBox(height: 5),
                                  Text("Rate",
                                      style: TextStyle(color: appBarTextColor)),
                                ],
                              ),
                            ),
                          ),
                          VerticalDivider(
                              width: 0, color: Colors.white.withOpacity(0.4)),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Share.share(shareMessage);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: appBarTextColor,
                                    size: 22,
                                  ),
                                  SizedBox(height: 5),
                                  Text("Share",
                                      style: TextStyle(color: appBarTextColor)),
                                ],
                              ),
                            ),
                          ),
                          VerticalDivider(
                              width: 0, color: Colors.white.withOpacity(0.4)),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                sendMail();
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.mail_outline,
                                    color: appBarTextColor,
                                    size: 22,
                                  ),
                                  SizedBox(height: 5),
                                  Text("Contact us",
                                      style: TextStyle(color: appBarTextColor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.white.withOpacity(0.4)),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmarks_outlined,
                              color: appBarTextColor,
                            ),
                            SizedBox(width: 8),
                            Text("Bookmarked",
                                style: TextStyle(
                                    color: appBarTextColor, fontSize: 20))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 16,
            child: FutureBuilder(
                future: LoadDB(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) =>
                    snapshot.hasData
                        ? snapshot.data!.isNotEmpty
                            ? ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, index) {
                                  return favCard(snapshot.data![index]);
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Nothing Bookmarked",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : const Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
    );
  }

  sendMail() async {
    String email = Uri.encodeComponent("gkay140@gmail.com");
    String subject = Uri.encodeComponent("Question Bank app Query");
    String body = Uri.encodeComponent("");
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    await launchUrl(mail);
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

  favCard(file) {
    return Column(
      children: [
        // Divider(
        // height: 0, color: Colors.black.withOpacity(0.2)),
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => pdfViewScreen(
                        pdfName: file.name,
                        isOnline: false,
                      ))),
          child: Container(
            decoration: BoxDecoration(
                // color: Colors.grey[100],
                // borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
            height: 75,
            // margin: const EdgeInsets.symmetric(vertical: 3),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        file.name.length < 21
                            ? file.name
                            : file.name.substring(0, 20) + "...",
                        textScaleFactor: 1.3),
                    SizedBox(height: 8),
                    Row(children: [
                      Text(
                        "pages : " + file.pages.toString(),
                        style: TextStyle(fontSize: 12.5),
                      ),
                      SizedBox(width: 10),
                      Text("size : " + file.size.toString() + " MB",
                          style: TextStyle(fontSize: 12.5))
                    ]),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          DataBaseHelper.instance.delete(file.fileID, 0);
                          setState(() {});
                        },
                        child: Icon(
                          Icons.delete_outline,
                          size: 25,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(height: 0, color: Colors.black.withOpacity(0.1))
      ],
    );
  }

  toast(msg) {
    Fluttertoast.showToast(
        msg: msg.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 75, 75, 75),
        fontSize: 16.0);
  }

  // drawerScreenButtonStyle() {
  //   return ButtonStyle(
  //     fixedSize: MaterialStateProperty.all<Size>(
  //         Size(MediaQuery.of(context).size.width, 40)),
  //     backgroundColor: MaterialStateColor.resolveWith(
  //         (states) => backgroundColor.withOpacity(0.5)),
  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //         RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0),
  //     )),
  //   );
  // }
}
