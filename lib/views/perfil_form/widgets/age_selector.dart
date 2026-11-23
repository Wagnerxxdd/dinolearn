import 'package:flutter/material.dart';

class AgeSelector extends StatelessWidget {
  final int selectedAge;
  final Function(int) onAgeSelected;

  const AgeSelector({
    Key? key,
    required this.selectedAge,
    required this.onAgeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [7, 8, 9, 10].map((idade) {
        bool isSelected = selectedAge == idade;
        return GestureDetector(
          onTap: () => onAgeSelected(idade),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade300 : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                idade.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
