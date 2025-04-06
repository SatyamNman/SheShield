import 'package:flutter/material.dart';
import 'package:sheshield/sections/homepage.dart';

class AdditionalInfoPage2 extends StatefulWidget {
  const AdditionalInfoPage2({super.key});

  @override
  State<AdditionalInfoPage2> createState() => _AdditionalInfoPage2State();
}

class _AdditionalInfoPage2State extends State<AdditionalInfoPage2> {
  List<Map<String, TextEditingController>> frequentPlaces = [];

  void _addNewPlace() {
    if (frequentPlaces.isEmpty || _validateInputs()) {
      setState(() {
        frequentPlaces.add({
          "place": TextEditingController(),
          "address": TextEditingController(),
        });
      });
    }
  }

  bool _validateInputs() {
    if (frequentPlaces.isEmpty) return true;
    return frequentPlaces.last["place"]!.text.isNotEmpty && frequentPlaces.last["address"]!.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Frequent Places",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: frequentPlaces.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("Place Name", frequentPlaces[index]["place"]!),
                      const SizedBox(height: 15),
                      _buildTextField("Address", frequentPlaces[index]["address"]!),
                      const SizedBox(height: 25),
                    ],
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _addNewPlace,
                child: const Text(
                  "Add New Place",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 75,
        child: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
