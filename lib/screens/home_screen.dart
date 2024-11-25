import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:foldit/controllers/titleProvider.dart';
import 'package:foldit/screens/folders/pages.dart';
import 'package:foldit/themes/app_theme.dart';
import 'package:foldit/themes/typography.dart';

import '../controllers/folder_Provider.dart';
import '../controllers/pagesProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final List<Color> cardColors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.grey,
    Colors.red.shade300,
  ];
  final date = DateFormat('dd MMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    Provider.of<FolderProvider>(context, listen: false).loadFolders();
  }

  // Create folder dialog
  void createFolder(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Create Folder', style: AppTextStyles.title),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  titleController.clear();
                },
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                style: AppTextStyles.dialogtitle,
                decoration: InputDecoration(
                  labelText: 'Eg: New Year',
                  labelStyle: AppTextStyles.subtitle,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final folderProvider =
                      Provider.of<FolderProvider>(context, listen: false);
                  folderProvider.addFolder(
                      titleController.text, "No Description", date);
                  Navigator.pop(context);
                  titleController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppCardTheme.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Create",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show exit confirmation dialog
  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Exit',
            style: AppTextStyles.title,
          ),
          content: Text(
            'Do you really want to exit?',
            style: AppTextStyles.subtitle,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCardTheme.lightRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "No",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCardTheme.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Yes",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    return shouldExit ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Folders", style: AppTextStyles.appbartitle),
          toolbarHeight: 80,
          backgroundColor: AppTheme.bgColor,
        ),
        body: Consumer<FolderProvider>(
          builder: (context, folderProvider, child) {
            final folders = folderProvider.folders;
            return Container(
              color: AppTheme.bgColor,
              child: folders.isEmpty
                  ? Center(
                      child: Text(
                        "No folders available.\nAdd a folder using the '+' button!",
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        final color = cardColors[index % cardColors.length];

                        return Dismissible(
                          key: Key('$index-${folder["title"]}'),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            Provider.of<FolderProvider>(context, listen: false)
                                .removeFolder(index);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("${folder["title"]} deleted"),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    // Add the folder back
                                    folderProvider.addFolder(folder["title"],
                                        "No Description", folder["date"]);
                                    final pagesProvider =
                                        Provider.of<PagesProvider>(context,
                                            listen: false);
                                    await pagesProvider.addImage(
                                        folder["imagePath"]!, folder["title"]!);
                                  },
                                ),
                              ),
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<TitleProvider>()
                                  .setTitle(folder["title"]!);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Pages()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: GridTile(
                                footer: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          folder["title"] ?? "No Title",
                                          style: AppTextStyles.cardTitle,
                                        ),
                                        Text(folder["date"] ?? "No Date",
                                            style: AppTextStyles.cardTitle),
                                      ],
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: folder["imagePath"] != null &&
                                          folder["imagePath"]!.isNotEmpty
                                      ? Image.file(
                                          File(folder["imagePath"]!),
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.folder,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => createFolder(context),
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.bgColor,
      ),
    );
  }
}
