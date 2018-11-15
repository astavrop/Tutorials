---
author: Sascha Brandt
category: Developer Guide
last_updated: November 14, 2018
license: cc-by-sa 4.0
order: 2
permalink: extending_your_plugin_with_c++
subcategory: PADrend Plugins
title: Extending your Plugin with C++
---
<!------------------------------------------------------------------------------------------------
 This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Sascha Brandt (sascha@brandt.graphics)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->

In this guide, it is shown how to properly setup a C++ Plugin Project, i.e., how to create a C++ Plugin library and load it from within an EScript Plugin.
There are two possibilities to create a Plugin Project. 
You can either use an existing PADrend installation and create a separate project folder for your project (more involved), or you can simply build your project together with the PADrend source.
For simplicity, we will use the second approach in the following guide.
You should already be familiar how to build PADrend from source and have a working PADrend folder (see [Installation Guide](installation_guide)).
You can follow this guide to setup your project or checkout the ready-to-go [Example Project](https://git.cs.upb.de/algoCG/ExampleProject) and modify it to your liking (the *ExampleProject* contains a little more functionality than this tutorial, like automatically setting the project name in `CMakeLists.txt` and `Main.cpp` based on your folder name).
Furthermore, this guide assumes that you are using CMake to build PADrend (instead of a *ekki* script with CodeBlocks).

## Setting up your Project 

We start by creating a new folder `MyProject` (your project name here) in the PADrend root folder.
In this folder create a new folder `src` for your c++ sources and a new folder `plugins` for your EScript plugins.
Since we are using CMake, we need to create a `CMakeLists.txt` file in your project folder with the following content:

<!---INCLUDE src=files/MyProject/CMakeLists.txt, start=7, end=24--->

This creates a basic c++ library project.
You can add further source files under `addLibrary(...)`.
You also need to link your library to the EScript library and other PADrend libraries you want to use, like `MinSG` or `Geometry`.
To add the libraries, simply add the following lines to your `CMakeLists.txt` file, to link to all recommended PADrend libraries:

<!---INCLUDE src=files/MyProject/CMakeLists.txt, start=26, end=80--->

For our purposes, it would be enough to just include the line `target_link_libraries(${PROJECT_NAME} LINK_PUBLIC <LibraryName>)` for each library, since we compile it together with the rest of PADrend.
The lines between the *if*-statements (`if(NOT TARGET ...) find_package(...)`) are required for when you build your project separately from PADrend and are included here for completeness.

Now that we have everything set up for building, we can start with the c++ code.
We first need to create an entry point for the EScript library loader.
For this, create the file `Main.cpp` in your `src` folder with the following content:

<!---INCLUDE src=files/MyProject/src/Main.cpp, start=7, end=31--->

The most important line is `extern "C" void initLibrary(EScript::Namespace* lib)`.
The library loader searches for the entry point *initLibrary* and then executes it together with the global EScript namespace as parameter.
The `extern "C"` part is used to mark this method as a *c*-method.
This is required by the library loader, since c++ entry point names are much more complicated and can be different for each compiler.

The given code first looks if the namespace of your library is already declared and gives an error message if this is the case.
Otherwise, you might run into unpredictable side effects if you accidentally try to load the library twice.
Then, the code creates a new EScript namespace for your library (named `MyProject`) and calls the initializer method for your EScript bindings `MyProject::init(ns)`.
This could also be done directly in the `initLibrary` method, but it is recommended to initialize your bindings in a different file with your own namespace.

Now we create the files `ELibMyProject.h` and `ELibMyProject.cpp` in your `src` folder for initializing your EScript bindings.
You don't have to touch the `CMakeLists.txt` and `Main.cpp` in this case, since we already included them.
For other c++ source files, you would also have to add them in the `CMakeLists.txt` under `add_library`.

The header file `ELibMyProject.h` just contains the declaration of the initializer method inside your own namespace:

<!---INCLUDE src=files/MyProject/src/ELibMyProject.h, start=7, end=21--->

In the implementation of our initializer method (in `ELibMyProject.cpp`) we create a simple `helloWorld` function which just prints "Hello World!" to the console and create an EScript binding for it, so that we can call the function drom within EScript using `MyProject.helloWorld()`:

<!---INCLUDE src=files/MyProject/src/ELibMyProject.cpp, start=7, end=30--->

EScript bindings are defined using macros, e.g., `ES_FUNCTION(...)`. 
How exactly these macros work is shown in the next Tutorial.
Here, it is sufficient to know that the macro defines the EScript function `helloWorld` (without parameters) in the namespace `MyProject` and calls the c++ function `helloWorld()`.
Further, more complicated examples are shown in the next tutorials.

This concludes the c++ part of our simple c++ project and we can now build the library and create an EScript plugin that loads it.

## Building your Project

We first have to signalize CMake to include your new project folder in the build process of PADrend (not really necessary, but makes life easier).
This can be done by simply adding the line `add_subdirectory(MyProject)` to the `CMakeLists.txt` file in the PADrend root folder.

Now, you can build PADrend as usual (see [Installation Guide](../../../1_Installation_Guide/1_Installation_Guide.md)), e.g., by invoking `make` in the *build* directory.
You should now have a new library `libExampleProject.so` (Linux), or `libExampleProject.dll` (Windows) in your *build* directory. 

## Loading your Plugin Library

We are now ready to create an EScript plugin and load our c++ library.
See [Installation Guide](../../1_EScript/2_PADrend_Basics/2_EScript_Plugin/EScript_Plugin.md) for a detailed introduction to EScript plugins.
We create a new folder `MyProject` in the `plugins` folder of our project and create a new file `Plugin.escript` with the following content:

<!---INCLUDE src=files/MyProject/plugins/MyProject/Plugin.escript, start=7, end=34--->

In the line `static loader = new (Std.module("LibUtilExt/LibraryLoader"));` we first create a new instance of the *LibraryLoader* module, that handles searching and loading for our new library file, which is done by invoking `loader.loadLibary("libMyProject")`.
Normally, the loader searches your *build* directory and some other standard directories for the library file.
If you want to move your library file to a different location, e.g., a *lib* folder inside your plugin folder, you need to add this folder to the search path of the *LibraryLoader* by, e.g., `loader.addSearchPath(__DIR__ + "/lib/")`.

After your library was successfully loaded, you can simply call your function by invoking `MyProject.helloWorld()`.
The only thing that remains is, to add your plugin folder to PADrend and activate your plugin.
You can add your plugin folder by modifying the file `config.json` in the PADrend root folder (You need to run PADrend once to create it).
Search for the entry `"PADrend"->"Paths"->"plugins"` and add the path to your plugin folder (the trailing "/" is required):

```javascript
{
    ...
    "Paths":{
      "data":"data/",
      "plugins":[
        "plugins/",
        "MyProject/plugins/"
      ],
      "scene":"data/scene/",
      "user":"./"
    },
    ...
}
```

You should now be able to run PADrend and activate your plugin under `Config (the gear symbol)->Plugins->MyProject`.
If you then restart PADrend, you should see a "Loading Library: MyProject..." followed by "Hello World!" in the console somewhere inbetween the plugin initializations.

```
Initializing MyProject...
Loading Library: MyProject...
Hello World!
```

Congratulation! You successfully created a PADrend c++ plugin and can now continue to extend it using the following tutorials.
