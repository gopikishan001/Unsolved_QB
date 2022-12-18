import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

List<String> courseList = [];
List<String> branchList = [];
List<String> semList = [];
List<String> subjectList = [];
List<String> typeList = [];
List<String> docList = [];
// List<String> offlineDocList = [];

String selected_course = "Course";
String selected_branch = "Branch";
String selected_sem = "Semester";
String selected_sub = "Subject";
String selected_type = "Type";
// String selected_paper = "";

Map<String, String> branchMap = {};
Map<String, String> subjectMap = {};
Map<String, Map<String, dynamic>> docMap = {};
Map<String, Map<String, dynamic>> offlineDocMap = {};

GlobalKey<ScaffoldState> drawerKey = GlobalKey();

var tempDir = "";

String shareMessage =
    "Hey check out this app. Will be available on playstore soon";
