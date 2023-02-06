import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:unsolved_qb/utils/colors.dart';
import '../utils/fireBaseHelper.dart';

import '../utils/globalData.dart';
import 'leftDrawerScreen.dart';

class addData extends StatefulWidget {
  const addData({super.key});

  @override
  State<addData> createState() => _addDataState();
}

class _addDataState extends State<addData> {
  @override
  initState() {
    super.initState();
    loadCourse();

    selected_course = "Course";
    selected_branch = "Branch";
    selected_sem = "Semester";
    selected_sub = "Subject";
    selected_type = "Type";
  }

  Future loadCourse() async {
    courseList = await fireBaseHelper().getCourseList();
    setState(() {});
  }

  final link_text = TextEditingController();
  final fileName_text = TextEditingController();
  final img_text = TextEditingController();
  final size_text = TextEditingController();
  final pages_text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar:
          AppBar(title: Text("Adding data"), backgroundColor: backgroundColor),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              DropdownButton(
                isExpanded: true,
                hint: Text(selected_course),
                items: List.generate(courseList.length, ((index) {
                  return DropdownMenuItem(
                    value: courseList[index],
                    child: Text(courseList[index]),
                  );
                })),
                onChanged: (value) async {
                  branchList.clear();
                  selected_branch = "Branch";
                  semList.clear();
                  selected_sem = "Semester";
                  subjectList.clear();
                  selected_sub = "Subject";
                  typeList.clear();
                  selected_type = "Type";

                  selected_course = value.toString();
                  branchList = List<String>.from(
                      await fireBaseHelper().getBranchList(selected_course));

                  setState(() {});
                },
              ),
              DropdownButton(
                isExpanded: true,
                hint: Text(selected_branch),
                items: List.generate(branchList.length, ((index) {
                  return DropdownMenuItem(
                    value: branchList[index],
                    child: Text(branchList[index]),
                  );
                })),
                onChanged: (value) async {
                  semList.clear();
                  selected_sem = "Semester";
                  subjectList.clear();
                  selected_sub = "Subject";
                  typeList.clear();
                  selected_type = "Type";

                  selected_branch = value.toString();

                  semList = await fireBaseHelper()
                      .getSemList(selected_course, selected_branch);

                  setState(() {});
                },
              ),
              DropdownButton(
                isExpanded: true,
                hint: Text(selected_sem),
                items: List.generate(semList.length, ((index) {
                  return DropdownMenuItem(
                    value: semList[index],
                    child: Text(semList[index]),
                  );
                })),
                onChanged: (value) async {
                  subjectList.clear();
                  selected_sub = "Subject";
                  typeList.clear();
                  selected_type = "Type";

                  selected_sem = value.toString();

                  subjectList = List<String>.from(await fireBaseHelper()
                      .getSubList(
                          selected_course, selected_branch, selected_sem));
                  setState(() {});
                },
              ),
              DropdownButton(
                isExpanded: true,
                hint: Text(selected_sub),
                items: List.generate(subjectList.length, ((index) {
                  return DropdownMenuItem(
                    value: subjectList[index],
                    child: Text(subjectList[index]),
                  );
                })),
                onChanged: (value) async {
                  typeList.clear();
                  selected_type = "Type";
                  selected_sub = value.toString();
                  typeList = List<String>.from(await fireBaseHelper()
                      .getTypeList(selected_course, selected_branch,
                          selected_sem, selected_sub));
                  setState(() {});
                },
              ),
              DropdownButton(
                isExpanded: true,
                hint: Text(selected_type),
                items: List.generate(typeList.length, ((index) {
                  return DropdownMenuItem(
                    value: typeList[index],
                    child: Text(typeList[index]),
                  );
                })),
                onChanged: (value) {
                  selected_type = value.toString();
                  setState(() {});
                },
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text("File Name : ", textScaleFactor: 1.5),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 160,
                      child: TextFormField(controller: fileName_text)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 150,
                    child: TextFormField(
                      controller: link_text,
                      maxLines: null,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    doc_test(link: link_text.text.toString())));
                      },
                      child: Text(
                        "test link",
                        textScaleFactor: 1.5,
                      ))
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 200,
                    child: TextFormField(
                      controller: img_text,
                      maxLines: null,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text(
                        "test img",
                        textScaleFactor: 1.5,
                      )),
                  Image.network(
                    img_text.text.toString(),
                    height: 50,
                    width: 50,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "pages",
                    textScaleFactor: 1.5,
                  ),
                  SizedBox(width: 10),
                  Container(
                      height: 50,
                      width: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: pages_text,
                      )),
                  SizedBox(width: 50),
                  Text(
                    "size in mb",
                    textScaleFactor: 1.5,
                  ),
                  SizedBox(width: 10),
                  Container(
                      height: 50,
                      width: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: size_text,
                      ))
                ],
              ),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () {
                    if (selected_course == "Course") {
                      toast("select course");
                    } else if (selected_branch == "Branch") {
                      toast("select Branch");
                    } else if (selected_sem == "Semester") {
                      toast("select semester");
                    } else if (selected_sub == "Subject") {
                      toast("select subject");
                    } else if (selected_type == "Type") {
                      toast("select type");
                    } else if (fileName_text.text == "") {
                      toast("File name missing");
                    } else if (link_text.text == "") {
                      toast("File link missing");
                    } else if (img_text.text == "") {
                      toast("Image link missing");
                    } else if (size_text.text == "") {
                      toast("Size missing");
                    } else if (pages_text.text == "") {
                      toast("pages missing");
                    } else {
                      fireBaseHelper().uploadValues(
                          selected_course,
                          selected_branch,
                          selected_sem,
                          selected_sub,
                          selected_type,
                          fileName_text.text,
                          link_text.text,
                          img_text.text,
                          size_text.text,
                          pages_text.text);

                      toast("data added Successfully");
                      fileName_text.text = "";
                      size_text.text = "";
                      pages_text.text = "";
                      link_text.text = "";
                      img_text.text = "";
                    }
                  },
                  child: Text(
                    "submit",
                    style: TextStyle(color: Colors.red),
                    textScaleFactor: 2,
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}

class doc_test extends StatelessWidget {
  const doc_test({super.key, required this.link});

  final String link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doc link test")),
      body: Container(
          child: SfPdfViewer.network(
        link,
        onDocumentLoadFailed: (details) {
          toast("Failed loading PDF");
        },
      )),
    );
  }
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
