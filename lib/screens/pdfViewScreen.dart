import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:unsolved_qb/utils/colors.dart';
import 'package:unsolved_qb/utils/globalData.dart';
import 'package:unsolved_qb/utils/localDataBaseHelper.dart';

class pdfViewScreen extends StatefulWidget {
  pdfViewScreen({super.key, required this.pdfName, required this.isOnline});

  String pdfName;
  bool isOnline;

  @override
  State<pdfViewScreen> createState() => _pdfViewScreenState();
}

class _pdfViewScreenState extends State<pdfViewScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return onwillPop();
        },
        child: Scaffold(
            appBar: AppBar(
              // shadowColor: Colors.transparent,
              foregroundColor: appBarTextColor,
              backgroundColor: backgroundColor,
              leading: TextButton(
                  style: pdfViewScreenButtonStyle(),
                  onPressed: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: appBarTextColor)),
              title: Text(widget.pdfName.length < 26
                  ? widget.pdfName
                  : widget.pdfName.substring(0, 25) + "..."),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: widget.isOnline
                        ? TextButton(
                            style: pdfViewScreenButtonStyle(),
                            onPressed: () async {
                              if (offlineDocMap.containsKey(widget.pdfName)) {
                                toast("already added");
                              } else {
                                offlineDocMap[widget.pdfName] = {
                                  "size": docMap[widget.pdfName]!["size"],
                                  "pages": docMap[widget.pdfName]!["pages"],
                                  "link": docMap[widget.pdfName]!["link"],
                                };
                                toast("Adding to Bookmark");
                                await DataBaseHelper.instance.insert({
                                  DataBaseHelper.file_name: widget.pdfName,
                                  DataBaseHelper.size:
                                      docMap[widget.pdfName]!["size"],
                                  DataBaseHelper.pages:
                                      docMap[widget.pdfName]!["pages"],
                                  DataBaseHelper.file_link:
                                      docMap[widget.pdfName]!["link"],
                                }, 0);
                              }
                            },
                            child: Icon(Icons.bookmark_add_outlined,
                                color: appBarTextColor))
                        : SizedBox())
              ],
            ),
            body: widget.isOnline
                ? SfPdfViewer.network(
                    // "https://www.orimi.com/pdf-test.pdf",
                    docMap[widget.pdfName]!["link"].toString(),
                    onDocumentLoadFailed: (details) {
                      toast("Failed loading PDF");
                    },
                  )
                : SfPdfViewer.network(
                    // "https://www.orimi.com/pdf-test.pdf",
                    offlineDocMap[widget.pdfName]!["link"].toString(),
                    onDocumentLoadFailed: (details) {
                      toast("Failed loading PDF");
                    },
                  )),
      ),
    );
  }

  onwillPop() {
    return {
      Navigator.pop(context),
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    };
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

  ButtonStyle pdfViewScreenButtonStyle() {
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
