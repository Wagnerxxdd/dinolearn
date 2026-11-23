import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/database/app_database.dart';
import 'data/repositories/atividade_repository.dart';
import 'routes/app_routes.dart';
import 'controllers/perfil_controller.dart';
import 'controllers/atividade_controller.dart';
import 'controllers/avatar_controller.dart';
import 'controllers/responsavel_controller.dart';
import 'controllers/relatorio_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados e insere dados iniciais
  await AppDatabase.instance.database;
  final atividadeRepo = AtividadeRepository();
  await atividadeRepo.seedInitialData();

  // Inicializa os controllers globais
  Get.put(PerfilController());
  Get.put(AtividadeController());
  Get.put(AvatarController());
  Get.put(ResponsavelController());
  Get.put(RelatorioController());

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DinoLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D5A58)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.pages,
    );
  }
}
