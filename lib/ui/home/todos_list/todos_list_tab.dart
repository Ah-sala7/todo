import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c8_online/database/TasksDao.dart';
import 'package:todo_c8_online/providers/AuthProvider.dart';
import 'package:todo_c8_online/ui/home/todos_list/TaskWidget.dart';
import 'package:table_calendar/table_calendar.dart';

class TodosListTab extends StatefulWidget {
  @override
  State<TodosListTab> createState() => _TodosListTabState();
}

class _TodosListTabState extends State<TodosListTab> {
  DateTime selectedDay=DateTime.now();

  DateTime focusedDay=DateTime.now();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
// Rest of your code

    return Column(
      children: [
        TableCalendar(
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay,focusedDay);
            },
        onDaySelected: (selected, focused) {
          setState(() {
            selectedDay=selected;
            focusedDay=focused; // update `_focusedDay` here as well
          });
        },calendarFormat: CalendarFormat.week,
            focusedDay: DateTime.now(),
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now().add(Duration(days: 365)),),
        Expanded(
            child: StreamBuilder(
            stream: TasksDao.listenForTasks(authProvider.databaseUser!.id??"",selectedDay),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(children: [
                  Text('Something went wrong ,please try again'),
                  ElevatedButton(onPressed: () {}, child: Text('try again')),
                ]),
              );
            }
            var tasksList = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                return TaskWidget(tasksList![index]);
              },
              itemCount: tasksList?.length ?? 0,
            );
          },
        ))
      ],
    );
  }
}
