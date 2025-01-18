import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lab_report/user/result_screen.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false; // Track loading state
  final ImagePicker _picker = ImagePicker();

  Future<void> uploadFile() async {
    // Pick the image
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // You can also use ImageSource.camera
    );

    if (pickedFile != null) {
      try {
        setState(() {
          _isLoading = true; // Start loading
        });

        // Read the file as bytes
        final fileBytes = await File(pickedFile.path).readAsBytes();

        print('iiiiiiiiiiiii');
        print(fileBytes);


        

        // Prepare the multipart request
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://772b-117-243-210-133.ngrok-free.app/upload'),
        );

        // Add file as bytes
        request.files.add(
          http.MultipartFile.fromBytes(
            'file', // Field name expected by the API
            fileBytes,
            filename: pickedFile.name, // Optional: Specify a filename
  // Change content type if needed
          ),
        );

        // Send the request
        var response = await request.send();

        setState(() {
          _isLoading = false; // Stop loading
        });

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final parsedData = json.decode(responseData);

          print(parsedData);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(resultData: parsedData),
            ),
          );
        } else {
          _showErrorDialog("Failed to upload file. Please try again.");
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Stop loading on error
        });
        print(e);
        _showErrorDialog("Exception during file upload: $e");
      }
    } else {
      // Show warning if no file is selected
      _showErrorDialog("No file selected. Please choose a valid image.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main UI
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Header Text
                Text(
                  'Your Health Matters',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Lottie Animation
                Expanded(
                  child: Lottie.asset('asset/homeani.json'), // Replace with your animation
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Note*: only png or jpg file upload',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Upload Report Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: uploadFile,
                    icon: const Icon(Icons.upload_file, color: Colors.white),
                    label: const Text(
                      'Upload Report',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
