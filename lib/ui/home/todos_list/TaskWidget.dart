import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_c8_online/database/TasksDao.dart';
import 'package:todo_c8_online/database/model/task.dart';
import 'package:todo_c8_online/database/my_database.dart';
import 'package:todo_c8_online/providers/AuthProvider.dart';
import 'package:todo_c8_online/ui/dialog_utils.dart';
import 'package:todo_c8_online/ui/home/todos_list/TaskWidget.dart';
import 'package:todo_c8_online/ui/home/update_task_bottom_sheet.dart';

class TaskWidget extends StatefulWidget {
Task task;
TaskWidget(this.task);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane:ActionPane(
        children: [
          SlidableAction(onPressed: (context) {
            deleteTask();
          },
            icon: Icons.delete,
            backgroundColor: Colors.red,
          label: 'delete',
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12)
          ),)
        ],
        motion: DrawerMotion(),
      ) ,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(18),
              ),
              width: 4,
              height: 64,
            ),
            Expanded(child: Container(
              padding:EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.task.title??'',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),),
                    Text(widget.task.desc??'',style: TextStyle(
                      fontSize: 12
                    ),)
                  ],
              ),
                  IconButton(onPressed: (){
                    showUpdateTaskSheet();
                  }, icon: Icon(Icons.edit,color: Colors.blue,))]
                ),
            )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ImageIcon(AssetImage('assets/images/ic_check.png'),color: Colors.white,),
            ),

          ],
        ),
      ),
    );
  }
  void deleteTask(){
    DialogUtils.showMessage(context, 'Are you sure to delete this task ?',
    postActionName: 'yes',
    posAction: () {
      deleteTaskFromFirestore();
    },
    negActionName: 'cancel');
  }

  void deleteTaskFromFirestore() async{
    var authProvider=Provider.of<AuthProvider>(context);
    //DialogUtils.showMessage(context, 'deleting task...',dismissible: false);
    await TasksDao.removeTask(widget.task.id!,authProvider.databaseUser!.id!);
   // DialogUtils.hideDialog(context);
  }

  void showUpdateTaskSheet() {
    showModalBottomSheet(context: context, builder: (buildContext){
      return UpdateTaskBottomSheet();
    });
  }
}


