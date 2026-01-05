import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ViewPasteScreen extends StatefulWidget {
  final String pasteId;

  const ViewPasteScreen({super.key, required this.pasteId});

  @override
  State<ViewPasteScreen> createState() => _ViewPasteScreenState();
}

class _ViewPasteScreenState extends State<ViewPasteScreen> {
  String? content;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadPaste();
  }

  Future<void> loadPaste() async {
    try {
      final result = await ApiService.getPaste(widget.pasteId);

      setState(() {
        content = result['content']; // ✅ FIX HERE
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = "Paste expired or not found";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Paste")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : error != null
                ? Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText( // ✅ copy possible
                      content ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
      ),
    );
  }
}
