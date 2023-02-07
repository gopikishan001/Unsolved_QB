import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unsolved_qb/utils/colors.dart';
import 'package:unsolved_qb/utils/fireBaseHelper.dart';
import 'package:unsolved_qb/utils/globalData.dart';

class leftDrawerScreen extends StatefulWidget {
  leftDrawerScreen({super.key});

  @override
  State<leftDrawerScreen> createState() => _leftDrawerScreenState();
}

class _leftDrawerScreenState extends State<leftDrawerScreen> {
  void initState() {
    super.initState();

    loadCourse();
  }

  Future loadCourse() async {
    courseList = await fireBaseHelper().getCourseList();
    setState(() {});
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
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(color: backgroundColor[300]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.notes, color: appBarTextColor),
                    SizedBox(width: 8),
                    Text(
                      "Unsolved QB",
                      style: TextStyle(color: appBarTextColor, fontSize: 20),
                    )
                  ],
                ),
              )),
          Expanded(
            flex: 14,
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
                      selected_sem = "Sem / Year";
                      subjectList.clear();
                      selected_sub = "Subject";
                      typeList.clear();
                      selected_type = "Type";

                      selected_course = value.toString();
                      branchList = List<String>.from(await fireBaseHelper()
                          .getBranchList(selected_course));

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
                      selected_sem = "Sem / Year";
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
                  TextButton(
                    style: drawerScreenButtonStyle(),
                    onPressed: () async {
                      if (selected_course == "Course") {
                        toast("select course");
                      } else if (selected_branch == "Branch") {
                        toast("select Branch");
                      } else if (selected_sem == "Sem / Year") {
                        toast("select Sem / Year");
                      } else if (selected_sub == "Subject") {
                        toast("select Subject");
                      } else if (selected_type == "Type") {
                        toast("select Type");
                      } else {
                        await fireBaseHelper().getDocList(
                            selected_course,
                            selected_branch,
                            selected_sem,
                            selected_sub,
                            selected_type);

                        // fireBaseHelper().uploadValues(selected_course, selected_branch,
                        //     selected_sem, selected_sub, selected_type, "name");

                        drawerKey.currentState!.closeDrawer();
                      }
                    },
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  drawerScreenButtonStyle() {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all<Size>(
          Size(MediaQuery.of(context).size.width, 40)),
      backgroundColor: MaterialStateColor.resolveWith(
          (states) => backgroundColor.withOpacity(0.5)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )),
    );
  }
}

toast(data) {
  Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 75, 75, 75),
      fontSize: 16.0);
}
