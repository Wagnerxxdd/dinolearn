import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/perfil_controller.dart';
import '../models/perfil.dart';
import '../utils/app_constants.dart';
import 'perfil_form/widgets/form_section.dart';
import 'perfil_form/widgets/age_selector.dart';

class PerfilFormView extends StatefulWidget {
  final bool modoEdicao;
  const PerfilFormView({Key? key, this.modoEdicao = false}) : super(key: key);

  @override
  State<PerfilFormView> createState() => _PerfilFormViewState();
}

class _PerfilFormViewState extends State<PerfilFormView> {
  final PerfilController controller = Get.find<PerfilController>();
  final _nomeController = TextEditingController();

  int _idadeSelecionada = 9;
  int _idAvatarSelecionado = 1; // 1 para Menino, 2 para Menina
  String _corSelecionada = 'Azul Bebê';
  bool _temEfeitosSom = true;
  double _velocidadeAnimacao = 1.0;
  List<String> _focosSelecionados = ['Português'];

  @override
  void initState() {
    super.initState();
    if (widget.modoEdicao && controller.perfilSelecionado.value != null) {
      final Perfil p = controller.perfilSelecionado.value!;
      _nomeController.text = p.nome;
      _idadeSelecionada = p.idade;
      _idAvatarSelecionado = p.idAvatar;
      _corSelecionada = p.corPreferida ?? 'Azul Bebê';
      _temEfeitosSom = p.somAtivado == true || p.somAtivado == null;
      _velocidadeAnimacao = double.tryParse(p.velocidadeAnimacao.toString()) ?? 1.0;
      _focosSelecionados = List<String>.from(p.focosAprendizado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildAvatarBaseSelection(),
            const SizedBox(height: 24),
            _buildNameSection(),
            const SizedBox(height: 16),
            _buildAgeSection(),
            const SizedBox(height: 16),
            _buildColorSection(),
            const SizedBox(height: 16),
            _buildSettingsSection(),
            const SizedBox(height: 16),
            _buildFocusSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppConstants.primaryDark),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Aprender Brincando',
        style: TextStyle(color: AppConstants.primaryDark, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
          child: const Icon(Icons.face, size: 40, color: AppConstants.primaryDark),
        ),
        const SizedBox(height: 16),
        Text(widget.modoEdicao ? 'Editar Perfil' : 'Configurar Perfil', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('Personalize a experiência para a criança', style: TextStyle(fontSize: 16, color: Colors.black54)),
      ],
    );
  }

  Widget _buildAvatarBaseSelection() {
    return FormSection(
      title: 'Quem vai brincar?',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _avatarOption(1, 'Menino', 'assets/images/avatars/base_menino.png'),
          _avatarOption(2, 'Menina', 'assets/images/avatars/base_menina.png'),
        ],
      ),
    );
  }

  Widget _avatarOption(int id, String label, String path) {
    bool isSelected = _idAvatarSelecionado == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _idAvatarSelecionado = id;
        });
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppConstants.primaryDark : Colors.transparent,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: Image.asset(path, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildNameSection() {
    return FormSection(
      title: 'Nome da criança',
      child: TextField(
        controller: _nomeController,
        decoration: InputDecoration(
          hintText: 'Como devemos chamar?',
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildAgeSection() {
    return FormSection(
      title: 'Idade',
      child: AgeSelector(
        selectedAge: _idadeSelecionada,
        onAgeSelected: (idade) => setState(() => _idadeSelecionada = idade),
      ),
    );
  }

  Widget _buildColorSection() {
    return FormSection(
      title: 'Cor preferida (Tons Suaves)',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: AppConstants.coresSuaves.entries.map((entry) {
          bool isSelected = _corSelecionada == entry.key;
          return GestureDetector(
            onTap: () => setState(() => _corSelecionada = entry.key),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: entry.value,
                shape: BoxShape.circle,
                border: isSelected ? Border.all(color: AppConstants.primaryDark, width: 3) : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return FormSection(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.volume_up, color: AppConstants.primaryDark),
                  SizedBox(width: 8),
                  Text('Efeitos de Som', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Switch(
                value: _temEfeitosSom,
                onChanged: (v) => setState(() => _temEfeitosSom = v),
                activeTrackColor: AppConstants.primaryDark,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.speed, color: AppConstants.primaryDark),
              SizedBox(width: 8),
              Text('Velocidade das Animações', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _velocidadeAnimacao,
            min: 0.5,
            max: 2.0,
            divisions: 2,
            label: _velocidadeAnimacao == 0.5 ? 'Lenta' : (_velocidadeAnimacao == 1.0 ? 'Normal' : 'Rápida'),
            onChanged: (v) => setState(() => _velocidadeAnimacao = v),
            activeColor: AppConstants.primaryDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFocusSection() {
    return FormSection(
      title: 'Foco de Aprendizado',
      subtitle: 'Selecione onde a criança precisa de mais apoio:',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: AppConstants.focosAprendizado.map((foco) {
          bool isSelected = _focosSelecionados.contains(foco);
          return FilterChip(
            label: Text(foco),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _focosSelecionados.add(foco);
                } else {
                  _focosSelecionados.remove(foco);
                }
              });
            },
            selectedColor: Colors.teal.shade100,
            checkmarkColor: Colors.teal.shade900,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => ElevatedButton.icon(
      onPressed: controller.isLoading.value ? null : _salvar,
      icon: controller.isLoading.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.save, color: Colors.white),
      label: Text(controller.isLoading.value ? 'Salvando...' : 'Salvar Perfil', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryDark, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    ));
  }

  void _salvar() {
    if (_nomeController.text.isEmpty) {
      Get.snackbar('Erro', 'Por favor, insira o nome da criança');
      return;
    }

    if (widget.modoEdicao) {
      controller.atualizarPerfil(
        id: controller.perfilSelecionado.value!.id!,
        nome: _nomeController.text,
        idade: _idadeSelecionada,
        idAvatar: _idAvatarSelecionado,
        preferenciaCor: _corSelecionada,
        temEfeitosSom: _temEfeitosSom,
        velocidadeAnimacao: _velocidadeAnimacao,
        focosAprendizado: _focosSelecionados,
      );
    } else {
      controller.criarPerfil(
        nome: _nomeController.text,
        idade: _idadeSelecionada,
        idAvatar: _idAvatarSelecionado,
        preferenciaCor: _corSelecionada,
        temEfeitosSom: _temEfeitosSom,
        velocidadeAnimacao: _velocidadeAnimacao,
        focosAprendizado: _focosSelecionados,
      );
    }
  }
}
