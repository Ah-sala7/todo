import 'package:cloud_firestore/cloud_firestore.dart';

class Task{
  static const String collectionName = 'tasks';
  String? id;
  String? title;
  String? desc;
  Timestamp? dateTime;
  bool? isDone;

  Task({this.id,this.title,this.desc,this.dateTime,this.isDone=false});

  Task.fromFireStore(Map<String,dynamic>? data):
      this(id: data?['id'],
        title: data?['title'],
        desc: data?['desc'],
        dateTime: data?['dateTime'],
        isDone: data?['isDone'],
      );

  Map<String,dynamic>toFireStore(){
    return {
      'id':id,
      'title':title,
      'desc':desc,
      'dateTime':dateTime,
      'isDone':isDone
    };
  }
}