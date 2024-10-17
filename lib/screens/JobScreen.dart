import 'package:flutter/material.dart';
import 'JobApplyScreen.dart';

// Define the job model
class Job {
  final String companyName;
  final String role;
  final List<String> responsibilities;
  final String salary;
  final String stipend;

  Job({
    required this.companyName,
    required this.role,
    required this.responsibilities,
    required this.salary,
    required this.stipend,
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
    stipend: '6,000 USD ',
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
    stipend: '7,000 USD ',
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
  ),
  Job(
    companyName: 'SoftWeb Technologies',
    role: 'Backend Developer',
    responsibilities: [
      'Develop and maintain server-side logic',
      'Ensure data security and integrity',
      'Collaborate with frontend and DevOps teams',
    ],
    salary: '65,000 USD per year',
    stipend: '6,500 USD ',
  ),
  Job(
    companyName: 'CyberTech Security',
    role: 'Cybersecurity Engineer',
    responsibilities: [
      'Develop and implement security measures',
      'Monitor and respond to security breaches',
      'Perform regular security audits and tests',
    ],
    salary: '95,000 USD per year',
    stipend: '9,500 USD ',
  ),
  Job(
    companyName: 'DataStream Networks',
    role: 'Network Engineer',
    responsibilities: [
      'Design and implement network infrastructure',
      'Troubleshoot network issues and optimize performance',
      'Ensure network security and connectivity',
    ],
    salary: '75,000 USD per year',
    stipend: '7,500 USD ',
  ),
  Job(
    companyName: 'Quantum Computing Inc.',
    role: 'Embedded Systems Engineer',
    responsibilities: [
      'Design and develop embedded systems for various devices',
      'Optimize system performance and power usage',
      'Work closely with hardware and software teams',
    ],
    salary: '90,000 USD per year',
    stipend: '9,000 USD ',
  ),
  Job(
    companyName: 'GreenTech Innovations',
    role: 'Cloud Engineer',
    responsibilities: [
      'Deploy and manage cloud-based applications',
      'Ensure system reliability and scalability',
      'Work with cloud providers like AWS, Azure, or GCP',
    ],
    salary: '80,000 USD per year',
    stipend: '8,000 USD ',
  ),
  Job(
    companyName: 'Innovative AI Solutions',
    role: 'Machine Learning Engineer',
    responsibilities: [
      'Develop and implement machine learning algorithms',
      'Work on AI-driven solutions',
      'Collaborate with data scientists and engineers',
    ],
    salary: '100,000 USD per year',
    stipend: '10,000 USD',
  ),
  Job(
    companyName: 'NeoSoft Technologies',
    role: 'Computer Vision Engineer',
    responsibilities: [
      'Develop computer vision models for image processing tasks',
      'Work on autonomous systems and AI projects',
      'Collaborate with research and product teams',
    ],
    salary: '110,000 USD per year',
    stipend: '11,000 USD',
  ),
  Job(
    companyName: 'NextGen Robotics',
    role: 'Robotics Engineer',
    responsibilities: [
      'Design and develop robotic systems',
      'Work on automation solutions and autonomous systems',
      'Collaborate with software and hardware teams',
    ],
    salary: '95,000 USD per year',
    stipend: '9,500 USD',
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
          return GestureDetector(
            onTap: () {
              // Navigate to job apply screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobApplyScreen(job: job),
                ),
              );
            },
            child: Hero(
              tag: job.companyName,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white, // Change background to white
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black.withOpacity(0.5)), // Black border
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
                        ElevatedButton(
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
                            backgroundColor: Colors.lightBlue, // Sky blue button
                            foregroundColor: Colors.white, // White button text
                          ),
                          child: Text('Apply Now'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
