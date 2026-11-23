# DinoLearn

DinoLearn é um protótipo de jogo educativo desenvolvido como Trabalho de Conclusão de Curso (TCC) em Ciência da Computação na Universidade Estadual da Paraíba (UEPB). Foi pensado para crianças de 7 a 9 anos com transtorno do espectro autista (TEA), em fase de alfabetização.

A criança percorre uma sequência previsível de atividades com instruções curtas. Em caso de erro, o jogo oferece incentivo e dicas para uma nova tentativa. O responsável pode acompanhar o progresso no próprio dispositivo.

## Como funciona

| Bloco | Tema | Atividades |
| --- | --- | --- |
| 1 | Dinossauros | Contagem, reconhecimento de palavras e uma situação do cotidiano |
| 2 | Capivaras | Adição, leitura e uma situação do cotidiano |
| 3 | Axolotes | Adição e subtração, leitura de frases e uma situação do cotidiano |

- **Perfil infantil e avatar** com preferências de interface por perfil. Ao completar os três blocos, a criança desbloqueia o boné de dinossauro para o avatar.
- **Área do responsável** com progresso por bloco e detalhes como tentativas, erros e dicas por atividade.
- **Dados locais** em SQLite. Os perfis, as preferências e o progresso são armazenados no dispositivo.

## Tecnologias e estrutura

O aplicativo usa Flutter e Dart, GetX para estado e navegação e `sqflite` para persistência local. Os enunciados, opções e dicas das atividades ficam em arquivos JSON, referenciados pelos registros iniciais do banco. Isso permite atualizar o conteúdo de uma atividade no seu arquivo JSON.

| Caminho | Responsabilidade |
| --- | --- |
| `lib/views/` | Telas da criança e do responsável |
| `lib/controllers/` e `lib/routes/` | Estado da interface, fluxo das atividades e navegação |
| `lib/models/` e `lib/services/` | Modelos e regras de perfis, atividades e relatórios |
| `lib/data/` | Esquema SQLite, repositórios e dados iniciais |
| `assets/atividades/` e `assets/images/` | Conteúdo das atividades, ilustrações e avatares |

## Como rodar no Android

Use Flutter 3.41.9 (Dart 3.11.5) e configure o SDK do Android. Abra um emulador Android ou conecte um dispositivo com depuração USB ativa. Na raiz do projeto, execute:

```bash
flutter doctor
flutter pub get
flutter devices
flutter run -d ID_DO_DISPOSITIVO
```

Substitua `ID_DO_DISPOSITIVO` pelo identificador exibido por `flutter devices`. Na primeira abertura, o app cria o banco local e carrega as atividades iniciais. Para explorar o fluxo, adicione um perfil fictício, selecione um avatar e comece pelo bloco dos dinossauros. A área do responsável pode ser aberta a partir da tela inicial.

## Autor

Wagner Tiburcio da Silva Junior · Ciência da Computação, UEPB.
