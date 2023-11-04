import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_c8_online/database/model/task.dart';
import 'package:todo_c8_online/database/my_database.dart';

class TasksDao{
  static CollectionReference<Task> getTasksCollection(String uid){
    return MyDataBase.getUsersCollection().
    doc(uid).collection(Task.collectionName).
    withConverter(
      fromFirestore: (snapshot, options) => Task.fromFireStore(snapshot.data()),
      toFirestore: (task, options) => task.toFireStore(),);
  }
  static Future<void> createTask(Task task,String uid)async{
    var docref=getTasksCollection(uid).doc();
    task.id=docref.id;
    return docref.set(task);
  }
  static Future<void> updateTask(Task task)async{
    DocumentReference taskRef = FirebaseFirestore.instance.collection('tasks').doc(task.id);

    // Update the task document with the new data
    await taskRef.update({
      'title': task.title,
      'desc': task.desc,
      // Add other properties as needed
    });
  }
  static Future<List<Task>> getAllTasks(String uid,DateTime selected)async{
    var date=selected.copyWith(hour: 0,minute: 0,second: 0,millisecond: 0,microsecond: 0);
    var tasksSnapshot =await getTasksCollection(uid).
    where('dateTime' ,
        isEqualTo: Timestamp
            .fromMillisecondsSinceEpoch(
            date.millisecondsSinceEpoch))
        .get();
    var tasksList =tasksSnapshot.docs.
    map((snapshot) => snapshot.data()).
    toList();
    return tasksList;
  }
  static Stream<List<Task>> listenForTasks(String uid,DateTime selected)async*{
    var date=selected.copyWith(hour: 0,minute: 0,second: 0,millisecond: 0,microsecond: 0);
    var stream = getTasksCollection(uid).where('dateTime' ,
        isEqualTo: Timestamp
            .fromMillisecondsSinceEpoch(
            date.millisecondsSinceEpoch)).snapshots();
    yield* stream.map((QuerySnapshot) => QuerySnapshot.docs.map((doc) => doc.data()).toList());

  }
  static Future<void> removeTask(String taskId,String userId){
    return getTasksCollection(userId).doc(taskId).delete();
  }
}