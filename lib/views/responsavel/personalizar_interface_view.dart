import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/perfil_controller.dart';
import '../../utils/app_constants.dart';
import '../perfil_form/widgets/form_section.dart';

class PersonalizarInterfaceView extends StatefulWidget {
  const PersonalizarInterfaceView({super.key});

  @override
  State<PersonalizarInterfaceView> createState() => _PersonalizarInterfaceViewState();
}

class _PersonalizarInterfaceViewState extends State<PersonalizarInterfaceView> {
  final PerfilController controller = Get.find<PerfilController>();

  late bool _somAtivado;
  late double _velocidade;
  late String _cor;

  @override
  void initState() {
    super.initState();
    final p = controller.perfilSelecionado.value!;
    _somAtivado = p.somAtivado ?? true;
    _velocidade = double.tryParse(p.velocidadeAnimacao ?? '1.0') ?? 1.0;
    _cor = p.corPreferida ?? 'Azul Bebê';
  }

  @override
  Widget build(BuildContext context) {
    final perfil = controller.perfilSelecionado.value!;

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Text('Personalizar Interface', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppConstants.primaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInfoCard(perfil.nome),
            const SizedBox(height: 24),
            
            FormSection(
              title: 'Preferências de Som',
              subtitle: 'Ative ou desative efeitos sonoros e instruções.',
              child: SwitchListTile(
                title: const Text('Efeitos de Som e Áudio', style: TextStyle(fontWeight: FontWeight.w600)),
                value: _somAtivado,
                onChanged: (val) => setState(() => _somAtivado = val),
                activeTrackColor: AppConstants.primaryDark,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            
            const SizedBox(height: 16),
            
            FormSection(
              title: 'Velocidade das Animações',
              subtitle: 'Ajuste o tempo de resposta visual das atividades.',
              child: Column(
                children: [
                  Slider(
                    value: _velocidade,
                    min: 0.5,
                    max: 2.0,
                    divisions: 2,
                    label: _velocidade == 0.5 ? 'Lenta' : (_velocidade == 1.0 ? 'Normal' : 'Rápida'),
                    onChanged: (v) => setState(() => _velocidade = v),
                    activeColor: AppConstants.primaryDark,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mais Lenta', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Normal', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Mais Rápida', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            FormSection(
              title: 'Preferência Visual',
              subtitle: 'Escolha a cor base da interface da criança.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: AppConstants.coresSuaves.entries.map((entry) {
                  bool isSelected = _cor == entry.key;
                  return GestureDetector(
                    onTap: () => setState(() => _cor = entry.key),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: AppConstants.primaryDark, width: 3) : null,
                        boxShadow: isSelected ? [BoxShadow(color: entry.value, blurRadius: 10)] : [],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 40),
            
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : _salvar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryDark,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: controller.isLoading.value 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Salvar Alterações', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String nome) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.tune, color: AppConstants.primaryDark),
          const SizedBox(width: 12),
          Text('Perfil: $nome', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _salvar() async {
    final perfil = controller.perfilSelecionado.value!;
    
    await controller.atualizarPerfil(
      id: perfil.id!,
      nome: perfil.nome,
      idade: perfil.idade,
      idAvatar: perfil.idAvatar,
      preferenciaCor: _cor,
      temEfeitosSom: _somAtivado,
      velocidadeAnimacao: _velocidade,
      focosAprendizado: perfil.focosAprendizado,
    );

    Get.snackbar(
      'Sucesso', 
      'Preferências salvas com sucesso.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal.shade50,
    );
  }
}
