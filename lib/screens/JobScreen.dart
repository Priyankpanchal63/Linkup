import 'package:flutter/material.dart';
import 'JobApplyScreen.dart';

// Define the job model
class Job {
  final String companyName;
  final String role;
  final List<String> responsibilities;
  final String salary;
  final String stipend;
  final String location;
  final String phoneNumber;

  Job({
    required this.companyName,
    required this.role,
    required this.responsibilities,
    required this.salary,
    required this.stipend,
    required this.location,
    required this.phoneNumber, // Initialize phone number
  });
}

// Job data
List<Job> jobs = [
  Job(
    companyName: 'Tech Innovations',
    role: 'Software Developer',
    responsibilities: [
      'Develop and maintain mobile applications',
      'Collaborate with UI/UX designers',
      'Write clean, maintainable code',
    ],
    salary: '60,000 USD per year',
    stipend: '6,000 USD',
    location: 'San Francisco, CA, USA',
    phoneNumber: '(415) 555-1234',
  ),
  Job(
    companyName: 'ByteWorks Solutions',
    role: 'Full Stack Engineer',
    responsibilities: [
      'Design and implement backend and frontend solutions',
      'Maintain databases and APIs',
      'Collaborate with frontend developers',
    ],
    salary: '70,000 USD per year',
    stipend: '7,000 USD',
    location: 'Austin, TX, USA',
    phoneNumber: '(512) 555-5678',
  ),
  Job(
    companyName: 'InfoTech Solutions',
    role: 'DevOps Engineer',
    responsibilities: [
      'Automate and manage cloud infrastructure',
      'Ensure CI/CD pipelines are effective',
      'Monitor system performance and uptime',
    ],
    salary: '85,000 USD per year',
    stipend: '8,500 USD',
    location: 'New York, NY, USA',
    phoneNumber: '(212) 555-7890',
  ),
  Job(
    companyName: 'BlueSky Technologies',
    role: 'Cloud Solutions Architect',
    responsibilities: [
      'Design cloud infrastructure for large-scale projects',
      'Implement and optimize cloud solutions',
      'Collaborate with IT teams for system integration',
    ],
    salary: '100,000 USD per year',
    stipend: '10,000 USD',
    location: 'Seattle, WA, USA',
    phoneNumber: '(206) 555-3456',
  ),
  Job(
    companyName: 'QuantumLogic',
    role: 'Data Scientist',
    responsibilities: [
      'Analyze large datasets to drive business insights',
      'Develop predictive models',
      'Collaborate with engineering and product teams',
    ],
    salary: '95,000 USD per year',
    stipend: '9,500 USD',
    location: 'Chicago, IL, USA',
    phoneNumber: '(312) 555-6543',
  ),
];

// JobScreen widget that displays job listings
class JobScreen extends StatelessWidget {
  const JobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Jobs', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return TweenAnimationBuilder(
            duration: const Duration(milliseconds: 500),
            tween: ColorTween(begin: Colors.white, end: Colors.lightBlue.shade50),
            builder: (context, color, child) {
              return Hero(
                tag: job.companyName,
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color as Color, // Animate between colors
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.lightBlue), // Sky blue border
                  ),
                  child: Card(
                    color: Colors.transparent, // Make the card transparent
                    elevation: 5, // Slight elevation for shadow effect
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.companyName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Role: ${job.role}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Location: ${job.location}', // Location field
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Salary: ${job.salary}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Stipend: ${job.stipend}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Responsibilities:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          for (var responsibility in job.responsibilities)
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                '- $responsibility',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          SizedBox(height: 10),
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 500),
                            tween: ColorTween(
                              begin: Colors.lightBlue,
                              end: Colors.lightBlue.shade300,
                            ),
                            builder: (context, color, child) {
                              return ElevatedButton(
                                onPressed: () {
                                  // Navigate to the job application page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobApplyScreen(job: job),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color as Color, // Animated button color
                                  foregroundColor: Colors.white, // White button text
                                ),
                                child: Text('Apply Now'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
