# Planejamento de Aulas - Flutter + Pokédex + Flame

## Objetivo Geral

Ao final do módulo, cada aluno será capaz de:
- Desenvolver interfaces em Flutter;
- Consumir uma API REST utilizando HTTP e JSON;
- Construir uma Pokédex funcional utilizando a PokéAPI;
- Desenvolver um jogo 2D básico utilizando Flame / Bonfire 4.0.

---

# Módulo 1 - Flutter

## Aula 1 - Rows e Columns

**Conteúdo:**
- Row
- Column
- MainAxisAlignment
- CrossAxisAlignment

**Projeto:** Tela de perfil.

## Aula 2 - Layout Responsivo

**Conteúdo:**
- SingleChildScrollView
- Expanded
- Flexible
- Spacer
- SizedBox

**Projeto:** Tela de cadastro.

## Aula 3 - Botões

**Conteúdo:**
- ElevatedButton
- FilledButton
- OutlinedButton
- IconButton
- FloatingActionButton

**Projeto:** Menu inicial do aplicativo.

## Aula 4 - Textos e Estilização

**Projeto:** Tela de pontuação.

## Aula 5 - Imagens e Assets

**Conteúdo:**
- Image.asset
- pubspec.yaml
- Assets

**Projeto:** Tela de personagem.

## Aula 6 - Ícones e Navegação

**Conteúdo:**
- Icon
- Navigator
- Rotas

**Projeto:** Menu → Perfil → Configurações.

## Aula 7 - StatefulWidget

**Projeto:** Interface interativa.

## Aula 8 - Inputs

**Conteúdo:**
- TextField
- TextEditingController
- Form

**Projeto:** Cadastro de jogador.

---

# Módulo 2 - Consumo de APIs

## Aula 9 - Introdução às APIs REST

**Conteúdo:**
- Conceito de API
- HTTP
- JSON
- Endpoints

**Recurso:**
- Utilizar a documentação da PokéAPI: https://pokeapi.co/docs/v2

## Aula 10 - Primeira Requisição

**Conteúdo:**
- package:http
- Future
- async/await

**Projeto:** Buscar um Pokémon pelo nome.

## Aula 11 - Construindo uma Pokédex

**Conteúdo:**
- FutureBuilder
- Image.network
- ListView
- Card

**Projeto:**
- Buscar Pokémon
- Mostrar nome, ID, Peso, Altura e Sprite

## Aula 12 - Pokédex Completa

**Conteúdo:**
- Busca por número
- Próximo / Anterior
- Tipos
- Habilidades

---

# Módulo 3 - Jogo 2D com Bonfire 4.0 (Flame)

> **Referência Técnica:** [Bonfire 4.0 Documentation](https://bonfire-engine.github.io/#/doc/bonfire_4?id=bonfire-40)  
> *Principais novidades do Bonfire 4.0:* Uso do parâmetro `playerControllers` em substituição aos seletores individuais de joystick/teclado, novo sistema de mixins (`WithCollision`, `Movement`) e melhorias no gerenciamento do `BonfireWidget`.

| Aula | Tema | Resultado |
|---|---|---|
| Aula 13 | Introdução ao Bonfire 4.0 + Player | Personagem controlável |
| Aula 14 | Mapas + câmera + colisões (`WithCollision`) | Cenário explorável |
| Aula 15 | NPCs + diálogos + interação | Personagens interativos |
| Aula 16 | Inimigos + vida + dano | Sistema de combate básico |
| Aula 17 | Itens + missões + HUD | Objetivos e interface |
| Aula 18 | Menu + vitória + Game Over + integração | Protótipo completo Bonfire 4.0 |
| **Projeto Final** | **DS Quest** | Jogo temático da turma |

---

## Aula 13 - Bonfire 4.0 e Personagem

**Conteúdo:**
- Configuração do Bonfire 4.0 (`BonfireWidget`)
- Novo padrão `playerControllers` (`Joystick` e `Keyboard`)
- Estrutura do jogo (Game Loop & CameraConfig)
- Mundo e Player (`SimplePlayer`)
- Sprite e Spritesheet
- Movimentação do personagem

**Resultado:** Personagem controlável em uma cena simples.

**Exemplo Bonfire 4.0:**
```dart
BonfireWidget(
  playerControllers: [
    Joystick(
      directional: JoystickDirectional(),
    ),
    Keyboard(),
  ],
  player: SimplePlayer(
    position: Vector2(100, 100),
    size: Vector2(32, 32),
    speed: 150,
  ),
  map: WorldMapByTiled(
    WorldMapReader.asset('mapa_escola.json'),
  ),
)
```

---

## Aula 14 - Mapas, Câmera e Colisões (Bonfire 4.0)

**Conteúdo:**
- Mapas 2D (Tiled / Matrix)
- Tiles e tilesets
- Câmera e limites (`CameraConfig`)
- Novo Mixin de Colisão (`WithCollision`)
- Objetos do cenário com colisão

**Resultado:** Pequeno mapa escolar explorável.

```text
┌─────────────────────────┐
│      LABORATÓRIO        │
│  💻   💻   💻           │
│                         │
│          🧑             │
│                         │
├──────────┬──────────────┤
│  SALA    │  CORREDOR    │
└──────────┴──────────────┘
```

---

## Aula 15 - NPCs e Interação

**Conteúdo:**
- NPCs (`SimpleNpc`)
- Interação com personagem e aproximação (`seePlayer`)
- Diálogos (`TalkDialog.show`)
- Eventos desencadeados pelo jogador

**Resultado:**

```text
🧑 PLAYER → 👨‍🏫 PROFESSOR

"Encontre o pendrive perdido no laboratório!"
```

---

## Aula 16 - Inimigos, Vida e Dano (`WithCollision`)

**Conteúdo:**
- Inimigos (`SimpleEnemy with Movement, WithCollision`)
- Detecção do jogador (`seeAndMoveToPlayer`)
- Perseguição
- Colisão e dano (`receiveDamage`)
- Vida (`LifeComponent`)
- Game Over básico

**Resultado:**

```text
❤️ VIDA
████████░░ 80%

        👾
         ↓
       🧑
```

**Inimigos Temáticos Sugeridos:**
- Bug 🐛
- Glitch ⚡
- Erro 404 🚫
- Vírus fictício 🦠

---

## Aula 17 - Itens, Missões e HUD

**Conteúdo:**
- Itens coletáveis (`GameDecoration with Sensor`)
- Pontuação e inventário (Pendrives 💾, Poções 🧪)
- Missões e Objetivos (Quests)
- HUD sobreposto (`overlayBuilderMap`)

**Resultado:**

```text
┌──────────────────────────┐
│ ❤️ 100%       💾 02      │
│                          │
│                          │
│        🧑                │
│                          │
│ MISSÃO:                  │
│ Encontrar o pendrive     │
└──────────────────────────┘
```

**Exemplo de Checklist de Missão:**
- [ ] Encontrar o pendrive
- [ ] Entregar ao professor
- [ ] Encontrar o código
- [ ] Abrir o laboratório

---

## Aula 18 - Integração e Fluxo Completo (Bonfire 4.0)

**Conteúdo:**
- Menu inicial, instruções e créditos
- Fluxo do jogo com arquitetura Bonfire 4.0
- Integração das mecânicas das Aulas 13 a 17
- Testes e depuração do protótipo

**Fluxo do Jogo:**

```text
             MENU
               │
             JOGAR
               ↓
             MAPA
               │
        ┌──────┴──────┐
        ↓             ↓
      NPCs         INIMIGOS
        │             │
        └──────┬──────┘
               ↓
             ITENS
               ↓
            MISSÃO
               ↓
       ┌───────┴───────┐
       ↓               ↓
    VITÓRIA         GAME OVER
       ↓               ↓
      FINAL          REINICIAR
```

---

# 🎮 Projeto Final - DS Quest

Depois das seis aulas do módulo, inicia-se o desenvolvimento do **Projeto Final**. A turma utilizará o protótipo construído nas aulas anteriores (Aulas 13 a 18) com a **Bonfire 4.0 Engine** como base, em vez de começar o jogo do zero.

### Organização em Equipes

- **Equipe 1 - Cenários:** Mapas, Tiles, Ambientes da escola
- **Equipe 2 - Personagens:** Player, NPCs, Sprites
- **Equipe 3 - Mecânicas:** Inimigos, Itens, Missões
- **Equipe 4 - Interface:** Menu, HUD, Vitória, Game Over
- **Equipe 5 - Áudio e Polimento:** Música, Efeitos, Ajustes visuais, Testes

---

### Fluxo do Produto Final

```text
             DS QUEST
                │
       ┌────────┴────────┐
       │                 │
    EXPLORAÇÃO        MISSÕES
       │                 │
    NPCs/ITENS       DESAFIOS
       │                 │
       └────────┬────────┘
                ↓
             OBJETIVO
                │
         ┌──────┴──────┐
         ↓             ↓
      VITÓRIA       GAME OVER
```

> **Nota Pedagógica:**  
> A adoção do Bonfire 4.0 modernizou o módulo, padronizando os controladores de entrada (`playerControllers`) e a arquitetura de mixins (`WithCollision`), tornando a criação do jogo muito mais intuitiva para os alunos.
