# Godot CottonPuzzle

A polished Point & Click puzzle game framework built with **Godot Engine 3.5**.

> Original Design Doc: [Feishu Doc](https://mrwvzb02a2.feishu.cn/docx/ToSXdhidtocxazxxbbCcTLYWnch)

## 🌟 Key Features

### Core Architecture
- **Centralized State Management**: A global `Game` singleton (`globals/Game.gd`) manages the entire game state, including story flags, inventory, and progression.
- **Signal-Driven UI**: The UI reacts to data changes via signals, ensuring a clean separation between game logic and visual representation (MVVM style).

### Inventory System
- **Resource-Based**: Items are defined as Godot Resources (`Item.gd`), allowing for easy creation and editing of item properties (textures, descriptions) directly in the inspector.
- **Interactive UI**: An animated inventory bar (`ui/Inventory.gd`) with smooth Tween animations for selecting, using, and browsing items.

### Scene Management
- **Scene Transition**: Smooth transitions between rooms managed by `SceneChanger`.
- **Base Scene Class**: A standardized `Scene` class (`scenes/Scene.gd`) handles common logic like entrance animations and background music overrides.

### Persistence
- **Save/Load System**: Full support for persisting game state (Inventory, Flags, Current Scene) to a local JSON file (`user://data.sav`).

## 📂 Project Structure

- `globals/`: Autoload singletons (`Game`, `SceneChanger`, `SoundManager`) serving as the game's backbone.
- `items/`: Item resource definitions (`.tres` files) and the base `Item` script.
- `scenes/`: Game levels (`H1` - `H4`) and the base scene logic.
- `ui/`: User Interface components (Inventory, TitleScreen, DialogBubble).

## 🛠️ Engine Requirement
Developed with **Godot 3.5 - rc2**. Compatible with Godot 3.x stable versions.