import 'package:flutter/material.dart';
import 'package:todo_sqlite/add_update_screen.dart';
import 'package:todo_sqlite/db_handler.dart';
import 'package:todo_sqlite/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;

  late Future<List<TodoModel>> datalist;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    datalist = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          "TO DO",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.help_outline_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: datalist,
                  builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.length == 0) {
                      return const Center(
                        child: Text("No Tasks Found",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          int todoId = snapshot.data![index].id!.toInt();
                          String todoTitle =
                              snapshot.data![index].title.toString();
                          String todoDesc =
                              snapshot.data![index].desc.toString();
                          String todoDT =
                              snapshot.data![index].dateandtime.toString();

                          return Dismissible(
                            key: ValueKey<int>(todoId),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.redAccent,
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.delete(todoId);
                                datalist = dbHelper!.getDataList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.yellow.shade300,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        spreadRadius: 1)
                                  ]),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(10),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        todoTitle,
                                        style: const TextStyle(fontSize: 19),
                                      ),
                                    ),
                                    subtitle: Text(
                                      todoDesc,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 0.8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          todoDT,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddUpdateTask(
                                                          todoId: todoId,
                                                          todoTitle: todoTitle,
                                                          todoDesc: todoDesc,
                                                          todoDT: todoDT,
                                                          update: true,
                                                        )));
                                          },
                                          child: const Icon(
                                            Icons.edit_note,
                                            size: 28,
                                            color: Colors.green,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddUpdateTask()));
          }),
    );
  }
}
