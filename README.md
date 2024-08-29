# Garry's Mod Text-to-Speech (TTS)

This is a simple Garry's Mod add-on that provides a Text-to-Speech (TTS)

## Features

- Enable or disable TTS for individual players.
- Choose from multiple TTS voices and models.
- Adjust pitch and speed of the TTS output.
- Play TTS sounds in 3D space to follow the player speaking.

## Installation

1. **Download the Add-on:**

   - Clone or download this repository into your Garry's Mod `addons` folder.

2. **File Structure:**

   Ensure the following files are in the correct locations within your `addons` folder:

garrysmod/addons/tts-addon/ ├── lua/ ├── autorun/ └── cl_tts.lua └── sv_tts.lua └── config.lua


## Configuration

- **config.lua**: Contains configuration data for TTS voices, models, and mappings.

## Client Commands

### `!tts_toggle`
Toggles the TTS functionality for the player.

### `!tts_voice [voice]`
Sets the TTS voice for the player. Replace `[voice]` with one of the available voice options defined in `config.lua`.

### `!tts_model [model]`
Sets the TTS model for the player. Replace `[model]` with one of the available model options defined in `config.lua`.

### `!tts_pitch [pitch]`
Sets the pitch of the TTS output. Replace `[pitch]` with a numeric value between 50 and 400.

### `!tts_speed [speed]`
Sets the speed of the TTS output. Replace `[speed]` with a numeric value between 50 and 250.

## Example Usage

1. **Enable TTS:**
tts_toggle

2. **Change Model:**
tts_model bonzi

3. **Change Voice:**
tts_voice mike

4. **Adjust Pitch:**
tts_pitch 150

5. **Adjust Speed:**
tts_speed 100

For further assistance, please contact the project maintainer or open an issue on the repository's GitHub page.
