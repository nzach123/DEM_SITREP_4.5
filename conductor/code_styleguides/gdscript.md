# Godot 4.5 GDScript Style Guide

This guide summarizes key formatting, naming conventions, and code order rules for Godot 4.5 GDScript projects, based on the official documentation.

## 1. Formatting
- **Indentation:** Use 4 spaces for indentation.
- **Line Length:** Maximum 100 characters per line.
- **Blank Lines:** 
    - 2 blank lines between method definitions.
    - 1 blank line between logical sections in a method.
- **Spaces:** Around operators, after commas, and after `#` in comments. No spaces inside parentheses/brackets.
- **Docstrings:** Use triple double-quotes (`"""Docstring"""`) for class and function documentation.

## 2. Naming Conventions
- **Classes (Nodes, Resources):** `PascalCase` (e.g., `GameManager`).
- **Variables/Functions:** `snake_case` (e.g., `player_speed`, `_update_health`).
- **Constants/Enum Members:** `SCREAMING_SNAKE_CASE` (e.g., `MAX_SPEED`).
- **Signals:** `snake_case` (e.g., `health_changed`).
- **Files:** `snake_case` (e.g., `main_menu.gd`).

## 3. Code Order
1. `class_name`
2. `extends`
3. Docstring
4. `@export` variables
5. `@onready` variables
6. `const` & `enum`
7. `signal`
8. Member variables
9. Built-in virtual methods (`_init`, `_ready`, `_process`, etc.)
10. Public methods
11. Private/Helper methods (prefixed with `_`)
