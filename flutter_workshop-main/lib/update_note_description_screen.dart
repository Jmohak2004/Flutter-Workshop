import 'package:flutter/material.dart';
import 'package:flutter_workshop/services/firestore.dart';

class UpdateNoteDescription extends StatefulWidget {
  final String docId;
  final String title;
  final String content;

  const UpdateNoteDescription({
    super.key,
    required this.docId,
    required this.title,
    required this.content,
  });

  @override
  State<UpdateNoteDescription> createState() => _UpdateNoteDescriptionState();
}

class _UpdateNoteDescriptionState extends State<UpdateNoteDescription> {
  final FirestoreService firestoreService = FirestoreService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  

  void updateNote() async {
    
    try {
      await firestoreService.updateNote(
        widget.docId,
        _titleController.text,
        _contentController.text,
      );

      if(!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: updateNote, // Calls updateNote function
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
