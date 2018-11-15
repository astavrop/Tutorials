---
author: Henrik Heine, Stanislaw Eppinger
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 3.4
permalink: using_scripts_to_alter_the_rendering_of_nodes
subcategory: MinSG - A Minimalist Scene Graph
title: Using Scripts to alter the Rendering of Nodes
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
         Stanislaw Eppinger (eppinger@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->

# Using Scripts to alter the Rendering of Nodes

## ScriptedState
This chapter provides an example of a ScriptedState. This tutorial is the addition to the description of PADrend's States. It provides an example of how the states may be implemented in EScript. 

### Implementing a State in EScript

Typically you implement such a state by creating a new type that inherits from it. Furthermore you then override the two functions. If possible you should implement it 'stateless', which means that your `ScriptedState` should not have own instance variables that are modified by the methods. You should prevent this, because it might lead to problems if someone (accidentally) adds the same instance to different nodes.  

```
    var MyState = new Type(MinSG.ScriptedState);
    MyState.doEnableState @(override) ::= fn(node, rp) {
      // ...
      return MinSG.STATE_OK;
    };
    MyState.doDisableState @(override) ::= fn(node, rp) {
      // ...
    };
```

The following example simply skips rendering if the node is more than 20 units away from the camera. This is done by just calculating the difference between the given node and the camera node. If this distance is more than 20, the function returns `STATE_SKIP_RENDERING`, otherwise it just returns `STATE_OK` and everything continues as normal.

<!---INCLUDE src=ScriptedState.escript, start=14, end=35--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var sceneNode = new MinSG.ListNode();

// Define new ScriptedState
var MyState = new Type(MinSG.ScriptedState);
MyState.doEnableState @(override) ::= fn(node, rp) {
    var camPos = frameContext.getCamera().getWorldOrigin();
    var nodePos = node.getWorldPosition();
    var diff = (camPos - nodePos).length();
    if(diff > 20) return MinSG.STATE_SKIP_RENDERING;
    return MinSG.STATE_OK;
};

// create simple cube
var cube = new MinSG.GeometryNode(Rendering.MeshBuilder.createBox(new Geometry.Box(0,0,0,1,1,1)));
// add state to cube
cube += new MyState();
// add cube to scene
sceneNode += cube;

// activate scene
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
```
<!---END_CODESECTION--->

As you can see implementing a state in EScript is rather easy. For an implementation in C++ you should look at the example provided in the C++ DevGuide.

## NodeRendererState
The NodeRendererState is similar to a normal state. The difference is that this state needs to overload the `displayNode()` instead of the `doEnableState()` and that it calls the `displayNode()`method on all children of a node. The NodeRendererState acts as a renderer who handles the rendering of all the children. When registered at a node its `displayNode()` method will be called instead of the node's `display()` method. That way the state is able to provide its own rendering method for every node of the subtree.

### Rendering Channels
The NodeRendererState can be assigned to different rendering channels. What are rendering channels? The rendering of a node can happen in different channels. By default a node is assigned to the *default channel*, but it can also be assigned to the *approximation channel*. Then a node will only be rendered by the corresponding renderer. All nodes in the default channel will only be rendered by a renderer responsible for the default channel. The same goes for the approximation channel. 

### Simple Example
In this example we will create two cubes and attach our own NodeRendererState which let's them flicker.  
First of all we create the cubes and displace one.

<!---INCLUDE src=NodeRendererState.escript, start=15, end=16--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var cube1 = new MinSG.GeometryNode(Rendering.MeshBuilder.createBox(new Geometry.Box(0,0,0,1,1,1)));
var cube2 = new MinSG.GeometryNode(Rendering.MeshBuilder.createBox(new Geometry.Box(0,0,0,1,1,1)));
```
<!---END_CODESECTION--->

Now we create our own NodeRendererState and overload the `displayNode` method.

<!---INCLUDE src=NodeRendererState.escript, start=20, end=32--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//Create our own NodeRenderer and overload the displayNode method
var MyRendererState = new Type(MinSG.ScriptedNodeRendererState);
MyRendererState.displayNode @(override) ::= fn(node, rp){
    
    if(Rand.equilikely(0,10)>5){
        // Both lines are creating the same flickering effect
        // node.display(frameContext);
        return MinSG.FrameContext.PASS_ON;
    }
    return MinSG.FrameContext.NODE_HANDLED;
    
};
var flickerRenderer = new MyRendererState(MinSG.FrameContext.DEFAULT_CHANNEL);
```
<!---END_CODESECTION--->

The method has two parameters: `(Node owner, RenderParam params)`. The `node` parameter is the node on which the method is called and `param` contains further information about the rendering, e.g. the current rendering channel in which this node is in.  
Our `displayNode()` method creates a random number between 0 and 10. If it's higher than 5 than we return `MinSG.FrameContext.PASS_ON` which means that we pass the further rendering of the node to the node itself, i.e. the node calls its `display()` method afterwards. If it's lower or equal than 5 then we return `MinSG.FrameContext.NODE_HANDLED` which means that the rendering of the node has been handled and the `display()` method of the node will not be called afterwards.  
Note that we also could have called `node.display(frameContext)` instead of returning `MinSG.FrameContext.PASS_ON`.

At the end of the example we are creating the list node and adding our cubes and NoderRendererState to it. 

<!---INCLUDE src=NodeRendererState.escript, start=35, end=41--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
// Create new scene and add the flickerRenderer and the cubes to it
var sceneNode = new MinSG.ListNode();
sceneNode += flickerRenderer;
sceneNode += cube1;
sceneNode += cube2;
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
```
<!---END_CODESECTION--->

The resulting effect is that the cubes will start flickering. Note that both cubes are flickering because our renderer traverses the whole subtree of the list node and calls our overloaded `displayNode()` on every descendent node.

We could also assign our renderer to the approximation channel. To do that we create the renderer in the following way: 

```
    var flickerRenderer = new MyRendererState(MinSG.FrameContext.APPROXIMATION_CHANNEL);
```

Now our renderer will only consider nodes which are in this rendering channel. Try it out and you will see that the cubes are not flickering anymore because they are assigned to the default channel by default.

