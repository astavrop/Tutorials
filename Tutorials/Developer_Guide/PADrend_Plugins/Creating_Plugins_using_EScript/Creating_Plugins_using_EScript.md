---
author: Henrik Heine
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 1
permalink: creating_plugins_using_escript
subcategory: PADrend Plugins@3
title: Creating Plugins using EScript
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# Extending PADrend

## EScript Plugin Framework
The plugin framework is used to easily extend PADrend using EScript.
EScript plugins can change the behaviour of PADrend without compilation and partly at runtime.

## Plugin Definition
Every EScript plugin is defined by a simple *Plugin.escript* file inside a subfolder of a plugin directory. PADrend defines two different plugin directories inside its root directory:
1. *plugins* - used for PADrend's base EScript plugins
2. *extPlugins* - used for all external EScript plugins

If you want to extend PADrend with some custom plugin, you should add it to the *extPlugins* folder.
To do so, create a new subfolder inside it and name it as you wish. Inside that folder, you have to create a *Plugin.escript* file. PADrend will execute this file on startup in order to get some information about this plugin. Therefor this file should *not* define all functionality directly, but instead it should define some meta data as follows:
```javascript
static plugin = new Plugin({
		Plugin.NAME : 'MyTestPlugin', // ideally the same as the subdirectory this file is in
		Plugin.DESCRIPTION : 'This is just an example plugin.',
		Plugin.VERSION : 0.2,
		Plugin.AUTHORS : "Your Name",
		Plugin.OWNER : "Your Name",
		Plugin.LICENSE : "Some License",
		Plugin.REQUIRES : [ ], // will be explained later
		Plugin.EXTENSION_POINTS : [ ] // will be explained later
});

// This function will be called only if this plugin is marked as active
plugin.init @(override) := fn() {
	// here you can do the actual initalization of your plugin
	return true; // true means that we have initialized it without any errors
};

return plugin; // Important: You HAVE to return a plugin object
```
The plugin object defines some meta data, like the name and description of your plugin. On startup PADrend executes that file and can now display that meta data. As written in the comments, the *init* function is only called when your plugin is marked as *active*. This is done by the plugin manager inside PADrend. To access the plugin manager, click on the *Gear* icon -> *Plugins*. Now you can see all plugins and you can (de)activate them. After changing one or more active plugins, you have to restart PADrend.
![Plugins Overview](plugins.png)

If you have added your plugin correctly, you should now see it's name in the list. To activate it, you have to click on it and restart PADrend.

The asterisk (\*) behind a plugin name denotes that it is already loaded. You may have noticed, that there are some asterisks behind plugins that are not activated. This is due to the fact that they are loaded behind the scenes from other plugins. For examples the *PADrend* plugin is not activated, but it is used by many other plugins and therefor it is loaded automatically (see [Plugin.REQUIRES](#plugins.requires)).

## Plugin initialization
Now we want to add some more logic to our plugin. In most cases it might be a good idea to *not* add everything to the global namespace, but instead to a new namespace.
```javascript
...
plugin.init @(override) := fn() {
	declareNamespace($MyPlugin); // Define the namespace MyPlugin
	MyPlugin.someValue := 42; // now you can access the MyPlugin namespace
	load(__DIR__ + "/someOtherFile.escript"); // You can also execute other escript files from here
	return true;
};
...
```
As already mentioned, the *init* function is executed on startup, if the plugin is marked as active. Therefor you should only define classes and GUI components. Of course you could load a scene directly, but because the initialization is executed on every startup, it might be better to load a scene only on a button press.

## Plugin.REQUIRES <a id="plugin.requires"></a>
If your plugin depends on the functionality given by another plugin, you should add this dependency to the *Plugin.REQUIRES* array, like this:
```javascript
static plugin = new Plugin({
		Plugin.NAME : 'MyTestPlugin',
		Plugin.DESCRIPTION : 'This is just an example plugin.',
		Plugin.VERSION : 0.2,
		Plugin.AUTHORS : "Your Name",
		Plugin.OWNER : "Your Name",
		Plugin.LICENSE : "Some License",
		Plugin.REQUIRES : [ "PADrend/GUI", "Physics" ],
		Plugin.EXTENSION_POINTS : [ ] // will be explained later
});
```
In this example, PADrend will automatically load two other plugins:
* Physics (simple physics engine)
* PADrend/GUI (PADrends user interface)

PADrend will now make sure that all dependencies will be loaded on startup, so you don't have to activate them manually.
Obviously you should never define circular dependencies, otherwise PADrend won't be able to initialize.

## Plugin.EXTENSION\_POINTS
The extension point mechanism provides a global registry used to extend PADrend with an event based system. Plugins can define new extension points and fire them in an event like fashion. Any script can register to an extension point and will be notified if the event is fired.

An extension point should be defined as a plugin parameter like this:
```javascript
...
Plugin.EXTENSION_POINTS : [ 'MyExtension' ]
...
```

Other scripts can now register to listen for that event by registering a callback function:
```javascript
Util.registerExtension('MyExtension', someFunction);
```

To actually invoke an event the following mechanism is used:
```javascript
//Util.executeExtensions(name, params...);
Util.executeExtensions('MyExtension', 'someValue', 42, 'someOtherValue');
```

Now each callback function will be invoked with the given parameters.
A callback function can remove itself by returning the special value: `Util.EXTENSION_REMOVE`

### Flags
The behaviour of an extension point can be changed by adding additional flags to the definition. This is done by replacing the name of the extension with an array containing the name and the bitmask flag:
```
// without flag: Plugin.EXTENSION_POINTS : [ 'MyExtension' ]
// with flags:
Plugin.EXTENSION_POINTS : [ ['MyExtension', ExtensionPoint.ONE_TIME | ExtensionPoint.CHAINED] ]
```
The flags are described in the following sections

#### `ExtensionPoint.CHAINED`
The extension point is a "chain of responsibility". By default all callbacks will be called one after another. If the `CHAINED` flag is set and a callback either returns `true` or `Util.EXTENSION_BREAK`, then the extension was handled and therefore all other callbacks won't be processed. A chained handler could also return `Util.EXTENSION_BREAK_AND_REMOVE`, which would result in the same behaviour as above, but also removes the callback.

#### `ExtensionPoint.THROW_EXCEPTION`
If an extension throws an exception, this error is only logged to the console and the processing continues. If the `THROW_EXCEPTION` flag is set, each exception will be rethrown and therefore the processing of this extension is stopped.

#### `ExtensionPoint.ONE_TIME`
All callbacks for this extension are only executed once and then they will be removed.

#### `ExtensionPoint.DEPRECATED`
The extension point should no longer be used, because it is deprecated. When registering an extension, a warning is shown.


