import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c8_online/providers/AuthProvider.dart';
import 'package:todo_c8_online/ui/dialog_utils.dart';
import 'package:todo_c8_online/ui/home/add_task_bottom_sheet.dart';
import 'package:todo_c8_online/ui/home/settings/settings_tab.dart';
import 'package:todo_c8_online/ui/home/todos_list/todos_list_tab.dart';
import 'package:todo_c8_online/ui/login/login_screen.dart';
class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex= 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Route todo app'),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: (){
            logout();

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(
          side: BorderSide(color: Colors.white,width: 4)
        ),
        onPressed: (){
          showAddTaskSheet();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index){
            setState(() {
              selectedIndex =index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list,size: 32,),label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings,size: 32,),label: ''),
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }
  void showAddTaskSheet(){
    showModalBottomSheet(context: context, builder: (buildContext){
      return AddTaskBottomSheet();
    });
  }
  var tabs = [
    TodosListTab(),
    SettingsTab()
  ];

  void logout() {
    var authProvider=Provider.of<AuthProvider>(context,listen: false);
    DialogUtils.showMessage(context, 'Are you sure to logout ?',
      postActionName: 'yes',
      posAction: (){
        authProvider.logout();
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      },
      negActionName: 'cancel',
    );
  }

}
