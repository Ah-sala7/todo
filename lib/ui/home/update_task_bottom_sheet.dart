import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c8_online/MyDateUtils.dart';
import 'package:todo_c8_online/database/TasksDao.dart';
import 'package:todo_c8_online/database/model/task.dart';
import 'package:todo_c8_online/providers/AuthProvider.dart';
import 'package:todo_c8_online/ui/components/custom_form_field.dart';
import 'package:todo_c8_online/ui/dialog_utils.dart';

class UpdateTaskBottomSheet extends StatefulWidget {
  @override
  State<UpdateTaskBottomSheet> createState() => _UpdateTaskBottomSheetState();
}

class _UpdateTaskBottomSheetState extends State<UpdateTaskBottomSheet> {
  var titleController = TextEditingController();

  var descriptionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Update Task',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),),
            CustomFormField(label: 'Task title',
                validator: (text){
                  if(text==null || text.trim().isEmpty){
                    return 'please enter task title';
                  }
                },
                controller: titleController),
            CustomFormField(label: 'Task description',
                validator: (text){
                  if(text==null || text.trim().isEmpty){
                    return 'please enter task description';
                  }
                },
                lines: 5,
                controller: descriptionController),
            SizedBox(height: 12,),
            Text('Task Date',style: TextStyle(
                color: Colors.black54,
                fontSize: 16
            ),),
            InkWell(
              onTap: (){
                showTaskDatePicker();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey,width: 1)
                    )
                ),
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('${MyDateUtils.formatTaskDate(selectedDate??DateTime.now())}',style: TextStyle(
                  fontSize: 18,
                ),),
              ),
            ),
            Visibility(
                visible: showDateError,
                child: Text( 'please select task date' ,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme .of(context) .colorScheme.error
                  ), )),// TextSty1e
// Text
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16)
                ),
                onPressed: (){
                  initState();
                  updateTask();
                }, child: Text('Update Task',
              style: TextStyle(fontSize: 18),))
            ,
          ],
        ),
      ),
    );
  }
  bool showDateError = false;
  bool isVaIidForm(){
    bool isValid=true;
    if(formKey.currentState?.validate()== false){
      isValid = false;}
    if(selectedDate==null){
      setState(() {
        showDateError = true;
      });
      isValid = false;

    }
    return isValid;

  }


  DateTime? selectedDate ;

  void updateTask() async {
    if (!isVaIidForm()) return;

    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (selectedDate == null) {
      // Handle the case when selectedDate is null
      // You can show an error message or perform any other necessary action
      selectedDate = DateTime.now();
    }

    Task task = Task(
      title: titleController.text,
      desc: descriptionController.text,
      dateTime: Timestamp.fromMillisecondsSinceEpoch(selectedDate!.millisecondsSinceEpoch),
      id: authProvider.databaseUser != null ? authProvider.databaseUser!.id! : authProvider.firebaseAuthUser!.uid,
    );
    DialogUtils.showLoadingDialog(context, 'Updating task.....');
    await TasksDao.updateTask(task);
    DialogUtils.hideDialog(context);
    DialogUtils.showMessage(
        context, 'Task updated successfully',
        dismissible: false,
        postActionName: 'Ok',
        posAction: (){
          Navigator.pop(context);
        });
  }
  void showTaskDatePicker() async {
    var date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    setState(() {
      selectedDate = date;
      if (selectedDate != null) {
        showDateError = false;
      }
    });
  }

}

