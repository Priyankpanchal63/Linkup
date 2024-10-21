import 'package:flutter/material.dart';

class JobDetailScreen extends StatelessWidget {
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String jobDescription;
  final String pdfUrl;

  const JobDetailScreen({
    Key? key,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.jobDescription,
    required this.pdfUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your code for displaying job details
    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: $companyName', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Job Description: $jobDescription', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            // If you are displaying PDF or job description link:
            pdfUrl.isNotEmpty ? Text('PDF URL: $pdfUrl') : Container(),
          ],
        ),
      ),
    );
  }
}