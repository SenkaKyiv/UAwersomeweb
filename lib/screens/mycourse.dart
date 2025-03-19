import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyCoursesScreen extends StatelessWidget {
  Future<void> _deleteCourse(BuildContext context, String courseId, Map<String, dynamic> courseData) async {
    bool confirmDelete = await _showDeleteDialog(context);
    if (!confirmDelete) return;

    try {
      // Видаляємо фото тренера та курсу
      if (courseData['trainerPhotoURL'] != null) {
        await FirebaseStorage.instance.refFromURL(courseData['trainerPhotoURL']).delete();
      }
      if (courseData['coursePhotoURL'] != null) {
        await FirebaseStorage.instance.refFromURL(courseData['coursePhotoURL']).delete();
      }

      // Видаляємо всі відео курсу
      if (courseData['trainingVideos'] != null) {
        for (var video in courseData['trainingVideos']) {
          if (video['videoURL'] != null) {
            await FirebaseStorage.instance.refFromURL(video['videoURL']!).delete();
          }
        }
      }

      // Видаляємо курс з Firestore
      await FirebaseFirestore.instance.collection('courses').doc(courseId).delete();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Курс успішно видалено!")));
    } catch (e) {
      print("❌ Помилка видалення курсу: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Помилка: $e")));
    }
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Підтвердження"),
        content: Text("Ви впевнені, що хочете видалити цей курс?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Скасувати"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Видалити", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Мої курси")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Помилка завантаження курсів"));
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return Center(child: Text("Немає жодного курсу"));

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(data['courseTitle'] ?? "Без назви"),
                  subtitle: Text("Тренер: ${data['trainerID']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCourse(context, doc.id, data),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
