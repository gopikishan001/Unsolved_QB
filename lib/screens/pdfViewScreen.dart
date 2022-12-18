// import 'dart:html';
import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pspdfkit_flutter/pspdfkit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:unsolved_qb/utils/colors.dart';
import 'package:unsolved_qb/utils/fireBaseHelper.dart';
import 'package:unsolved_qb/utils/globalData.dart';
import 'package:unsolved_qb/utils/localDataBaseHelper.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_file_utils/flutter_file_utils.dart';

// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

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

  // bool downloading = false;
  // var progress = "";
  // var path = "No Data";
  // var platformVersion = "Unknown";
  // var _onPressed;
  // late Directory externalDir;
  double progress = 0;

  // Track if the PDF was downloaded here.
  bool didDownloadPDF = false;

  // Show the progress status to the user.
  String progressString = 'File has not been downloaded yet.';

  Future<void> updateProgress(done, total) async {
    progress = done / total;

    if (progress >= 1) {
      await DataBaseHelper.instance.insert({
        DataBaseHelper.file_name: widget.pdfName,
        DataBaseHelper.size: docMap[widget.pdfName]!["size"],
        DataBaseHelper.pages: docMap[widget.pdfName]!["pages"],
      }, 0);
      setState(() {
        progressString =
            '✅ File has finished downloading. Try opening the file.';

        toast("✅ File Downloaded");
      });

      // didDownloadPDF = true;

    } else {
      setState(() {
        progressString = 'Download progress: ' +
            (progress * 100).toStringAsFixed(0) +
            '% done.';
        toast(progressString);
      });
    }
  }

  Future download(Dio dio, String url, String savePath) async {
    try {
      // print(savePath);

      await dio.download(url, savePath,
          onReceiveProgress: (receivedBytes, totalBytes) {
        setState(() {
          // downloading = true;
          String progress2 =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
          toast(progress2);
        });
      });

      // Response response = await dio.get(
      //   url,
      //   onReceiveProgress: updateProgress,
      //   options: Options(
      //       responseType: ResponseType.bytes,
      //       followRedirects: false,
      //       validateStatus: (status) {
      //         return status! < 500;
      //       }),
      // );
      // var file = File(savePath).openSync(mode: FileMode.write);

      // file.writeFromSync(response.data);
      // await file.close();

      await DataBaseHelper.instance.insert({
        DataBaseHelper.file_name: widget.pdfName,
        DataBaseHelper.size: docMap[widget.pdfName]!["size"],
        DataBaseHelper.pages: docMap[widget.pdfName]!["pages"],
      }, 0);

      // toast("✅ file downloaded");
    } catch (e) {
      print(e);
    }
  }

  downloadButton(url, fileName) async {
    // var tempDir = await getApplicationDocumentsDirectory();

    // String c_path = "/storage/emulated/0/Download/Unsolved_QB";

    getpermission();
    didDownloadPDF = false;

    if (offlineDocMap.containsKey(fileName)) {
      toast("redownloading file");
      DataBaseHelper.instance.delete(offlineDocMap[fileName]!["id"], 0);
    }

    didDownloadPDF
        ? null
        : download(Dio(), url, tempDir + "/$fileName" + ".pdf");
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
              backgroundColor: backgroundColor[300],
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
                              // toast("downloading document");

                              downloadButton(docMap[widget.pdfName]!["link"],
                                  widget.pdfName);
                            },
                            child: Icon(Icons.download, color: appBarTextColor))
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
                : offlinePDFview(widget.pdfName.toString())

            // SfPdfViewer.network(
            //     docMap[widget.pdfName].toString(),
            //     onDocumentLoadFailed: (details) {
            //       toast("Failed loading PDF");
            //     },
            //   ),
            ),
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

  getpermission() async {
    var status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }

    status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      toast("Permission denied");
    }

    // await Permission.manageExternalStorage.request();
  }

  offlinePDFview(name) {
    getpermission();

    return SfPdfViewer.file(File(tempDir + "/$name" + ".pdf"));
    // return SfPdfViewer.file(File(file));
  }

  // Future<void> downloadFile() async {
  //   Dio dio = Dio();

  //   final status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     String dirloc = "";
  //     if (Platform.isAndroid) {
  //       dirloc = "/sdcard/download/";
  //     } else {
  //       // dirloc = (await getApplicationDocumentsDirectory()).path;
  //     }

  //     try {
  //       FileUtils.mkdir([dirloc]);
  //       await dio.download(
  //           pdfUrl, dirloc + convertCurrentDateTimeToString() + ".pdf",
  //           onReceiveProgress: (receivedBytes, totalBytes) {
  //         print('here 1');
  //         setState(() {
  //           downloading = true;
  //           progress =
  //               ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
  //           print(progress);
  //         });
  //         print('here 2');
  //       });
  //     } catch (e) {
  //       print('catch catch catch');
  //       print(e);
  //     }

  //     setState(() {
  //       downloading = false;
  //       progress = "Download Completed.";
  //       path = dirloc + convertCurrentDateTimeToString() + ".pdf";
  //     });
  //     print(path);
  //     print('here give alert-->completed');
  //   } else {
  //     setState(() {
  //       progress = "Permission Denied!";
  //       _onPressed = () {
  //         downloadFile();
  //       };
  //     });
  //   }
  // }

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
