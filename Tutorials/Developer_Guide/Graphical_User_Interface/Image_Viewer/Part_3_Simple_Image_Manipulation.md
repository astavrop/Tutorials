---
author: Florian Pieper
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 3.3
permalink: a_simple_image_viewer_-_part_3_simple_image_manipulation
subcategory: Graphical User Interface
title: A Simple Image Viewer - Part 3 Simple Image Manipulation
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Florian Pieper (fpieper@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# Building an image viewer. Part 3: The interaction tools
So far our image viewer is capable of showing images.
However we want to enhance its features by two tools.
The first tool is the drawing tool which can be used to do simple drawing on the current image.
The second tool adds the ability of scrolling large images by moving the mouse.

## Goal of this tutorial
In this tutorial you learn how PADrend's mouse listener is used.
It also shows how you can build your own dialogs.
For the drawing tool basic image manipulation will be introduced.

## Interaction tools
Basically both tools need mouse input.
Since we want to implement the mouse listener only once, its input is delegated to the tools.
Therefore there are some delegation methods, which are common for both tools.
Lets put them in an "abstract" superclass and refine them for each tool.  
First we need a class _Tool_.
Both of the interaction tools inherit from _Tool_.

<!---INCLUDE src=ImageViewer3.escript, start=17, end=17--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static Tool = new Type();
```
<!---END_CODESECTION--->

Nextup we add the common methods to it, which are empty for a generic tool.
The three methods correspond to the different mouse events:

* _mouseDown_: Is called when the mouse button is pressed down. The current mouse coordinate and the mouse button are passed to it.
* _mouseUp_: Similar to _mouseDown_ but called when the mouse button is released.
* _mouseMove_: Is called when the mouse is moved. Beside the coordinate and button also the delta in position is passed

<!---INCLUDE src=ImageViewer3.escript, start=18, end=23--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
Tool.mouseDown := fn(x, y, button){};
Tool.mouseMove := fn(x, y, dx, dy, button){};
Tool.mouseUp := fn(x, y, button){};

static DrawTool = new Type(Tool);
static MoveTool = new Type(Tool);
```
<!---END_CODESECTION--->

### The drawing tool
This tool is used to draw on an image.
To keep the tool simple, on drawing we just color some pixels around the current mouse position.
Since the drawing tool needs access to the current image, it has a reference to the image.
Also we need some color which is used for the drawing.
Both a saved as attributes.
Since the image as well as the color can change during runtime, there are also setters to set them.

<!---INCLUDE src=ImageViewer3.escript, start=116, end=127--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
DrawTool._constructor := fn(color = Util.Color4f(0,0,0,1)){
    this.image := void;
    this.color := color;
};

DrawTool.setColor := fn(color){
    this.color = color;
};

DrawTool.setImage := fn(image){
    this.image = image;
};
```
<!---END_CODESECTION--->

Next up we need a method that colors the pixels around a coordinate.
For better visibility, we do not only color a single pixel, but also it eight neighbors.
To access the pixels of an image, we need to get a _PixelAccessor_ from the image.
We can use the method _writeColor_ of the _PixelAccessor_, to color a single pixel.
This method is called in two for-loops, which iterate over the pixels neighborhood.
Before we set a pixels color we first need to check whether the current coordinate is within the images bounds.
After we have colored all necessary pixels, we call _dataChanged_ on the image, so that it gets updated.

<!---INCLUDE src=ImageViewer3.escript, start=129, end=146--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
DrawTool.paintPixel := fn(x,y){
    if(!this.image)
        return;
        
    if(!this.color){
        outln("No color set!");
        return;
    }
    
    var accessor = this.image.getImageData().createPixelAccessor();
    
    for(var px = x-1; px <= x+1; px++)
        for(var py = y-1; py <= y+1; py++)
            if(px >= 0 && py >= 0 && px < accessor.getWidth() && py < accessor.getHeight())
                accessor.writeColor(px, py, this.color);
        
    this.image.dataChanged();
};
```
<!---END_CODESECTION--->

In the delegation methods _paintPixel_ is called and the current mouse position is passed to it.
Before we call the function we first make sure that the left mouse button is pressed.
Note that this check differs for _mouseMove_ since the listener receives a mask instead of a single button for this event.

<!---INCLUDE src=ImageViewer3.escript, start=148, end=161--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
DrawTool.mouseDown = fn(x, y, button){
    if(button == Util.UI.MOUSE_BUTTON_LEFT)
        this.paintPixel(x, y);
};

DrawTool.mouseMove = fn(x, y, dx, dy, button){
    if(button == Util.UI.MASK_MOUSE_BUTTON_LEFT)
        this.paintPixel(x, y);
};

DrawTool.mouseUp = fn(x, y, button){
    if(button == Util.UI.MOUSE_BUTTON_LEFT)
        this.paintPixel(x, y);
};
```
<!---END_CODESECTION--->

### The move tool
The move tool can be used to scroll an image.
Therefore it manipulates the scrollbars of the image panel.
A reference of the panel is saved as attribute.

<!---INCLUDE src=ImageViewer3.escript, start=165, end=167--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
MoveTool._constructor := fn(imagePanel){
    this.imagePanel := imagePanel;
};
```
<!---END_CODESECTION--->

For the scrolling itself we create a method.
It takes the delta in position and shifts the scrollbars by it.
To ensure correct scrolling we need to invert the delta values.
For the new scroll position we add the delta to the old scroll position.
We use the method _scrollTo_ in order to scroll to the new position.

<!---INCLUDE src=ImageViewer3.escript, start=169, end=179--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
MoveTool.scroll := fn(dx, dy){
    if(!this.imagePanel)
        return;
        
    var delta = new Geometry.Vec2(-dx, -dy);
    
    var oldPosition = this.imagePanel.getScrollPos();
    var newPosition = oldPosition + delta;
    
    this.imagePanel.scrollTo(newPosition);
};
```
<!---END_CODESECTION--->

Since we only scroll on mouse moves, it is enough to overwrite _mouseMove_.
Again we check for the correct button and than call the scroll method we have just created.

<!---INCLUDE src=ImageViewer3.escript, start=181, end=185--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
MoveTool.mouseMove = fn(x, y, dx, dy, button){
    if(button == Util.UI.MASK_MOUSE_BUTTON_LEFT){
        this.scroll(dx, dy);		
    }
};
```
<!---END_CODESECTION--->

### Some new attributes to hold the tools
In order to manage the tools we need some new attributes.
First of all we need two attributes holding a reference to an instance of each tool.
Next up we need an attribute to held the currently selected tool.
We initialize it with a generic tool.
In this way we do not need to handle null pointers in the listener’s function.
In addition we need an attribute that handles the color for the drawing tool.
We use a data wrapper for this purpose and apply a call back function to it.

<!---INCLUDE src=ImageViewer3.escript, start=214, end=222--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
this.pencileColor  := new Std.DataWrapper(new Util.Color4f(0, 0, 0, 1));

this.drawTool := new DrawTool(this.pencileColor());
this.moveTool := new MoveTool(this.imagePanel);
this.currentTool := new Tool(); 

this.pencileColor.onDataChanged += [this.drawTool] => fn(drawTool, newColor){
    drawTool.setColor(newColor);
};
```
<!---END_CODESECTION--->

We also have to add a line to out callback function of the data wrapper _shownImageFile_.
If a new image is loaded it has to be set to the drawing tool.

<!---INCLUDE src=ImageViewer3.escript, start=200, end=200--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
imageViewer.drawTool.setImage(image);
```
<!---END_CODESECTION--->

## Adding a mouse listener
In the window building method we use _Util.registerExtensionRevocably_ to add the mouse listener.
As first argument it receives _'PADrend_UIEvent'_ which indicates that we register a generic event handler.
The second argument is a callback function, which is called when some event occurs.
Since we are only interested in mouse events, in the function we first check whether the current event's type is either _Util.UI.EVENT_MOUSE_BUTTON_ or _Util.UI.EVENT_MOUSE_MOTION_.
Next up we check whether the mouse coordinates are within the image panel.
We use the panels absolute rectangle in the test.
Since the coordinates are absolute coordinates, but we need them relative to the image panel, we subtracted the upper left corner of the image panel from them.
The coordinates are than passed to the current tools delegation method depending on the actual mouse event.
For mouse move events we need to access the field _buttonMask_ instead of _button_ since there is no _button_ field in the event object.

<!---INCLUDE src=ImageViewer3.escript, start=302, end=322--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
Util.registerExtensionRevocably('PADrend_UIEvent', 
    [this] => fn(imageViewer, event){
        if(event.type == Util.UI.EVENT_MOUSE_BUTTON || event.type == Util.UI.EVENT_MOUSE_MOTION){
            if(!imageViewer.currentImage || !imageViewer.imagePanel.getAbsRect().contains(event.x, event.y))
                return;
                
            var x = event.x - imageViewer.currentImage.getAbsRect().getX();
            var y = event.y - imageViewer.currentImage.getAbsRect().getY();
                
            if(event.type == Util.UI.EVENT_MOUSE_BUTTON){
                if(event.pressed)
                    imageViewer.currentTool.mouseDown(x, y, event.button);
                else	
                    imageViewer.currentTool.mouseUp(x, y, event.button);
            }
            if(event.type == Util.UI.EVENT_MOUSE_MOTION){
                imageViewer.currentTool.mouseMove(x, y, event.deltaX, event.deltaY, event.buttonMask);
            }
        }
    }
);
```
<!---END_CODESECTION--->

## Switching between the tools
To switch between the tools we have to adapt the callback functions of the corresponding tool bar buttons.
The only thing we need to do is to set the current tool to the tool associated with the button.

<!---INCLUDE src=ImageViewer3.escript, start=489, end=511--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
btnDrawTool = gui.create({
    GUI.TYPE : GUI.TYPE_BUTTON,
    GUI.ICON : "#Tut_Pen",
    GUI.TOOLTIP : "Draw Tool",
    GUI.ON_CLICK : [this] => fn(imageViewer){
        btnDrawTool.setSwitch(true);
        btnMoveTool.setSwitch(false);
        
        imageViewer.currentTool = imageViewer.drawTool;
    }
});

btnMoveTool = gui.create({
    GUI.TYPE : GUI.TYPE_BUTTON,
    GUI.ICON : "#Tut_Move",
    GUI.TOOLTIP : "Move Tool",
    GUI.ON_CLICK : [this] => fn(imageViewer){
        btnDrawTool.setSwitch(false);
        btnMoveTool.setSwitch(true);
        
        imageViewer.currentTool = imageViewer.moveTool;
    }
});
```
<!---END_CODESECTION--->

## The color choose dialog
The last thing we need to do is the changing of the drawing color.
We introduce a dialog to change the color.
It should look like in the image below.

![Color Dialog](color_chooser.png)

For the color dialog we create a new type.

<!---INCLUDE src=ImageViewer3.escript, start=15, end=15--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static ColorDialog = new Type();
```
<!---END_CODESECTION--->

The dialog needs some attributes.
First of all we only allow a fixed number of colors, which are stored in a list.
Next up we need some variable that holds the currently selected color.
It is initialized by a color passed to the _init_ function.
This color will be returned when the dialog is successfully closed.
After creating the dialog's content _colorLabels_ will held a list of buttons that are used to select a color.
For returning the selected color we need a point where a callback function can be registered.
Therefore we create a _Util.MultiProcedure_.
After creating the dialogs content, we select the button of the current color.

<!---INCLUDE src=ImageViewer3.escript, start=86, end=106--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
ColorDialog.init := fn(oldColor){
    this.colors := [
        new Util.Color4f(1.0, 1.0, 1.0, 1.0),
        new Util.Color4f(1.0, 1.0, 0.0, 1.0),
        new Util.Color4f(1.0, 0.0, 1.0, 1.0),
        new Util.Color4f(1.0, 0.0, 0.0, 1.0),
        new Util.Color4f(0.0, 1.0, 1.0, 1.0),
        new Util.Color4f(0.0, 1.0, 0.0, 1.0),
        new Util.Color4f(0.0, 0.0, 1.0, 1.0),
        new Util.Color4f(0.0, 0.0, 0.0, 1.0)
    ];
    
    this.currentColor := oldColor;
    this.colorLabels := [];
    this.onConfirm := new Std.MultiProcedure();

    this.createContent();
    
    var index = this.getIndexForColor(this.currentColor);
    this.selectColor(index);
};
```
<!---END_CODESECTION--->

### Create the dialog's content
The content is held on a panel.
For each color there will be a button.
We can simply create them in a for loop, which iterates over the colors.
For each button its color (which in buttons is the text color) is set.
In addition we set a property, which prevents the buttons text color to switch to white when the mouse courser is on it.
When a button is pressed it sets the current color to their corresponding color.
Therefore to each callback function the buttons index is passed.
In the function a method setting the color is called.  
Next up we create a dialog window.
We use a _GUI.TYPE_POPUP_DIALOG_.
As content we pass the panel with the buttons we have just created.
With _GUI.ACTIONS_ we add the dialog's _Abort_ and _Okay_ buttons.
Clicking on one of this buttons causes the dialog to shut down.
For the _Abort_ button we do not need to do anything if it is clicked.
However for _Okay_, we need to return the currently selected color.
Therefore we simply call the multi procedure and pass the color to it.

<!---INCLUDE src=ImageViewer3.escript, start=52, end=106--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
ColorDialog.createContent := fn(){
    var colorPanel = gui.createPanel(370,60);
    
    foreach(this.colors as var index, var color){
        var lbl = gui.create({
            GUI.TYPE : GUI.TYPE_BUTTON,
            GUI.COLOR : color,
            GUI.PROPERTIES : [new GUI.ColorProperty(GUI.PROPERTY_BUTTON_HOVERED_TEXT_COLOR, color)],
            GUI.LABEL : "COL",
            GUI.WIDTH : 40,
            GUI.HEIGHT : 40,
            GUI.ON_CLICK : [index, this] => fn(selfIndex, dialog){
                dialog.selectColor(selfIndex);
            }
        });
        
        this.colorLabels += lbl;
        colorPanel += lbl;
    }

    this.diag := gui.createDialog({
        GUI.TYPE : GUI.TYPE_POPUP_DIALOG,
        GUI.LABEL : "Choose Color...",
        GUI.SIZE : [400, 130],
        GUI.CONTENTS : [colorPanel],
        GUI.ACTIONS : [
            ["Abort",fn(){;}],
            ["Okay", [this] => fn(colorDialog){
                colorDialog.onConfirm(colorDialog.currentColor);
            }]
        ],
    });
};

ColorDialog.init := fn(oldColor){
    this.colors := [
        new Util.Color4f(1.0, 1.0, 1.0, 1.0),
        new Util.Color4f(1.0, 1.0, 0.0, 1.0),
        new Util.Color4f(1.0, 0.0, 1.0, 1.0),
        new Util.Color4f(1.0, 0.0, 0.0, 1.0),
        new Util.Color4f(0.0, 1.0, 1.0, 1.0),
        new Util.Color4f(0.0, 1.0, 0.0, 1.0),
        new Util.Color4f(0.0, 0.0, 1.0, 1.0),
        new Util.Color4f(0.0, 0.0, 0.0, 1.0)
    ];
    
    this.currentColor := oldColor;
    this.colorLabels := [];
    this.onConfirm := new Std.MultiProcedure();

    this.createContent();
    
    var index = this.getIndexForColor(this.currentColor);
    this.selectColor(index);
};
```
<!---END_CODESECTION--->

### Selecting a button
To indicate the currently selected color, we set a border to the corresponding button.
This is done by the method _setFlag_.
In the method _selectColor_, we first of all deactivate the border of all buttons.
Then we check whether the passed index is valid.
If not, the current color is set to void.
Otherwise we set _currentColor_ to the color value that is found at the passed position in the list and add a border to the corresponding button.

<!---INCLUDE src=ImageViewer3.escript, start=25, end=37--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
ColorDialog.selectColor := fn(index){
    foreach(this.colorLabels as var label){
        label.setFlag(GUI.BORDER, false);
    }
    
    if(index < 0 || index >= this.colors.size()){
        this.currentColor = void;
        return;
    }
    
    this.currentColor = this.colors[index];
    this.colorLabels[index].setFlag(GUI.BORDER, true);
};
```
<!---END_CODESECTION--->

### Open the dialog
The last method we add to our dialog can be used to open the dialog.
First of all we create the dialog by calling the init method.
Next up we add the passed callback function to multi procedure, so that we can return the selected color.
The dialog itself is opened by calling its init method.

<!---INCLUDE src=ImageViewer3.escript, start=108, end=112--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
ColorDialog.openDialog := fn(callBackFunction, oldColor){
    this.init(oldColor);
    this.onConfirm += callBackFunction;
    this.diag.init();
};
```
<!---END_CODESECTION--->

In the image viewer we add a method _openColorDialog_.
It creates a new color dialog with a callback function.
In the callback function the pencil color is set.

<!---INCLUDE src=ImageViewer3.escript, start=257, end=263--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
ImageViewer.openColorDialog := fn(){
    var dialog = new ColorDialog();
    dialog.openDialog([this] => fn(imageViewer, newColor){
            imageViewer.pencileColor(newColor);
        },
        this.pencileColor());
};
```
<!---END_CODESECTION--->

This method is called when the _Choose Color..._ item in the settings menu is clicked.

<!---INCLUDE src=ImageViewer3.escript, start=440, end=442--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
GUI.ON_CLICK : [this] => fn(imageViewer){
    imageViewer.openColorDialog();
}
```
<!---END_CODESECTION--->



