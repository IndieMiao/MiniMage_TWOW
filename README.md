# MiniMage_TWOW

MiniMage_TWOW is a lightweight World of Warcraft addon designed for Mages, providing quick access to portals and teleports via a convenient minimap button and dropdown menu. Perfect for both Horde and Alliance players, MiniMage_TWOW streamlines travel across Azeroth with just a click.

## Original Addon
* I found MiniMage_v1.2b in the Wow1.12.1_Addons_Collection, I cannot find the original GitHub or anywhere else this addon is posted.
* I do not take credit for creating this addon, only modifying it to include TurtleWoW specific spells and adding a few features


# Version 1.6
## TurtleWoW Specific Features
* Includes all supported major city Teleport/Portal spells in one dropdown for Mages.
* Supports both Horde and Alliance city spells in the same menu.
* Horde and Alliance city entries are separated with a divider line (no faction text labels).

### Included Cities
* Horde: Orgrimmar, Thunder Bluff, Stonard, Undercity
* Alliance: Alah'Thalas, Theramore, Stormwind, Ironforge, Darnassus

## Features

* **Minimap Button**: Drag and position a minimap button for easy access.
* **Dropdown Menu**: Quick-cast portals and teleports from a single unified city list.
* **Menu Layout**: Horde city entries first, then a separator line, then Alliance city entries.
* "Haven't Learned Spell" message when trying to cast a Teleport/Portal you do not have trained.
  
* **Show/Hide Based on Level**: 
* Portal section hidden until level 40 (and can be toggled with `/mmage portals`).
* Specific Portals/Teleports are greyed out until required level is reached.



## Installation

### TurtleWoW Launcher Install (Recommended) 

1. Open the launcher and navigate to the "AddOns" tab.
2. Click "+ Add New Addon"  button.
3. Paste the GitHub URL of the addon and click "Install".
The launcher will automatically download and install the addon and keep it updated

### Manual Install

1. Download the repository into your `Interface/AddOns/` folder.
2. Ensure the folder structure is `MiniMage_TWOW/MiniMage_TWOW.lua`.
3. Reload the UI or restart WoW.

## Usage & Options

* Click the minimap button to open the dropdown menu.
* Select the desired portal or teleport.
### /mmage Commands
* /mmage help  -  Show Commands
* /mmage icon  -  Show/Hide Minimap Icon
* /mmage portals  -  Show/Hide Portals from Menu
* /mmage reset  -  Reset Addon Settings

## Contributing

Let me know if you have any issues, I'll fix it if I am able to.

## Screenshots

<img width="800" height="600" alt="ss1" src="https://github.com/user-attachments/assets/e1344159-2bd9-43a1-8edb-9b16e123d022" />
