---
author: Florian Pieper
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 2
permalink: creating_a_scene_using_minsg
subcategory: MinSG - A Minimalist Scene Graph@3
title: Creating a Scene using MinSG
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Florian Pieper (fpieper@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# Goal of this tutorial
This tutorial is about PADrend's scene graph.
You will learn to create a simple scene graph and register it to PADrend, so that it is displayed as active scene.

# MinSG
MinSG stands for minimal scene graph and represents the scene graph of PADrend.
Even it is stated to be minimal MinSG is very powerful.
The graph can be created by different nodes.
This tutorial concentrates on two node types and gives a simple example of creating a scene by using MinSG.

## Node class hierarchy

![Class hierarchy](nodes.png)

The base class of scene graph nodes is called _Node_.
It provides method that are common for all type of nodes.
For this tutorial we also need object of the class _ListNode_.
They are used as the inner nodes of the scene graph.
List nodes contain a list of child nodes.
Nodes can be added and removed dynamically.
The class of last type of nodes we need is _GeometryNode_.
A geometry node is capable of holding a mesh which is displayed when the node is traversed by the renderer.
Geometry nodes are leaf nodes in the scene graph.
In the following you will the most important methods of the different nodes.

### MinSG.Node

* `display(FrameContext[,Flags|RenderingParameter])` : Displays a node using a frame context. The rendering parameters are optional.
* `deactivate()` : Deactivates a node. Only activated nodes get displayed.
* `activate()` : Activates a node. Only activated nodes get displayed.
* `isActive()` : Returns _true_ if the node is active, _false_ elsewise.
* `hasParent()` : Returns _true_ if the node has a parent node (e.g. it is not the root node), _false_ elsewise.
* `getParent()` : Returns the parent node, if it exists.
* `getWorldBB()` : Returns the node’s bounding box ins world coordinates.
* `getBB()` : Returns the node’s bounding box.
* `hasFixedBB()` : Returns _true_ if the node has a fixed bounding box.
* `removeFixedBB()` : Removes a fixed bounding box from a node.
* `setFixedBB()` : Sets a fixed bounding box to a node. Normally the bounding box would adapt to the node’s size. In some cases it can be useful to set a fixed one.


* `hasTransformation()` : Returns _true_ if a transformation is set to the node, _false_ elsewise.
* `getWorldTransformationMatrix()` : Returns the transformation matrix (4x4) node->world.
* `getWorldTransformationSRT()` : Returns the transformation matrix node->world as SRT-object.
* `getWorldToLocalMatrix()` : Returns the transformation matrix (4x4) world->node.
* `setWorldTransformation(SRT)` Sets the node->world transformation matrix. Matrix is passed as SRT-object.
* `hasRelTransformationSRT()` : Returns _true_ if a relative transformation is set to the node, _false_ elsewise.
* `setRelTransformation(Matrix4x4|SRT)` : Sets the node->parent node transformation matrix. Matrix is passed as SRT-object or Matrix4x4.
* `getRelTransformationMatrix()` :  Returns the relative transformation matrix (4x4). The transformation is relative to the parent node’s coordinate system.
* `getRelTransformationSRT()` : Returns the relative transformation matrix as SRT-object. The transformation is relative to the parent node’s coordinate system.

* `isTransformationObserved()` : Returns _true_ if a transformation observer is set to the node, _false_ elsewise.
* `getRenderingLayers()` : Returns a bit mask, representing the rendering layers this node is visible on.
* `setRenderingLayers(Number)` : Setting a bit mask, representing the rendering layers the node is visible on.
* `testRenderingLayer(Number)` : Returns _true_ if the node is visible for the passed bit mask, _false_ elsewise.

* `removeStates()` : Removes all states from a node.
* `hasStates()` : Returns _true_ if the node contains states, _false_ otherwise.
* `addState(State)` : Adds the passed state to the node.
* `removeState(State)` : Removes the passed state from the node.
* `getStates()` : Returns a list containing all states.

* `moveRel(Vec3 | (x,y,z))` : Moves the node by a vector relative to the parent node's coordinate system. The vector can be passed by a _Geometry.Vec3_ or three values for x, y and z.
* `moveLocal(Vec3 | (x,y,z))` : Moves the node by a vector in its own coordinate system. The vector can be passed by a _Geometry.Vec3_ or three values for x, y and z.
* `setRelRotation(Vec3 dir,Vec3 up)` : Sets the node's rotation relative to the parent node's coordinate system. The rotation is passed by a direction and a up vector. Both are passed as _Geometry.Vec3_.
* `resetRelTransformation()` : Resets the relative transformation.
* `rotateRel_rad(float angle, (Vec3|x,y,z))` : Rotates the node relative to the parent node's coordinate system by an angle around some axis. The angle is passed as float value in radians, the axis is passed by a _Geometry.Vec3_ or three values for x, y and z.
* `rotateRel_deg(float deg, (Vec3|x,y,z))` :  Rotates the node relative to the parent node's coordinate system by an angle around some axis. The angle is passed as float value in degrees, the axis is passed by a _Geometry.Vec3_ or three values for x, y and z.
* `rotateLocal_rad(float angle, (Vec3|x,y,z))` : Rotates the node in its own coordinate system by an angle around some axis. The angle is passed as float value in radians, the axis is passed by a _Geometry.Vec3_ or three values for x, y and z.
* `rotateLocal_deg(float deg, (Vec3|x,y,z))` : Rotates the node in its own coordinate system by an angle around some axis. The angle is passed as float value in degrees, the axis is passed by a _Geometry.Vec3_ or three values for x, y and z.
* `getWorldOrigin()` : Returns the node’s origin within in world coordinates.
* `setWorldOrigin(Vec3)` : Sets the node’s origin within in world coordinates. The origin is passed as _Geometry.Vec3_.
* `getRelOrigin()` : Returns the node's origin relative to the parent node's coordinate system.
* `getRelPosition()` : Returns the node's position relative to the parent node's coordinate system.
* `setRelOrigin(Vec3)` : Sets the node's origin relative to the parent node's coordinate system.
* `setRelPosition(Vec3)` : Sets the node's position relative to the parent node's coordinate system.
* `rotateToWorldDir(Vec3 dir)` : Rotates the node to align with a direction vector given in world coordinates. The Vector is passed as _Geometry.Vec3_.
* `setRelScaling(number)` : Sets the scaling of the node relative to the parent node's coordinate system.
* `scale(number)` : Sets the scaling of the node.
* `getRelScaling()` : Returns the relative scaling of the node.

* `findNodeAttribute(string key)` : Returns the node's attribute with the given key, if it is available; otherwise, if the node's prototype is available and has the attribute, it is taken from there.
* `getNodeAttributes()` : Returns all node attributes as a map.
* `getNodeAttribute(string key)` : Returns a node's attribute with a given key.
* `isNodeAttributeSet(string key)` : Returns _true_ if a node's attribute is set.
* `removeNodeAttributes()` : Removes all attributes from a node.
* `setNodeAttribute(string key,value)` : Sets a node's attribute. The attribute needs to be addressed by a key.
* `unsetNodeAttribute(string key)` : Unsets a node's attribute, addressed by a key.
* `isClosed()` : Returns _true_ if the node (and its subtrees) represent an individually rendered object.
* `setClosed(bool closed)` : Closes / Opens a node. If a node is closed the node (and its subtree) represent an individually rendered object.
* `isTempNode()` : Returns _true_ if the node is not saved.
* `setTempNode(bool)` : Sets the node to be temporally.
* `localDirToWorldDir(Vec3)` : Transforms a direction passed in local coordinates into world coordinates.
* `localDirToRelDir(Vec3)` : Transforms a direction passed in local coordinates into relative coordinates (relative to the parent node's coordinate system).
* `localPosToWorldPos(Vec3)` : Transforms a position passed in local coordinates into world coordinates.
* `localPosToRelPos(Vec3)` : Transforms a position passed in local coordinates into relative coordinates.
* `relDirToWorldDir(Vec3)` : Transforms a direction passed in relative coordinates into world coordinates.
* `relDirToLocalDir(Vec3)` : Transforms a direction passed in relative coordinates into local coordinates.
* `relPosToWorldPos(Vec3)` : Transforms a position passed in relative coordinates into world coordinates.
* `relPosToLocalPos(Vec3)` : Transforms a position passed in relative coordinates into local coordinates.
* `worldDirToLocalDir(Vec3)` : Transforms a direction passed in world coordinates into local coordinates.
* `worldDirToRelDir(Vec3)` : Transforms a direction passed in world coordinates into relative coordinates.
* `worldPosToLocalPos(Vec3)` :  Transforms a position passed in world coordinates into local coordinates.
* `worldPosToRelPos(Vec3)` : Transforms a position passed in world coordinates into relative coordinates.
* `rotateAroundLocalAxis_deg(Number,Line3)` : Rotates the node by a angle, passed in degrees, arround an axis, passed in local coordinates.
* `rotateAroundLocalAxis_rad(Number,Line3)` : Rotates the node by a angle, passed in radians, arround an axis, passed in local coordinates.
* `rotateAroundRelAxis_deg(Number,Line3)` : Rotates the node by a angle, passed in degrees, arround an axis, passed in relative coordinates.
* `rotateAroundRelAxis_rad(Number,Line3)` : Rotates the node by a angle, passed in radians, arround an axis, passed in local coordinates.
* `rotateAroundWorldAxis_deg(Number,Line3)` : Rotates the node by a angle, passed in degrees, arround an axis, passed in world coordinates.
* `rotateAroundWorldAxis_rad(Number,Line3)` : Rotates the node by a angle, passed in radians, arround an axis, passed in world coordinates.

### MinSG.ListNode
Some of the methods are inherited from _GroupNode_.
* `addChild(MinSGNode child)` : Appends a child to the node.
* `countChildren()` : Returns the number of the node’s children.
* `removeChild(MinSGNode child)` : Removes the passed child from the node.
* `getChild(int index)` : Returns the child, addressed by an index.

### MinSG.GeometryNode
* `new MinSG.GeometryNode([Mesh])` : Constructor. Creates a new _GeometryNode_ and sets the passed mesh to it.
* `getGraphicsMemoryUsage()` : Returns the amount of memory the node occupies on the graphics card.
* `getMainMemoryUsage()` : Returns the amount of main memory the node occupies.
* `getMesh()` : Returns the mesh that is set to the node.
* `getTriangleCount()` : Returns the number of triangles the node’s mesh contains of.
* `getVertexCount()` : Returns the number of vertices the node’s mesh contains of.
* `hasMesh()` : Returns _true_ if the node contains a mesh, _false_ elsewise.
* `setMesh(mesh)` : Sets a mesh to the node.

## Creating a simple scene graph
Lets create a scene graph made of five nodes.
This is only a structural example of a scene graph.
To fill the graph with geometry, some cubes are created.
It is not important to understand the mesh creation, since it will be the main topic of another tutorial.

<!---INCLUDE src=SceneCreation.escript, start=14, end=24--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//building nodes
var rootNode = new MinSG.ListNode();
var listNode = new MinSG.ListNode();

var mesh1 = Rendering.MeshBuilder.createBox(new Geometry.Box(-2, 0, 0, 1, 1, 1));
var mesh2 = Rendering.MeshBuilder.createBox(new Geometry.Box(2, 0, 0, 1, 1, 1));
var mesh3 = Rendering.MeshBuilder.createBox(new Geometry.Box(0, 0, -2, 1, 1, 1));

var geometryNode1 = new MinSG.GeometryNode(mesh1);
var geometryNode2 = new MinSG.GeometryNode(mesh2);
var geometryNode3 = new MinSG.GeometryNode(mesh3);
```
<!---END_CODESECTION--->

First we need to create the nodes themselves.
This is simply done by instantiating objects.
For our scene we need two objects of the class _MinSG.ListNode_ and three of the class _MinSG.GeometryNode_.
Next up we connect the nodes to a tree similar to the one in the image bellow.

![Scene graph](scene_graph.png)

The simplest way to attach a node to a list node is by using  _+=_ operator.
But you can also use the method _addChild_.
The graph is created by adding _listNode_ and one of the geometry nodes to the root node.
Afterwards the two other geometry nodes are connected to the list node.

<!---INCLUDE src=SceneCreation.escript, start=34, end=39--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//Building the scene graph
rootNode.addChild(geometryNode1);
rootNode.addChild(listNode);

listNode += geometryNode2;
listNode += geometryNode3;
```
<!---END_CODESECTION--->

## Giving the nodes an id
We can provide a name(identifier) for each node.
This id's will show up in the _Node Editor_ and can help identifying specific nodes when the graph is traversed.

<!---INCLUDE src=SceneCreation.escript, start=26, end=32--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//giving nodes a unique id
PADrend.getSceneManager().registerNode("root", rootNode);
PADrend.getSceneManager().registerNode("some_list_node", listNode);

PADrend.getSceneManager().registerNode("geometry_node_1", geometryNode1);
PADrend.getSceneManager().registerNode("geometry_node_2", geometryNode2);
PADrend.getSceneManager().registerNode("geometry_node_3", geometryNode3);
```
<!---END_CODESECTION--->

You can give an id to a node by calling PADrend.getSceneManager().registerNode(_ID_, _NODE_).

## Providing meta data
The last step of this tutorial is to register the scene graph to PADrend, which will treat it as a scene.
Before we do that lets attach some meta data to the scene.
This step is optional, however it can be important to provide this information (i.e. for license reasons).
The meta data fields that can be set are:

* Title: The title of the scene.
* Creation Date: When was the scene created?
* Author: Who created the scene?
* License: The license the scene is shipped with. Possible values are "free", "internal use" and "RESTRICTED".
* Note: Some information about the scene.

Before we can set the meta data we first need to load the module containing the necessary functions.

<!---INCLUDE src=SceneCreation.escript, start=42, end=42--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var NodeMetaInfo = Std.module('LibMinSGExt/NodeMetaInfo');
```
<!---END_CODESECTION--->

For setting the current date, we first need to fetch it.

<!---INCLUDE src=SceneCreation.escript, start=43, end=43--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var date = getDate();
```
<!---END_CODESECTION--->

For each field the class _NodeMetaInfo_ contains a function to access it.
Each of these functions returns a data wrapper that can be used to set or read the field.
The node which should contain the meta data is passed as parameter.
We want to attach the meta data to the root node of our scene (_rootNode_).

<!---INCLUDE src=SceneCreation.escript, start=45, end=49--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
NodeMetaInfo.accessMetaInfo_CreationDate(rootNode)("" + date["year"] + "-"+ date["mon"] + "-" + date["mday"] );
NodeMetaInfo.accessMetaInfo_Title(rootNode)("Test Scene");
NodeMetaInfo.accessMetaInfo_Author(rootNode)("Max Mustermann");
NodeMetaInfo.accessMetaInfo_License(rootNode)("free");
NodeMetaInfo.accessMetaInfo_Note(rootNode)("Some info about the scene.");
```
<!---END_CODESECTION--->

## Registering the scene to PADrend
Lets register the scene and tell PADrend to display it.
Therefore PADrend offers the two functions _registerScene_ and _selectScene_.
We simply call first register and then select and pass the root node of our scene graph to them.

<!---INCLUDE src=SceneCreation.escript, start=51, end=54--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//Register the root node of the scene graph
PADrend.registerScene(rootNode);
//Selecting the root node to be the active scene
PADrend.selectScene(rootNode);
```
<!---END_CODESECTION--->

The scenes geometry will now be displayed.
You can use PADrend's _Main_-window to check the structure of the scene graph.

![Main window showing the scenes structure](main_window.png)



