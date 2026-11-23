import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/perfil_controller.dart';
import '../routes/app_routes.dart';
import '../utils/app_constants.dart';
import 'home/widgets/profile_card.dart';
import 'home/widgets/add_profile_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PerfilController controller = Get.find<PerfilController>();

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: _buildAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildGreetings(),
              const SizedBox(height: 30),
              Expanded(
                child: _buildProfilesGrid(controller),
              ),
              const SizedBox(height: 20),
              _buildBottomAction(),
              const SizedBox(height: 16),
              _buildSafeAreaFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.face, color: AppConstants.primaryDark),
          const SizedBox(width: 8),
          const Text(
            'Aprender Brincando',
            style: TextStyle(
              color: AppConstants.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetings() {
    return Column(
      children: const [
        Text(
          'Olá! Quem vai brincar hoje?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Escolha seu perfil para começar a aventura.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilesGrid(PerfilController controller) {
    return Obx(() {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          childAspectRatio: 0.85,
        ),
        itemCount: controller.perfis.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.perfis.length) {
            return const AddProfileCard();
          }
          return ProfileCard(perfil: controller.perfis[index]);
        },
      );
    });
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton.icon(
        onPressed: () => Get.toNamed(AppRoutes.responsavelDashboard),
        icon: const Icon(Icons.settings, color: Colors.white, size: 20),
        label: const Text(
          'Painel do Responsável',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryDark,
          minimumSize: const Size(double.infinity, 56),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildSafeAreaFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.lock_outline, size: 14, color: Colors.grey),
        SizedBox(width: 4),
        Text(
          'Área Segura',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
