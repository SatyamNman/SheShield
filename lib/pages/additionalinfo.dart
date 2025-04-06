import 'package:flutter/material.dart';
import 'package:sheshield/pages/additionalinfo2.dart';
import 'package:sheshield/sections/homepage.dart';

class AdditionalInfoPage extends StatefulWidget {
  const AdditionalInfoPage({super.key});

  @override
  State<AdditionalInfoPage> createState() => _AdditionalInfoPageState();
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController parentsContactController =
      TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  String? selectedOccupation;
  List<String> selectedSafetyConcerns = [];
  List<String> occupations = [
    "Student",
    "Working Professional",
    "Homemaker",
    "Other",
  ];
  List<String> safetyConcerns = [
    "Harassment",
    "Stalking",
    "Domestic Violence",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F2F1),
              Color(0xFFE0E7FF),
            ], // Gradient like in signup page
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40), // Added space at the top
                  const Text(
                    "Tell Us More",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Contact Details",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    "Phone Number",
                    phoneNumberController,
                    isNumber: true,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    "Parents' Contact Number",
                    parentsContactController,
                    isNumber: true,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Address",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField("Address Line 1", addressLine1Controller),
                  const SizedBox(height: 15),
                  _buildTextField("Address Line 2", addressLine2Controller),
                  const SizedBox(height: 15),
                  _buildTextField("City, State", cityController),
                  const SizedBox(height: 15),
                  _buildSelectableOptions("Occupation", occupations, (value) {
                    setState(() {
                      selectedOccupation = value;
                    });
                  }, selectedOccupation),
                  const SizedBox(height: 40),
                  _buildMultiSelectableOptions(
                    "Primary Safety Concern",
                    safetyConcerns,
                    (value) {
                      setState(() {
                        if (selectedSafetyConcerns.contains(value)) {
                          selectedSafetyConcerns.remove(value);
                        } else {
                          selectedSafetyConcerns.add(value);
                        }
                      });
                    },
                    selectedSafetyConcerns,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 65),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 75,
        child: TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            labelText:
                label == "Phone Number" ? "Enter your Phone Number" : label,
            labelStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 22,
              horizontal: 16,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableOptions(
    String title,
    List<String> options,
    Function(String) onSelected,
    String? selectedValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 15,
          children:
              options.map((option) {
                bool isSelected = option == selectedValue;
                return GestureDetector(
                  onTap: () => onSelected(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildMultiSelectableOptions(
    String title,
    List<String> options,
    Function(String) onSelected,
    List<String> selectedValues,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 15,
          children:
              options.map((option) {
                bool isSelected = selectedValues.contains(option);
                return GestureDetector(
                  onTap: () => onSelected(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
