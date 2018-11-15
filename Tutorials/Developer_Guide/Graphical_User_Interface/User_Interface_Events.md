---
author: Henrik Heine
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 1
permalink: handling_user_interface_events
subcategory: Graphical User Interface@4
title: Handling User Interface Events
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->

## UI Events
An `Util.UI.Event` object represents a single UI event. Each instance has a `type` attribute, which determines the kind of event and several different other attributes depending on this type.
The `type` attribute is a number representing the actual type of event and is equal to one of the following constants:
* `Util.UI.EVENT_RESIZE`
* `Util.UI.EVENT_KEYBOARD`
* `Util.UI.EVENT_MOUSE_BUTTON`
* `Util.UI.EVENT_MOUSE_MOTION`
* `Util.UI.EVENT_JOY_AXIS`
* `Util.UI.EVENT_JOY_BUTTON`
* `Util.UI.EVENT_JOY_HAT`
* `Util.UI.EVENT_QUIT`

The additional attributes of each event are described in more detail in the following sections.

## Resize Event
This event is fired whenever the size of the window changes.
* `width` - The new width of the window in pixels
* `height` - The new height of the window in pixels

## Keyboard Event
This event is fired whenever a key is pressed or released.
* `key` - The scancode of the pressed/released key. All key values are defined as constants in the `Util.UI` namespace. For example `Util.UI.KEY_SPACE` for the spacebar.
* `str` - The string representation of the pressed key (e.g. `"h"`) or the empty string if the pressed key was a control sequence, like `Util.UI.KEY_SHIFTR`.
* `pressed` - Whether the key was pressed down or released.

## Mouse Button Event
This event is fired whenever a mouse button is pressed or released.
* `x` - X position of the mouse click in window space (origin is in the top left corner)
* `y` - Y position of the mouse click
* `button` - The button index e.g. `Util.UI.MOUSE_BUTTON_LEFT`. The mousewheel is also considered a button: `Util.UI.MOUSE_WHEEL_UP` and `Util.UI.MOUSE_WHEEL_DOWN`
* `pressed` - Whether the button was pressed down or released.

## Mouse Motion
This event is fired whenever the mouse is moved inside the window.
* `x` - X position of the cursor in window space (origin is in the top left corner)
* `y` - Y position of the cursor
* `deltaX` - Change in x-direction since the last motion event.
* `deltaY` - Change in y-direction since the last motion event.
* `buttonMask` - Bitmask describing which of the three main buttons are pressed: `Util.UI.MASK_MOUSE_BUTTON_LEFT` / `_MIDDLE` / `_RIGHT` or `Util.UI.MASK_NO_BUTTON`

## Joystick/Gamepad Events
PADrend also supports joysticks and gamepads, but they must be already connected when PADrend starts, otherwise they are not recognized until you restart PADrend. Each joystick event contains a `joystick`attribute, which is a number referencing a joystick. Therefore two different joysticks will have to different `joystick` values.

### Axis
This event is fired whenever any axis of any joystick is moved.
* `axis` - An integer describing the index of the axis
* `value` - The raw value of the axis, typically in the range of -32768 to 32767

### Button
This event is fired whenever a button is pressed or released
* `button` - An integer describing the index of the button
* `pressed` - Whether the button was pressed or released

### Hat switch (or D-Pad or POV)
This event is fired whenever the direction of the D-Pad changes
* `hat`- An integer describing the index of the hat switch
* `value` - Bitmask of the direction buttons: `Util.UI.MASK_HAT_CENTER` / `_UP` / `_RIGHT` / `_DOWN` / `_LEFT`

### XBox360 Mapping
The XBox360 controller is an often used controller and this section describes the (Windows) mapping of it.
The range of each axis goes from -32768 to 32767.

| axis number | Corresponding gamepad axis | -32768 | 32767
| ---------- | ---------- |
| 0 | Left x-axis | Left | Right |
| 1 | Left y-axis | Up | Down |
| 2 | Left and Right Trigger | RT | LT |
| 3 | Right y-axis | Up | Down |
| 4 | Right x-axis | Left | Right |
Unfortunatelly PADrend uses only DirectInput and not XInput, therefore the left and right triggers are mapped to the same axis. This will result in -MAX if RT is totally pressed and +MAX if LT is totally pressed. If none or both are pressed the axis will yield 0.
> The center position of each axis is not always exactly zero, therefore a value of +-1000 should be treated as zero. Very old or used-up gamepads might even have a deviation of +-3000.

| button number | Corresponding button |
| ---------- | ---------- |
| 0 | A |
| 1 | B |
| 2 | X |
| 3 | Y |
| 4 | LB |
| 5 | RB |
| 6 | Back |
| 7 | Start |
| 8 | LS |
| 9 | RS |

The XBox360 gamepad only has one hat-switch, which is numbered as `0`.


