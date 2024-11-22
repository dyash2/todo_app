import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/themes/app_theme.dart';
import 'package:todo_app/themes/typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  List<Map<String, String>> taskList = [];
  final date = DateFormat('dd MMM').format(DateTime.now());
  final List<Color> cardColors = [
    AppCardTheme.lightGreen,
    AppCardTheme.lightPurple,
    AppCardTheme.lightBlue,
    AppCardTheme.lightOrange,
  ];

  void _addTask() {
    setState(() {
      taskList.add({
        'date': date,
        'title': titleController.text, // Correcting to use text
        "description": descController.text,
      });
      titleController.clear();
      descController.clear();
    });
  }

// Updated showAddTask function with priority and due date
  void showAddTask() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Add Task',
            style: AppTextStyles.appbartitle,
          ),
          content: SizedBox(
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: AppTextStyles.title,
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration:
                        const InputDecoration(labelText: 'Eg : Get Groceries'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Description",
                    style: AppTextStyles.title,
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                        labelText: 'Eg : Groceries at 5pm'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Priority",
                    style: AppTextStyles.title,
                  ),
                  DropdownButtonFormField<String>(
                    items: ['High', 'Medium', 'Low']
                        .map((priority) => DropdownMenuItem<String>(
                              value: priority,
                              child: Text(priority),
                            ))
                        .toList(),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Select Priority',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Due Date",
                    style: AppTextStyles.title,
                  ),
                  TextFormField(
                    controller:
                        titleController, // Add a DatePicker controller here
                    decoration: InputDecoration(
                      labelText: 'Select Due Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addTask();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppCardTheme.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Add",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppCardTheme.lightRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Task\nManager", style: AppTextStyles.appbartitle),
        toolbarHeight: 80,
        backgroundColor: AppTheme.bgColor,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'Update') {
              } else if (value == 'Delete') {}
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'Update',
                child: Text(
                  'Update',
                  style: AppTextStyles.date,
                ),
              ),
              PopupMenuItem(
                value: 'Delete',
                child: Text(
                  'Delete',
                  style: AppTextStyles.date,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: AppTheme.bgColor,
        child: taskList.isEmpty
            ? Center(
                child: Text(
                  "No tasks available.\nAdd a task using the '+' button!",
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  //searchbar
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: TextField(
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        labelText: 'Search event, meeting, goals, etc...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // task list
                  Expanded(
                    child: ListView.builder(
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        final task = taskList[index];
                        final color = cardColors[index % cardColors.length];
                        return Dismissible(
                          key: Key(task["id"].toString()),
                          direction: DismissDirection.startToEnd,
                          movementDuration: Duration(seconds: 5),
                          background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            // Handle task deletion
                            setState(() {
                              taskList.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Deleted: ${task["title"]?.toUpperCase()}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      taskList.insert(index, task);
                                    });
                                  },
                                  textColor: Colors.white,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task["date"] ?? "No Date",
                                  style: AppTextStyles.date,
                                ),
                                Text(
                                  task["title"] ?? "No Title",
                                  style: AppTextStyles.title,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  task["description"] ?? "No Description",
                                  style: AppTextStyles.subtitle,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTask,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppTheme.bgColor,
    );
  }
}
