---
author: Florian Pieper
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 1
permalink: working_with_files
subcategory: Networking and the File System@7
title: Working with Files
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Florian Pieper (fpieper@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->

# Folder Traversal
This tutorial shows some basic file handling operations.
Also it gives an overview about Escript's and PADrend's input/output library.

## Traversing a folder tree
In our example we use a breadth first traversal strategy.
The algorithm works similar to the one you would use for arbitrary trees (trees with a variable number of child nodes).
In each step we have to decide whether we process a leaf node or an inner node.
In terms of file systems leaf nodes are files.
If we reach a file, we output its content on the console.
Whenever we reach an inner node (in our context this is a folder), we need to traverse all of its child nodes.
Therefore we collect the content of a folder and push it to the queue of not yet processed nodes.
So much for the general procedure.
In the following you find the corresponding Escript code of the algorithm.

<!---INCLUDE src=FileTraversal.escript, start=20 ,end=40--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static traverseFolder = fn(rootFolder){
    var queue = [rootFolder];
    
    while(!queue.empty()){
        var f = queue.popFront();
    
        if(IO.isFile(f)){
            outln("Found a file: " + f);
            printFile(f);
        }
        
        if(IO.isDir(f)){
            outln("Found a folder: " + f);
            
            var content = IO.dir(f, IO.DIR_BOTH);
            foreach(content as var entry){
                queue += entry;
            }
        }
    }
};
```
<!---END_CODESECTION--->

In the first line of the code we create a queue holding all not yet processed files.
Initially we push the root folder to the queue.
Note that the queue holds file paths (so basically strings).
The while loop in the continuous until the stack empty (in other words: the loop runs as long as there are still unprocessed files).
Within the loop, we first collect the first path from the queue.
This path will be processed next.
Next up we decide whether the path leads to a file or a folder.
Therefore we use the functions `IO.isFile(path)` and `IO.isDir(path)`.  
If we are processing a file, a function, that will be explained later on, is used to output the files content.
Since files are leaf nodes, there is no further processing needed.
If the path leads to a folder we need to collect the folders content.
We can use `IO.dir(path, mode)` to grep the content.
It returns the content a list of paths, representing the children of the folder.
As modes we can use `IO.DIR_DIRECTORIES`, `IO.DIR_FILES` and `IO.DIR_BOTH` to tell the functions that it should only collect entries that are directories, entries that are files or the complete content of the folder.
Next up we add each add the content of the folder to the queue and do the next iteration of the loop.
At some point we will not find new files, so that the queue will run empty and the loop terminates.

## Alternative solution
Remember the modes, we described in the previous section?
There is also a fourth mode: `IO.DIR_RECURSIVE`.
It can be combined with the other modes by the or operator.
In this mode the function will return not only the child nodes but all descendant nodes in the file hierarchy.
This makes life a bit easier, since we do not have to care about implementing a recursive tree walk.

<!---INCLUDE src=FileTraversal.escript, start=42 ,end=54--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static traverseFolderAlternative = fn(rootFolder){
    var c = IO.dir(rootFolder, IO.DIR_RECURSIVE|IO.DIR_BOTH);
    foreach(c as var f){
        if(IO.isFile(f)){
            outln("Found a file: " + f);
            printFile(f);
        }
            
        if(IO.isDir(f)){
            outln("Found a folder: " + f);
        }
    }
};
```
<!---END_CODESECTION--->

## Accessing the content of a file
Accessing the content of a file using Escript is simple.
You do not need to mess around with stream.
A simple call of the function `IO.loadTextFile(path)` will return the content as string.

<!---INCLUDE src=FileTraversal.escript, start=14 ,end=18--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static printFile = fn(filePath){
    var fileContent = IO.loadTextFile(filePath);
    outln("Content of file " + filePath + ":");
    outln(fileContent);
};
```
<!---END_CODESECTION--->

## Executing the functions
Calling the functions is pretty straight forward.
One thing to mention here is the constant `__DIR__`.
It always contains the working directory, so the directory in which the executed Escript file is located.
Keep in mind to also copy the test folder into the directory that contains the script of this tutorial, as it may not be found otherwise.

<!---INCLUDE src=FileTraversal.escript, start=57 ,end=60--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var rootFolder = __DIR__ + "/test_folder";
traverseFolder(rootFolder);
outln("\n________________________________________\n");
traverseFolderAlternative(rootFolder);
```
<!---END_CODESECTION--->

## IO library
In the following you will find the functions, shipped with the IO library.
What may be a bit strange, is the fact that there are two places where the functions are declared.
Some are shipped directly with Escript, some can be found in the Util library of PADrend.
Both libraries overlap a bit, so that there may be two functions doing the same job.

### Escript library
Functions:
* `IO.saveTextFile(path, text)`: Saves the text string in the file given by the path.
* `IO.loadTextFile(path, [format])`: Loads a file found at the path and returns it as string. Optional the format of the file can be passed (e.g. UTF8).
* `IO.makeDir(path)`: Creates a directory at the given path.
* `IO.dir(path, [mode])`: Collects the content of a directory and returns it as array. The content can be filtered by the mode flag (see constants below).
* `IO.isDir(path)`: Returns true if path leads to a directory.
* `IO.isFile(path)`: Returns true if path leads to a file.
* `IO.fileMTime(path)`: Returns the last time the file was modificated in the unix time format.
* `IO.fileSize(path)`: Returns the size of a file given by the path in bytes.
* `IO.dirname(path)`: Returns the path of the folder containing the file given by path.

Constants:
* `IO.DIR_FILES`: Flag indicates to return files only.
* `IO.DIR_DIRECTORIES`: Flag indicates to return directories only.
* `IO.DIR_BOTH`: Flag indicates to return files and directories.
* `IO.DIR_RECURSIVE`: Flag indicates to return all descendant files of a directory.

### PADrend's Util library
Functions:
* `Util.copyFile(srcPath, destPath)`: Copies a file from a source path to a destination path.
* `Util.createDir(path)`: Creates a directory at a given path.
* `Util.removeFile(path, [recursive = false])`: Deletes the file given by path. For directories the recursive flag is useful to remove the directory and its content.
* `Util.dir(path, [mode = DIR_FILES])`: Collects the content of a directory and returns it as array. The content can be filtered by the mode flag (see constants below).
* `Util.fileSize(path)`: Returns the size of a file given by the path in bytes.
* `Util.flush(fileSystem)`: If some kind of internal caching is used, all data should be written to disk. Note: may block if needed
* `Util.generateNewRandFilename(path, prefix, postfix, length)`: Generates a random file name, located in the directory given by path. The part inbetween the pre- and postfix is generated. Size indicates the number of chars that are added inbetween.
* `Util.isFile(path)`: Returns true if path leads to a file.
* `Util.isDir(path)`: Returns true if path leads to a directory.
* `Util.loadFile(path)`:  Loads a file found at the path and returns it as string.
* `Util.openFile(path)`: Opens a file found at path and returns a file input stream.
* `Util.saveFile(path, text, [overwrite = true])`: Saves the text string in the file given by the path. The overwrite flag can be used to prevent overwriting.

Constants:
* `Util.DIR_FILES`: Flag indicates to return files only.
* `Util.DIR_DIRECTORIES`: Flag indicates to return directories only.
* `Util.DIR_RECURSIVE`: Flag indicates to return all descendant files of a directory.
* `Util.DIR_HIDDEN_FILES`:  Flag indicates to return hidden files only.
