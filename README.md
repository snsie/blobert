# Katamari Roller

A Katamari Damacy-inspired isometric rolling game built with LÖVE2D.

## Features

- **Rolling Ball Physics**: Smooth movement with momentum and friction
- **Animal Absorption**: Roll into animals to absorb them and grow larger
- **Diverse Animals**: Different types of animals with unique behaviors:
  - Rabbits and Squirrels: Flee from the player
  - Birds and Butterflies: Fly in patterns, avoid player
  - Mice: Simple wandering behavior
- **Beautiful World**: Isometric environment with:
  - Animated grass patches
  - Various trees and flowers
  - Decorative rocks
- **Visual Effects**: Particle effects when absorbing animals
- **Growing Mechanics**: Your ball grows larger as you absorb more animals

## Controls

- **WASD** or **Arrow Keys**: Move the rolling ball
- **ESC**: Quit the game

## How to Run

1. Make sure you have LÖVE2D installed (version 11.4 or later)
2. Run the game using one of these methods:
   - Drag the folder onto the LÖVE2D executable
   - Use command line: `love .` (from the game directory)
   - Use LÖVE2D's file browser to open the folder

## Game Mechanics

- Start as a small blue ball
- Roll into animals to absorb them
- Each absorbed animal increases your size
- Larger animals give more size increase
- Animals have different behaviors - some will flee, others will fly away
- The camera follows your ball as you explore the world
- New animals spawn occasionally to keep the game interesting

## Technical Details

- Built with LÖVE2D 11.4
- Modular code structure with separate modules for:
  - Player (rolling ball mechanics)
  - Animals (AI and behaviors)
  - World (environment and decoration)
  - Particles (visual effects)
  - UI (score and information display)
- Smooth physics with momentum and friction
- Isometric camera system
- Particle effects for absorption

## Files

- `main.lua`: Main game loop and initialization
- `player.lua`: Rolling ball character with absorption mechanics
- `animals.lua`: Animal AI and behaviors
- `world.lua`: Environment and decoration
- `particles.lua`: Visual effects system
- `ui.lua`: User interface and score display
- `conf.lua`: LÖVE2D configuration

Enjoy rolling and growing your katamari!
