import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'view_paste.dart';
import 'package:flutter/services.dart';

class CreatePasteScreen extends StatefulWidget {
  const CreatePasteScreen({super.key});

  @override
  State<CreatePasteScreen> createState() => _CreatePasteScreenState();
}

class _CreatePasteScreenState extends State<CreatePasteScreen> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();
  final TextEditingController viewsController = TextEditingController();

  String? generatedUrl;
  String? pasteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌄 Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Dark overlay
          Container(color: Colors.black.withOpacity(0.6)),

          /// Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.white.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Pastebin Lite",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Paste Content
                      TextField(
                        controller: contentController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: "Paste Content",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// TTL
                      TextField(
                        controller: ttlController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Expire Time (seconds)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Max Views
                      TextField(
                        controller: viewsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Max Views",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Create Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final result = await ApiService.createPaste(
                            contentController.text,
                            ttlController.text.isEmpty
                                ? null
                                : int.parse(ttlController.text),
                            viewsController.text.isEmpty
                                ? null
                                : int.parse(viewsController.text),
                          );

                          setState(() {
                            generatedUrl = result['url'];
                            pasteId = result['id'];
                          });
                        },
                        child: const Text(
                          "Create Paste",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      /// Result
                      if (generatedUrl != null && pasteId != null) ...[
                        const SizedBox(height: 16),

                        SelectableText(
                          generatedUrl!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// Copy Button
                        TextButton.icon(
                          icon: const Icon(Icons.copy),
                          label: const Text("Copy URL"),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: generatedUrl!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("URL Copied")),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        /// View Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ViewPasteScreen(pasteId: pasteId!),
                              ),
                            );
                          },
                          child: const Text("View Paste"),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

