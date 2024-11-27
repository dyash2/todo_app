import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:foldit/themes/app_theme.dart';
import 'package:foldit/themes/typography.dart';
import '../../controllers/pagesProvider.dart';
import '../../controllers/titleProvider.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  final ImagePicker _picker = ImagePicker();
  late List<TextEditingController> _controllers;
  late TextEditingController appbarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllers = [];
    context.read<PagesProvider>().loadImages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final images = context.read<PagesProvider>().images;

    if (_controllers.length != images.length) {
      _controllers = List.generate(
        images.length,
        (index) => TextEditingController(text: images[index]['title']),
      );
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      context.read<PagesProvider>().addImage(pickedImage.path, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = context.watch<PagesProvider>().images;
    final appBartitle = context.watch<TitleProvider>().title;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        title: Text(appBartitle, style: AppTextStyles.appbartitle),
        actions: [
          IconButton(
            onPressed: () => _pickImage(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        color: AppTheme.bgColor,
        child: Consumer<PagesProvider>(builder: (context, watch, _) {
          return watch.images.isEmpty
              ? Center(
                  child: Text(
                    "No images available.",
                    style: AppTextStyles.subtitle,
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: watch.images.length,
                  itemBuilder: (context, index) {
                    final image = watch.images[index];
                    final tag = 'folder-${image["title"] ?? index}';

                    return Dismissible(
                      key: ValueKey(image.entries.first.value),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        context.read<PagesProvider>().removeImage(index);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     backgroundColor: Colors.red,
                        //     content: Text("${image["title"]} deleted"),
                        //   ),
                        // );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Hero(
                        tag: tag,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.file(
                                File(image['path']!),
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _controllers[index],
                                decoration: InputDecoration(
                                  hintText: 'Enter title here',
                                  hintStyle: AppTextStyles.subtitle,
                                  border: InputBorder.none,
                                ),
                                style: AppTextStyles.title,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  context
                                      .read<PagesProvider>()
                                      .updateImageTitle(index, value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) async {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }

                    await context
                        .read<PagesProvider>()
                        .moveImage(oldIndex, newIndex);

                    setState(() {
                      final movedController = _controllers.removeAt(oldIndex);
                      _controllers.insert(newIndex, movedController);
                    });
                  },
                );
        }),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
