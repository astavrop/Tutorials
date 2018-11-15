---
author: Florian Pieper
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 6
permalink: tree_queries
subcategory: MinSG - A Minimalist Scene Graph
title: Using TreeQueries to query MinSG Nodes
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Florian Pieper (fpieper@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->

# Tree queries
Tree queries are an useful tool.
They can be used to query the scene graph for specific nodes.
The queries them self are similar to XPath queries.

## Goal of this tutorial
In this tutorial you will learn about the tree query language.
At the end there is a small program which executes a few simple queries.

## Query language
The query language captures some parts of XPath (You can find more information on XPaht on [Wikipedia](https://en.wikipedia.org/wiki/XPath)).
However not all XPaht-axis are implement.
In addition there are some useful MinSG specific function added to the language.
Here you can see an example query:

    ./../child

From the current node it accesses the parent node and collects all child nodes of it.
As you can see this query is the same as it would be in XPath.
Below you find a list containing all the languages operators.

### Query operators
* _+_ : Addition operator.
* _*_ : Multiplication operator.
* _-_ : Difference operator.
* _/_ : As an infix operator: Devision operator.
* _/_prefix_ : As a prefix operator: Joins the parts of a query. The left hand side of the operator is used as input for the right hand side.
* _/_isolated_ : As an isolated operator: Collects the scenes root node.
* _//_ : Descendant or self: Collect all descendant nodes of the input nodes or the nodes them self.
* _|_ : Union. Unions two sets of nodes.
* _._ : Self. The current node.
* _.._ : Parant. The current node's parent node.
* _ancestor_ : Collects the input nodes ancestor nodes.
* _ancestor-or-self_ : Collects the input nodes ancestor nodes or the input nodes them self.
* _child_ : Collects all child nodes of a node.
* _descendant_ : Collects the input nodes descendant nodes.
* _descendant-or-self_ : Collects the input nodes descendant nodes or the input nodes them self.
* _parent_ : The current node's parent node.
* _root_ : Collects the root node.
* _self_ : Collects the current node.
* _union_ : Unions two sets of nodes
* _MinSG:collectGeometryNodes_ : Collects all geometry nodes in the subtree.
* _MinSG:collectListNodes_ : Collects all list nodes in the subtree.
* _MinSG:collectCameraNodes_ : Collects all camera nodes in the subtree.
* _MinSG:commonSubtree_ : Collects the ancestor node that is root of a subtree containing all passed nodes. If such a node does not exists, an empty set is returned.
* _MinSG:containingSemObj_ : Collects all semantic objects from the input nodes.
* _MinSG:collectRefId_ : Collects all nodes for which the identifier is in the subtree or an instance od the node with the identifier is in the subtree.
* _MinSG:id_ : Collects a node by its identifier. If the node does not exist, an empty set is returned.
* _MinSG:nAttrFilter_ : Collects nodes having some attributes. Either the attributes name or a combination of attribute name and value can be used as filter.
* _MinSG:collectByTag_ : Collects nodes sharing a common tag.

## Useful Functions
Now that we can write queries we need some functions that help us to execute them as well as automatically creating queries.
The query parsers offers such functions.
After a query-string was passed you get an executable tree-query.
If you execute a tree-query, it returns a set containing all nodes that match the query.
Keep in mind that the set may be empty if there are no matching nodes.  
There are two ways for performing a query.
First of all you can use the function _execute_.
It parses the query-string you pass to it, executes it and returns the result.  
The second way is doing this steps by hand.
Therefore you first need to create a context, which is needed for executing the query.
This context contains all parameters that are needed for executing the query.
Next up you use _parse_ to get an executable query.
The execution of a query is similar to a function call.
As parameter you use the context.

In the following you find a list of those functions.
* _parse(query)_ : Parses a query-string and returns an executable tree-query.
* _execute(query, sceneManager, ...params)_ : Executes a query-string and returns a set of matching nodes.
* _createContext(sceneManager, ...params)_ : Creates a context for executing a query.
* _createRelativeNodeQuery(sceneManager, source, target)_ :

## Example code
Lets go to a short example code that shows how to execute queries.
Before we can execute queries, we first need to import the corresponding module.

<!---INCLUDE src=TreeQuery.escript, start=14, end=14--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static TreeQuery = Std.module('LibMinSGExt/TreeQuery');
```
<!---END_CODESECTION--->

Next up there is a function for creating a scene graph on which we execute our queries.
The function creates a complete tree.
Each inner node is a _MinSG.ListNode_ and has three child nodes.
The leaf nodes are _MinSG.GeometryNode_'s and contain a sphere as mesh.
To each node an identifier is attached, so that we can print the results of a query.
The function creates the tree structure and returns the root node.

<!---INCLUDE src=TreeQuery.escript, start=16, end=53--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static createSceneGraph = fn(){
    var root = new MinSG.ListNode();
    var listNodes = [];
    listNodes += root;
    PADrend.getSceneManager().registerNode("root_node", root);
    
    for(var i = 0; i < 12; i++){
        listNodes += new MinSG.ListNode();
        PADrend.getSceneManager().registerNode("list_node" + i, listNodes[listNodes.size()-1]);
    }
    
    for(var i = 0; i <= 3; i++){
        for(var j = 1; j <= 3; j++){
            listNodes[i] += listNodes[i*3 + j];
        }
    }	
    
    var mesh = Rendering.MeshBuilder.createSphere(20, 20);
    var offset = 2;
    var x = 0;
    var y = 0;
    var nodeCounter = 0;
    
    for(var i = 4; i < listNodes.size(); i++){
        for(var j = 0; j < 3; j++){
            var node = new MinSG.GeometryNode(mesh);
            PADrend.getSceneManager().registerNode("geometry_node" + nodeCounter, node);
            listNodes[i] += node;
            node.setRelPosition(new Geometry.Vec3( x, y, 0));
            x += offset;
            nodeCounter++;
        }
        y += offset;
        x = 0;
    }
    
    return root;
};
```
<!---END_CODESECTION--->

We create two functions for executing queries.
Both have a parameter for passing the query-string and a start node.   
The first one uses the _execute_ function described above.
We need to pass at least three parameters to the function.
The first parameter is the query-string.
As a second parameter we need to pass a scene manager.
Therefore we collect PADrend's current scene manager by calling _PADrend.getSceneManager()_.
The third parameter is a list of start nodes.
We use a single start node for this example, but it is also possible to execute the query for multiple nodes.
For some queries (for example such that contain an attribute filter) you will need to pass a map of parameters.
This map can be passed as a fourth parameter.  
After executing the query we receive a set of nodes.
We use a print function to output their identifiers on the console.

<!---INCLUDE src=TreeQuery.escript, start=65, end=68--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static executeQuery = fn(query, startNode){
    var resultNodes = TreeQuery.execute(query, PADrend.getSceneManager(), [startNode]);
    printQueryResult(resultNodes);
};
```
<!---END_CODESECTION--->

The second functions uses the step wise method for executing the query.
First of all _createContext_ is used to create the context.
It receives all parameters that are passed to _execute_ except for the query-string.
Next up we create the executable query by calling _parse_ and passing the query-string to it.
In a third step we execute the query by calling it like a function.
We pass the context to it.
After that we again print the result to the console.

<!---INCLUDE src=TreeQuery.escript, start=70, end=76--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static executeQueryByHand = fn(query, startNode){
    var context = TreeQuery.createContext(PADrend.getSceneManager(), [startNode]);
    var executeableQuery = TreeQuery.parse(query);
    var resultNodes = executeableQuery(context);
    
    printQueryResult(resultNodes);
};
```
<!---END_CODESECTION--->

As mentioned before, _printQueryResult_ prints the identifiers of the nodes in the result set to the console.
Since there may be nodes that do not have an identifier, these are left out.
In addition also the number of nodes in the set is printed.

<!---INCLUDE src=TreeQuery.escript, start=55, end=63--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
static printQueryResult = fn(resultNodes){
    outln("Found " + resultNodes.toArray().size() + " result nodes");

    foreach(resultNodes as var node){
        var id = PADrend.getSceneManager().getNameOfRegisteredNode(node);
        if(id)
            outln(id);
    }
};
```
<!---END_CODESECTION--->

Before we can execute some queries, we first need to create a scene and register it to PADrend.

<!---INCLUDE src=TreeQuery.escript, start=78, end=80--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var root = createSceneGraph();
PADrend.registerScene(root);
PADrend.selectScene(root);
```
<!---END_CODESECTION--->

Next up we create three different queries.

<!---INCLUDE src=TreeQuery.escript, start=82, end=84--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
var query1 = "/child";
var query2 = "child";
var query3 = "./child";
```
<!---END_CODESECTION--->

The first query is an absolute one.
It starts at the root node and collects all of its children.
It is important to notice, that the root node is not the root node of our scene graph.
The root of our scene graph is a child of the scenes root.
Another child of this node is for example the global light source that imitates the sun.
We would not need to pass a start node for executing this query.
However the execution does not work, if no node is passed.
In contrast, the second query is relative to the node we pass as start node.
So it collects all child nodes of _root_, which are the first three list nodes we have created.  
The third query does the same as the second one.
It should show that we do not need to add a self operator to start a query at the passed node.  
We use our two execution functions to execute the queries.

<!---INCLUDE src=TreeQuery.escript, start=86, end=93--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
outln("Executing first query...");
executeQuery(query1, root);

outln("\nExecuting second query...");
executeQuery(query2, root);

outln("\nExecuting third query...");
executeQueryByHand(query3, root);
```
<!---END_CODESECTION--->

