import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo/Todo.dart';
import 'package:todo/TodoDetail.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();

}

class TodoListState extends State<TodoList> {

  List<Todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // if (todoList == null) {
    //   todoList = List<Todo>();
    //   updateListView();
    // }
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Todo').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        var result = snapshot.data;
        return _buildList(context, result.documents);
      },
    );

  }

  _buildRow(Todo todo){
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber,
          child: Text(getFirstLetter(todo.title),
          style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        title: Text(todo.title, style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Text(todo.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.delete, color: Colors.red),
              onTap: () {
                _delete(context, todo);
              },
            )
          ],
        ),
        onTap: () {
          debugPrint('Called');
          navigateToDetail(todo, 'Edit Todo');
        },
      ),
    );
  }
  navigateToDetail(Todo todo, String title) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));
  }

  getFirstLetter(String title) => title.substring(0, 2);

  _delete(BuildContext context, Todo todo) async {
    final logger = Logger();
    logger.e(">><>>", todo.id);
    final todoReference = Firestore.instance;
    await todoReference.collection('Todo').document(todo.id.toString()).delete();
  }

  _showSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message),);
      Scaffold.of(context).showSnackBar(snackbar);
    }

  updateListView() {
    // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    // dbFuture.then((database) {
    //   Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
    //   todoListFuture.then((todoList) {
    //     setState(() {
    //       this.todoList = todoList;
    //       this.count = todoList.length;
    //     });
    //   });
    // });

  }
  _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map<Widget>((data) => _buildListItem(data)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo('', '', '', null), 'Add Todo');
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      )
    );
  }

  _buildListItem(DocumentSnapshot data) {
    final todo = Todo.fromSnapshot(data);
    return _buildRow(todo);
  }

}
