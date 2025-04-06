import 'package:flutter/material.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('National Helplines'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'In case of an emergency, call an appropriate number for help.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildHelplineCard(
                '112',
                'National Emergency Number',
                Colors.red,
              ),
              _buildHelplineCard('100', 'Police', Colors.blue),
              _buildHelplineCard('101', 'Fire Service', Colors.orange),
              _buildHelplineCard('102', 'Ambulance', Colors.green),
              _buildHelplineCard('108', 'Disaster Management', Colors.purple),
              _buildHelplineCard('1091', 'Women Helpline', Colors.pink),
              _buildHelplineCard('1098', 'Child Helpline', Colors.amber),
              _buildHelplineCard('104', 'Health Helpline', Colors.teal),
              _buildHelplineCard(
                '1075',
                'COVID-19 Helpline',
                Colors.deepOrange,
              ),
              _buildHelplineCard(
                '1800-599-0019',
                'Mental Health Helpline',
                Colors.indigo,
              ),
              _buildHelplineCard(
                '1800-425-3800',
                'Senior Citizen Helpline',
                Colors.brown,
              ),
              _buildHelplineCard(
                '1800-222-222',
                'Drug Abuse Helpline',
                Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelplineCard(String number, String description, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            number.split('-')[0], // Show only first part for long numbers
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          number,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.call),
          color: Colors.black,
          onPressed: () {
            // Implement call functionality
          },
        ),
      ),
    );
  }
}
