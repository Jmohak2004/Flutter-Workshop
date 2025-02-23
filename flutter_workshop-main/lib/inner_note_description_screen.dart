import 'package:flutter_workshop/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class InnerNoteDescriptionScreen extends StatefulWidget {
  const InnerNoteDescriptionScreen({super.key});

  @override
  State<InnerNoteDescriptionScreen> createState() =>
      _InnerNoteDescriptionScreenState();
}

class _InnerNoteDescriptionScreenState extends State<InnerNoteDescriptionScreen> {
  // Firestore service
  final FirestoreService firestoreService = FirestoreService();

  // Controllers for title and note
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();


  late final GenerativeModel model;

  @override
  void initState() {
    super.initState();
    const apiKey = 'your-api-key';
      model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
  }

  // Function to generate title using Gemini
  Future<String> generateTitle(String content) async {
    try {
      final prompt = [
        Content.text('Generate a short title (maximum 3 words) for this note: $content')
      ];
      final response = await model.generateContent(prompt);
      return response.text?.trim() ?? 'Untitled Note';
    } catch (e) {
      print('Error generating title: $e');
      return 'Untitled Note';
    }
  }


  
  void handleAddNote() async { 
    
      
    // If title is empty, generate one using the note content
    if (titleController.text.isEmpty && noteController.text.isNotEmpty) {
      String generatedTitle = await generateTitle(noteController.text);
      titleController.text = generatedTitle;
    }


    if(!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Do you want to save this note?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              firestoreService.addNote(
                titleController.text.trim(),
                noteController.text.trim(),
              );
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close InnerNoteDescriptionScreen
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
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
          controller: titleController,
          decoration: const InputDecoration(
            hintText: "Enter Title",
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white54,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: handleAddNote,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: noteController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: "Enter Note",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
