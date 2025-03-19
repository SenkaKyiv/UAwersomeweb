import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final ImagePicker _picker = ImagePicker();

  String trainerName = "";
  String? trainerPhotoURL;
  String courseTitle = "";
  String courseDescription = "";
  String? coursePhotoURL;
  bool isUploading = false;

  Map<String, List<Map<String, String>>> exercises = {
    "Понеділок": [],
    "Вівторок": [],
    "Середа": [],
    "Четвер": [],
    "П’ятниця": [],
    "Субота": [],
    "Неділя": []
  };

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  Future<void> _pickImage(Function(String?) callback) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String? url = await _uploadFile(pickedFile, pickedFile.name);
      setState(() {
        callback(url);
      });
    }
  }

  Future<void> _pickVideo(String dayOfWeek) async {
    if (exercises[dayOfWeek]!.length >= 40) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Максимум 40 вправ на курс!")));
      return;
    }

    final TextEditingController descriptionController = TextEditingController();
    bool confirmed = await _showExerciseDialog(context, descriptionController);
    if (!confirmed) return;

    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      String? url = await _uploadFile(pickedFile, pickedFile.name, isVideo: true);
      if (url != null) {
        setState(() {
          exercises[dayOfWeek]!.add({
            'exerciseNumber': (exercises[dayOfWeek]!.length + 1).toString(),
            'description': descriptionController.text,
            'videoURL': url,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Відео завантажено!")));
      }
    }
  }

  Future<String?> _uploadFile(XFile file, String fileName, {bool isVideo = false}) async {
    setState(() => isUploading = true);
    try {
      Reference storageRef = FirebaseStorage.instance.ref("courses/${user?.uid}/$fileName");
      UploadTask uploadTask = kIsWeb
          ? storageRef.putData(await file.readAsBytes())
          : storageRef.putFile(XFile(file.path) as dynamic);

      await uploadTask;
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("❌ Помилка завантаження: $e");
      return null;
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> _saveCourse() async {
    if (trainerName.isEmpty || trainerPhotoURL == null || courseTitle.isEmpty || courseDescription.isEmpty || coursePhotoURL == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❗ Заповніть всі поля")));
      return;
    }

    Map<String, dynamic> courseData = {
      'trainerID': user?.uid,
      'trainerName': trainerName,
      'trainerPhotoURL': trainerPhotoURL,
      'courseTitle': courseTitle,
      'courseDescription': courseDescription,
      'coursePhotoURL': coursePhotoURL,
      'exercises': exercises,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('courses').add(courseData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("✅ Курс збережено! ID: ${docRef.id}"),
        backgroundColor: Colors.green,
      ));

      print("🔥 Курс успішно додано в Firestore з ID: ${docRef.id}");
    } catch (e) {
      print("❌ Помилка запису в Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("❌ Помилка збереження курсу: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<bool> _showExerciseDialog(BuildContext context, TextEditingController descriptionController) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Додати опис вправи"),
        content: TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: "Опис вправи"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Скасувати"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Додати"),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Додати курс")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Ім'я тренера"),
              onChanged: (value) => setState(() => trainerName = value),
            ),
            SizedBox(height: 40),
            ElevatedButton(onPressed: () => _pickImage((url) => trainerPhotoURL = url), child: Text("Фото тренера")),
            SizedBox(height: 40),
            ElevatedButton(onPressed: () => _pickImage((url) => coursePhotoURL = url), child: Text("Фото курсу")),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(labelText: "Назва курсу"),
              onChanged: (value) => setState(() => courseTitle = value),
            ),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(labelText: "Опис курсу"),
              onChanged: (value) => setState(() => courseDescription = value),
            ),
            SizedBox(height: 40),

            ...exercises.keys.map((day) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(day, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _pickVideo(day),
                    child: Text("Додати відео для $day"),
                  ),
                  SizedBox(height: 40),
                  ...exercises[day]!.map((exercise) => ListTile(
                    title: Text("Вправа ${exercise['exerciseNumber']}"),
                    subtitle: Text(exercise['description']!),
                  )),
                ],
              );
            }).toList(),

            if (isUploading) CircularProgressIndicator(),
            SizedBox(height: 40),
            ElevatedButton(onPressed: _saveCourse, child: Text("Зберегти курс")),
          ],
        ),
      ),
    );
  }
}
