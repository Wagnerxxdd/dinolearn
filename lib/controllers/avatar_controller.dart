import 'package:get/get.dart';
import '../models/item_avatar.dart';
import '../data/repositories/avatar_repository.dart';
import 'perfil_controller.dart';

class AvatarController extends GetxController {
  final AvatarRepository _repository = AvatarRepository();

  final RxList<ItemAvatar> allItems = <ItemAvatar>[].obs;
  final RxList<ItemAvatar> unlockedItems = <ItemAvatar>[].obs;
  final RxList<ItemAvatar> equippedItems = <ItemAvatar>[].obs;
  final RxString currentAvatarDisplayPath =
      'assets/images/avatars/base_menino.png'.obs;

  @override
  void onInit() {
    super.onInit();
    ever(
      Get.find<PerfilController>().perfilSelecionado,
          (_) => loadAvatarData(),
    );
    loadAvatarData();
  }

  Future<void> loadAvatarData() async {
    try {
      final perfil = Get.find<PerfilController>().perfilSelecionado.value;

      final items = await _repository.getAllItems();
      allItems.assignAll(items);

      if (perfil == null) {
        equippedItems.clear();
        unlockedItems.clear();
        return;
      }

      final unlocked = await _repository.getItemsByPerfil(perfil.id!);
      unlockedItems.assignAll(unlocked);

      final equipped = await _repository.getEquippedItems(perfil.id!);
      equippedItems.assignAll(equipped);

      _updateDisplayPath(perfil.idAvatar);
    } catch (e) {
      print("Erro no AvatarController: $e");
    }
  }

  void _updateDisplayPath(int idAvatarBase) {
    bool isMenina = idAvatarBase == 2;
    bool temBoneEquipado = equippedItems.any((i) => i.id == 1);

    if (temBoneEquipado) {
      currentAvatarDisplayPath.value = isMenina
          ? 'assets/images/avatars/menina_bone_dino.png'
          : 'assets/images/avatars/menino_bone_dino.png';
    } else {
      currentAvatarDisplayPath.value = isMenina
          ? 'assets/images/avatars/base_menina.png'
          : 'assets/images/avatars/base_menino.png';
    }
  }

  Future<void> toggleEquipar(ItemAvatar item) async {
    final perfilId = Get.find<PerfilController>().perfilSelecionado.value?.id;
    if (perfilId == null) return;

    bool isCurrentlyEquipped = equippedItems.any((i) => i.id == item.id);
    await _repository.toggleEquipItem(perfilId, item, !isCurrentlyEquipped);
    await loadAvatarData();
  }

  bool isUnlocked(int itemId) => unlockedItems.any((i) => i.id == itemId);
  bool isEquipped(int itemId) => equippedItems.any((i) => i.id == itemId);
}