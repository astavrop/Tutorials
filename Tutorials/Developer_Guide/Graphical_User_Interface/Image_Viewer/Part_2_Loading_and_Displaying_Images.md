---
author: Florian Pieper
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 3.2
permalink: a_simple_image_viewer_-_part_2_loading_and_displaying_images
subcategory: Graphical User Interface
title: A Simple Image Viewer - Part 2 Loading and Displaying Images
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Florian Pieper (fpieper@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# Building an image viewer. Part 2: Loading and saving images
This tutorial is a follow up of the building of the graphical user interface panel.
In this tutorial we will load image files and show them in the image panel.
Furthermore we will add the saving of images which will be needed in the next tutorial.

## Goal of this tutorial
This tutorial shows you the basic concepts of loading and saving image files.
You also learn about the file dialog and how it is used.

## Some new attributes
The image viewer can either load single images or a folder containing images.
If a folder is loaded, two buttons in the tool-bar can be used to switch through the contained images.
In order to hold the necessary information for the loading of images we need to add some attributes to the image viewers class.
This is done in the _init_ method.
In the next tutorial we want to apply changes to the image, so we will need to have access to it.
The currently shown image is stored in _currentImage_.
The paths of all images contained in a folder will be stored in _imagesInFolder_ as a list.
Initially there is no list, so we set the variable to _void_.
Furthermore we need to have some index determining which is the current shown image in the list.

<!---INCLUDE src=ImageViewer2.escript, start=30, end=33--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
this.currentImage := void;

this.imagesInFolder := void;
this.imageFolderIndex := 0;
```
<!---END_CODESECTION--->

Since it is also possible to load a single image, we also need an attribute to store the path of the currently loaded image.
This path is used for loading the image, as well as for saving it.
We store the image's path in the attribute _shownImageFile_.
whenever there is a new value written to this attribute, a image has to be loaded.
Here a _Std.DataWrapper_ comes in handy.

<!---INCLUDE src=ImageViewer2.escript, start=17, end=17--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
this.shownImageFile := new Std.DataWrapper();
```
<!---END_CODESECTION--->

A callback function can be attached to it.
This function is called, when the value of the wrapper is changed.
In our case we will use the callback function to load the new image.

### Loading the image file
As we need access to the image viewer object, we have to pass the _this_ pointer to the function.
The second argument of the function is loaded with the value which was set in the wrapper.
To avoid null pointers we first check whether there was a value set to the wrapper.
If not the function is left.
To load the image we simply call _gui.loadImage_ and pass the image's path to it.
The image itself is a GUI component, so if we want to display it, we only have to added it to the image panel.
Before we do this lets first get rid of a potential old image.
This is done by calling _clear_ on the image panel.
In general _clear_ removes all children from a component.
In a last step we update _currentImage_ to the new image.

<!---INCLUDE src=ImageViewer2.escript, start=18, end=28--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
this.shownImageFile.onDataChanged += [this] => fn(imageViewer, file){
    if(!file)
        return;
        
    var image = gui.loadImage(file);
    
    imageViewer.imagePanel.clear();
    imageViewer.imagePanel.add(image);
    
    imageViewer.currentImage = image;
};
```
<!---END_CODESECTION--->

## Some new methods
We also need two new method.
One is needed to save an image to a file.
The other traverses a folder and searches for all included image files.
It adds the path to each found image to a list and returns that list.

### Saving an image to disk
The method for saving an image is _saveCurrentImageToFile_, which saves the current image.
The file path is passed to the method as parameter.
Saving the image to disk works similar to loading an image.
Again we first check the image and the file to be null pointers.
As mentioned before, images are GUI components.
To save the image we need to extract the actual bitmap from the component.
We can access it via the image data of the component by calling _currentImage.getImageData().getBitmap()_.
To save the image we can use _Util.saveImage(bitmap, path)_.

<!---INCLUDE src=ImageViewer2.escript, start=63, end=69--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
ImageViewer.saveCurrentImageToFile := fn(file){
    if(!this.currentImage || !file)
        return;

    var bitmap = this.currentImage.getImageData().getBitmap();
    Util.saveBitmap(bitmap, file);
};
```
<!---END_CODESECTION--->

### Getting all images of a folder
To switch through all images of a folder, we first need to extract the images from the folder.
This is done by the method _getAllImagesInFolder_.
If the extraction fails or there are no image files in the folder, the method returns _void_.
As a first step it is checked whether the passed path is a folder.
Otherwise it can not be processed and void is returned.
To get all files of a folder we can use _IO.dir(folder, FLAGS)_.
As flag we pass _IO.DIR_FILES_, since we are only interested in files.
The function returns a list, containing the files.
Since we only want to process some image formats (PNG, JPEG and Bitmap) we need to filter the list.
Therefore we iterate over the file list and check for each file whether its file ending is in the list of the supported formats.
If this is the case, the file is added to the output list.

<!---INCLUDE src=ImageViewer2.escript, start=41, end=61--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
ImageViewer.getAllImagesInFolder := fn(folder){
    if(!folder || !IO.isDir(folder))
        return void;
    
    var images = [];
    var filter = [".png", ".jpg", ".bmp"];
    
    var files = IO.dir(folder, IO.DIR_FILES);
    
    foreach(files as var file){
        foreach(filter as var fileEnding){
            if(file.endsWith(fileEnding))
                images += file;
        }
    } 
    
    if(images.empty())
        return void;
    
    return images;
};
```
<!---END_CODESECTION--->

## File dialog
In order to browse files PADrend offers a file dialog.
We will use this dialog for both of our open functions as well as for the _Save As_ function.
The dialog can be set up for either opening a folder or opening a file.
In the creation of the dialog a call back function is passed.
This function is called if the dialog succeeds (e.g. the user presses the _Confirm_ button).

### Open a folder
Here we will finish the callback function of our _Open Folder..._ menu item.
First thing we need to do is to set up a file dialog.
Therefore we instantiate a new _GUI.FileDialog_ object.
To the constructor we pass a title for the dialog, the start directory, a list of file endings that should be accepted and a callback function.
We set the start directory to ___DIR___, which is the current directory.
Since we want to process folders only, we do not need any file endings, so that we pass _void_.  
Next up we write our callback function.
When the file dialog calls this function it passes the chosen folder to it.
In the function we first set the index of the current image to _0_, which is the first image in the list.
Next up we call _getAllImagesInFolder_ to collect the paths of all images included in the folder.
If there is no image at all the function is left.
Otherwise the first image is loaded.  
After we have created the dialog we need to set it to open folders only.
This is done by setting the _folderSelector_ attribute of the instance to _true_.
To open the dialog we simply call _init()_ on the instance.

<!---INCLUDE src=ImageViewer2.escript, start=122, end=138--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var diag = new GUI.FileDialog
(
    "Open Image Folder...",
    __DIR__,
    void,
    [imageViewer] => fn(imageViewer, folder){
        imageViewer.imageFolderIndex = 0;
        imageViewer.imagesInFolder = imageViewer.getAllImagesInFolder(folder);
        
        if(!imageViewer.imagesInFolder)
            return;
            
        imageViewer.shownImageFile(imageViewer.imagesInFolder[imageViewer.imageFolderIndex]);
    }
);
diag.folderSelector = true;
diag.init();
```
<!---END_CODESECTION--->

### Open a file
The creation of a the file dialog is similar to the one for opening folders.
However here we need to pass a list of file endings: _[".png", ".jpg", ".bmp"]_.
Also the callback function is adapted.
Since we only want to show a single image, we set _imagesInFolder_ to void.
After that the image is loaded and shown.  
When opening a file dialog, it will set some initial default file name.
Since we want the text field, showing the currently chosen file, to be empty at the opening of the dialog, we set _initialFilename_ to an empty string.

<!---INCLUDE src=ImageViewer2.escript, start=145, end=157--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var diag = new GUI.FileDialog
(
    "Open Image File...",
    __DIR__,
    [".png", ".jpg", ".bmp"],
    [imageViewer] => fn(imageViewer, fileName){
        imageViewer.imageFolderIndex = 0;
        imageViewer.imagesInFolder = void;
        imageViewer.shownImageFile(fileName);
    } 
);
diag.initialFilename = "";
diag.init();
```
<!---END_CODESECTION--->

### Save file and save file as
For _Save File as..._ we again need a file dialog to figure out where to store the image.
In the callback function we need to check whether the file already exists.
If the file does not exist we can just save the image.
If it exists we have to ask the user whether he wants to overwrite it.
So we need to create some kind of message box.
Therefore we use _gui.createPopupWindow_.
We pass the windows size and the message to it.
The window needs some actions, which are in our case a _Yes_ and a _No_ button.
We add them by calling _addAction_.
The _Yes_ button gets a callback function which saves the image.
Since the _No_ button simply just closes the window, it does not need any callback function.

<!---INCLUDE src=ImageViewer2.escript, start=166, end=190--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
    if(!imageViewer.currentImage || !imageViewer.shownImageFile())
        return;

    var diag = new GUI.FileDialog
    (
        "Save File as...",
        __DIR__,
        [".png", ".jpg", ".bmp"],
        [imageViewer] => fn(imageViewer, fileName){
            if(IO.isFile(fileName)){
                var overWriteMsg = gui.createPopupWindow(300,100,"The file already exists. Do you want to overwrite it?");
                overWriteMsg.addAction(
                    "Yes", 
                    [imageViewer, fileName] => fn(imageViewer, fileName){
                        imageViewer.saveCurrentImageToFile(fileName);
                    });
                overWriteMsg.addAction("No");
                overWriteMsg.init();
            }
            else
                imageViewer.saveCurrentImageToFile(fileName);
        } 
    );
    diag.initialFilename = "";
    diag.init();
```
<!---END_CODESECTION--->

_Save File..._ saves the current image to the file it was loaded from.

<!---INCLUDE src=ImageViewer2.escript, start=197, end=200--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
if(!imageViewer.currentImage || !imageViewer.shownImageFile())
    return;
    
imageViewer.saveCurrentImageToFile(imageViewer.shownImageFile());
```
<!---END_CODESECTION--->

## Switching between the images of a folder
Next up we create the function for switching between the images of a folder.
To switch to the next (previous) image, we increase (decrease) _imageFolderIndex_ and load the corresponding image from _imagesInFolder_.
To ensure the index to be valid, we first check whether that it is in bounds before accessing the list.

<!---INCLUDE src=ImageViewer2.escript, start=247, end=251--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
if(!imageViewer.imagesInFolder || imageViewer.imageFolderIndex == 0)
    return;

imageViewer.imageFolderIndex--;
imageViewer.shownImageFile(imageViewer.imagesInFolder[imageViewer.imageFolderIndex]);
```
<!---END_CODESECTION--->


