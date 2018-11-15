---
author: Henrik Heine, Stanislaw Eppinger
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 3
permalink: introduction_to_states
subcategory: MinSG - A Minimalist Scene Graph
title: Introduction to States
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
         Stanislaw Eppinger (eppinger@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# States
This chapter will explain PADrend's states and how to use them. To understand this chapter you should at least have a basic understanding of MinSG (Minimal SceneGraph) and its Nodes. You can find an EScript example in the Node States folder and a C++ example in the C++ folder.

## What are States?

The two most important methods which the state class provides are the `doEnableState()` and `doDisableState()` methods. Every Node in the scene graph can contain arbitrary many states. When a node is rendered, i.e. its `display()` method is called, all its states are enabled in the order which they have been assigned to the node in the first place. Then the node's `doDisplay()` method gets called and afterwards the states are getting disabled again. Both methods have two parameters: `(Node owner, RenderParam params)`.

The `node` parameter of course is the node for which this state is en-/disabled. The second parameter contains some information about the rendering itself. For example, flags and the rendering layers.

The explained mechanism allows the user to execute code before a node gets rendered. Usually states are used to alter the rendering context for the current node as well as the whole subtree. For example, the **ShaderState** activates a shader and pushes it on the current rendering context so that the node and its subtree are rendered with the activated shader. Afterwards when the state gets disabled it removes the shader from the rendering context. Similary the **LightingState** activates a light source which is used while rendering the node and its subtree and removes it when disabled.

Speaking from a technical point of view the **State** class is an abstract class which provides an interface. To create your own state in C++ you need to inherit from the class and override the `doEnableState()` since it is a pure virtual method.

## States and their Behavior

The `doEnableState()` has a return value which defines how the state will be handled further. When overriding this method you need to decide what value your states needs to return in the particular situation. There are four possible return values defined in the enum `State::stateResult_t`.

##### STATE_OK
The state has been enabled and therefore needs to be disabled for the node. After rendering the node and its subtree the `doDisableState()` method will be called.

##### STATE_SKIPPED
The state is not enabled, e.g. due to an error and therefore the `doDisableState()` will not be called after rendering the node.

##### STATE\_SKIP\_OTHER\_STATES
This return value acts like *STATE_OK*, i.e. it signals that the state has been enabled and therefore the `doDisableState()` method will be called after rendering the node. The difference is that all other states which have not been enabled yet are going to be skipped. So be careful in which order you assign your states to your node, when using this return value.

##### STATE\_SKIP\_RENDERING
This return value signals the node that it should not be rendered, i.e. after enabling this state the node (and its subtree) will not be rendered. This situation might occur when the state handles the rendering of the node itself.  
After the call, the state is not active for that node, so `doDisableState()` must not be called for that node.

##### The following paragraph will describe States and how they are implemented in more detail:

The **State** class has the following methods which we will discuss in more detail:  
* `enableState()`  
* `disableState()`  
* `doEnableState()`  
* `doDisableState()`  

`enableState()` and `disableState()` are mere wrappers for `doEnableState()` and `doDisableState()` which are basically checking if the state is active or inactive and then accordingly call the corresponding method. A state can basically be *active* or *inactive*. This can be controlled via the methods `activate()` and `deactivate()`. A deactivated state will be skipped when the scene graph calls `enableState()` on it.

`doEnableState()` is a private pure virtual method in the **State** class. `doDisableState()` is a private virtual  
method which defines no code to execute. Thus, when designing your own **State** you will need to override `doEnableState()` and are free to do so for `doDisableState()`.