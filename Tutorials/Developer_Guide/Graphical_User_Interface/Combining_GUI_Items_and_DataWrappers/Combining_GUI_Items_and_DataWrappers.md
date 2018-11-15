---
author: Florian Pieper
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 2
permalink: combining_gui_items_and_datawrappers
subcategory: Graphical User Interface
title: Combining GUI Items and DataWrappers
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Florian Pieper (fpieper@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# GUI Items and DataWrappers
We have used data wrappers in the image viewer tutorial.
We wrote to them and used their call back function to get notified on data changes.
However they can also be integrated in GUI items directly.
In this way there is no need to write to a data wrapper.

## Goal of this tutorial
You should learn how data wrappers can be integrated in GUI items.

## Creating the GUI
The GUI will contain two items.
First of all there is a label showing the current content of the data wrapper.
The second item is a combo box, which will change the content of the data wrapper.
You will note that both items are synchronized by the data wrapper.  
Before we start we first create the data wrapper.
It is initialized with some default value.

<!---INCLUDE src=GUIDataWrapper.escript, start=14, end=14--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static dataWrapper = new Std.DataWrapper("Nothing in here");
```
<!---END_CODESECTION--->

Next up we create a window and a panel for holding the GUI items.

 <!---INCLUDE src=GUIDataWrapper.escript, start=17, end=20--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
     var window = gui.createWindow(400, 250, "DataWrapper Tutorial");
    window.setPosition(50, 50);

     var contentPanel = gui.createPanel(400, 150, GUI.AUTO_LAYOUT);
```
<!---END_CODESECTION--->

We create the GUI items in the descriptional way.
The data wrapper is bind to a GUI item by the attribute _GUI.DATA_WRAPPER_.
We use _GUI.TYPE_SWITCH_ to create the combo box.
The items of the combo box are added with the attribute _GUI.OPTIONS_.
Each item is a list.
All the item lists are contained in a list, so that we have a list of list.
You may have noticed that the item list only contain a single string.
You can also add another entry in that list.
Example:

    GUI_OPTIONS : [[1, "Item 1"], [2, "Item 2"]]

If you would use such a item list, the second value would be the one shown in the combo box, while the first value would be the one written to the data wrapper.  
Again we apply the data wrapper to the combo box.
If we would create another combo box and add the data wrapper to it, it would also get synchronized.

 <!---INCLUDE src=GUIDataWrapper.escript, start=22, end=36--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
contentPanel += [
    {
        GUI.TYPE : GUI.TYPE_LABEL,
        GUI.DATA_WRAPPER : dataWrapper
    },
    {
        GUI.TYPE : GUI.TYPE_NEXT_ROW
    },
    {
        GUI.TYPE : GUI.TYPE_SELECT,
        GUI.LABEL : "Choose some item",
        GUI.OPTIONS : [["An item"], ["Another Item"], ["Something different"]],
        GUI.DATA_WRAPPER : dataWrapper
    }
];
```
<!---END_CODESECTION--->

 The last thing we need to do is adding the content to our window and open it.

 <!---INCLUDE src=GUIDataWrapper.escript, start=38, end=39--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
window += contentPanel;
window.setEnabled(true);
```
<!---END_CODESECTION--->

The image below shows the resulting window.

![Data Wrapper on GUI Items](window.png)

