import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/database.dart';
import 'package:todo_app/dialog_box.dart';
import 'package:todo_app/todo_component.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // reference the hive box
  final _myBox = Hive.openBox('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override

  //text controller
  final _controller = TextEditingController();

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] =  !db.toDoList[index][1];
      });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // create a new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.white ,
       appBar: AppBar(
         centerTitle: true,
         title: Text('MY DAY'),
         foregroundColor: Colors.white ,
         elevation: 0,
       ),
       floatingActionButton: FloatingActionButton(
         onPressed: createNewTask,
         child: Icon(Icons.add),
       ),
       body: ListView.builder(
           itemCount: db.toDoList.length,
           itemBuilder: (context, index) {
             return ToDoTile(
                 taskName: db.toDoList[index][0] ,
                 taskCompleted: db.toDoList[index][1],
                 onChanged:(value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
             );
           },
       ),
     );
  }
}