import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unsolved_qb/utils/globalData.dart';

class fireBaseHelper {
  Future getCourseList() async {
    final fetchList = FirebaseFirestore.instance.collection('courses');

    List<String> itemsList = [];

    try {
      await fetchList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.id.toString());
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      // return null;
      return [];
    }
  }

  Future getBranchList(course) async {
    try {
      final fetchList = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course)
          .get();
      branchMap = Map<String, String>.from(fetchList["map"]);

      return fetchList["map"].keys.toList();
    } catch (e) {
      print(e.toString());
      // return null;
      return [];
    }
  }

  Future getSemList(course, branch) async {
    final fetchList = FirebaseFirestore.instance
        .collection("courses")
        .doc(course)
        .collection(branchMap[branch].toString());

    List<String> itemsList = [];

    try {
      await fetchList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.id.toString());
        });
      });

      return itemsList;
    } catch (e) {
      print(e.toString());
      // return null;
      return [];
    }
  }

  Future getSubList(course, branch, sem) async {
    try {
      final fetchList = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course)
          .collection(branchMap[branch].toString())
          .doc(sem)
          .get();

      subjectMap = Map<String, String>.from(fetchList["map"]);

      return fetchList["map"].keys.toList();
    } catch (e) {
      print(e.toString());
      // return null;
      return [];
    }
  }

  Future getTypeList(course, branch, sem, sub) async {
    final fetchList = FirebaseFirestore.instance
        .collection('courses')
        .doc(course)
        .collection(branchMap[branch].toString())
        .doc(sem)
        .collection(subjectMap[sub].toString());

    List<String> itemsList = [];

    try {
      await fetchList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.id.toString());
        });
      });

      return itemsList;
    } catch (e) {
      print(e.toString());
      // return null;
      return [];
    }
  }

  Future getDocList(course, branch, sem, sub, type) async {
    List<String> itemsList = [];

    try {
      final fetchList = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course)
          .collection(branchMap[branch].toString())
          .doc(sem)
          .collection(subjectMap[sub].toString())
          .doc(type)
          .get();

      docMap = Map<String, Map<String, dynamic>>.from(convert(fetchList));
    } catch (e) {
      print(e.toString());
      showTost("Values not selected properly");
    }
  }

  convert(fetchList) {
    return fetchList.data();
  }

  showTost(data) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 75, 75, 75),
        fontSize: 16.0);
  }

// For uploading links

  uploadValues(course, branch, sem, sub, type, name) {
    FirebaseFirestore.instance
        .collection('courses')
        .doc(course)
        .collection(branchMap[branch].toString())
        .doc(sem)
        .collection(subjectMap[sub].toString())
        .doc(type)
        .set({
      name: {
        "link": "www",
        "pages": 62,
        "size": 4,
      }
    }, SetOptions(merge: true));
  }
}
