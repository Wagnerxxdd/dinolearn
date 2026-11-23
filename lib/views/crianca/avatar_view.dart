import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/avatar_controller.dart';
import 'widgets/avatar_layered_display.dart';

class AvatarView extends StatefulWidget {
  const AvatarView({Key? key}) : super(key: key);

  @override
  State<AvatarView> createState() => _AvatarViewState();
}

class _AvatarViewState extends State<AvatarView> {
  final AvatarController controller = Get.find<AvatarController>();
  String selectedCategory = 'Bonés';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D5A58)),
          onPressed: () => Get.back(),
        ),
        title: const Text('Meu Avatar', style: TextStyle(color: Color(0xFF2D5A58), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const AvatarLayeredDisplay(size: 320),
          const SizedBox(height: 20),
          _buildCategorySelector(),
          const SizedBox(height: 10),
          Expanded(child: _buildItemsGrid()),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final cats = ['Bonés', 'Acessórios', 'Mochilas'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cats.map((cat) {
        bool isSelected = selectedCategory == cat;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (val) => setState(() => selectedCategory = cat),
            selectedColor: const Color(0xFFC7EFE5),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(color: isSelected ? const Color(0xFF2D5A58) : Colors.grey, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItemsGrid() {
    return Obx(() {
      final filteredItems = controller.allItems.where((i) => i.categoria == selectedCategory).toList();
      
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          bool isUnlocked = controller.isUnlocked(item.id!);
          bool isEquipped = controller.isEquipped(item.id!);
          
          return GestureDetector(
            onTap: isUnlocked ? () async {
              await controller.toggleEquipar(item);
            } : null,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isEquipped ? Border.all(color: const Color(0xFF34677E), width: 3) : null,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
              ),
              child: Stack(
                children: [
                  if (!isUnlocked) 
                    const Center(child: Icon(Icons.lock, color: Colors.grey, size: 30)),
                  
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_getCategoryIcon(item.categoria), size: 40, color: isUnlocked ? const Color(0xFF34677E) : Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Text(item.nome, style: TextStyle(fontWeight: FontWeight.bold, color: isUnlocked ? Colors.black87 : Colors.grey)),
                      ],
                    ),
                  ),
                  if (isEquipped)
                    const Positioned(top: 8, right: 8, child: Icon(Icons.check_circle, color: Color(0xFF34677E), size: 20)),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  IconData _getCategoryIcon(String cat) {
    if (cat == 'Bonés') return Icons.theater_comedy;
    if (cat == 'Mochilas') return Icons.backpack;
    return Icons.headset;
  }
}
