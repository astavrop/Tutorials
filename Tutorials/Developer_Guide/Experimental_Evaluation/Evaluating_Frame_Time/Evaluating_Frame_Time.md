---
author: Florian Pieper
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 3
permalink: evaluating_frame_time
subcategory: Experimental Evaluation
title: Evaluating Frame Time
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Florian Pieper (fpieper@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# Frame Time Measurement
This tutorial is about evaluating the time PADrend needs to render frames.
You can use this to empirically evaluate the runtime of your rendering algorithms.

## In this tutorial
In this tutorial you should learn how to use the _StatsEvaluator_ to measure the frame time.

## Code walkthrough

### Loading modules
We need to load two modules before we can start.
This modules have nothing to do with the measurement itself.
First of all we need the _PathManagement_ module, which allows us to set up a camera path.
During the measurement we will move the camera along the camera path, so that we get different measurement depending on the viewpoint.  
Next up we also load the _DataTable_ module.
It allows us to save the results of the measurement in form of a CSV file.

<!---INCLUDE src=MeasureFrameTime.escript, start=14, end=16--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//loading modules
static PathManagement = Std.module('Waypoints/PathManagement');
static DataTable = Std.module('LibUtilExt/DataTable');
```
<!---END_CODESECTION--->

### Creating a scene
We use a number of cubes for our test scene.
There will be 30x30x30 cubes with some space inbetween them.
This should be enough polygons to create work for the graphics card and let the frame rate drop.
However you can also increase the number of cubes.
We use three for loops to create the cubes and order them in a pattern.
Each cube is contained in a _GeometryNode_ which gets added to the scene.
Note that the scene creation may take a few seconds.
After the scene was created, we register it to PADrend and set it active.

<!---INCLUDE src=MeasureFrameTime.escript, start=22, end=39--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//creating the scene
var scene = new MinSG.ListNode();
var maxNode = 30;
var node = null;
var mesh = null;

for(var x = -maxNode; x < maxNode; x+=2){
    for(var y = 0; y < 2*maxNode; y+=2){
        for(var z = 5; z < (2*maxNode) + 5; z+=2){
            mesh = Rendering.MeshBuilder.createBox(new Geometry.Box(x, y, -z, 1, 1, 1));
            node = new MinSG.GeometryNode(mesh);
            scene += node;
        }
    }
}

PADrend.registerScene(scene);
PADrend.selectScene(scene);
```
<!---END_CODESECTION--->

### Setting up a camera path
We want the camera path to start in front of the cubes.
The camera should than move straight into the cubes, so that along the path the number of cubes in the view frustum decreases.
Due to frustum culling, this should also decrease the rendering time per frame.
We create two way points.
The first one is just an empty _SRT_ (no translation/rotation of the camera).
For the second way point we translate the camera along the z-axis, so that it should stand near to the end of the cubes.

<!---INCLUDE src=MeasureFrameTime.escript, start=41, end=46--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//creating a camera path
var path = PathManagement.createPath();
var srt = new Geometry.SRT();
path.createWaypoint(srt, 0);
srt.setTranslation(new Geometry.Vec3(0, 0, -50)); 
path.createWaypoint(srt, 1);
```
<!---END_CODESECTION--->

### Setting up the evaluator
Next up we create the evaluator by instantiating an object of type _MinSG.StatsEvaluator_.
By calling _setNumberOfIterations_ we tell the evaluator how often it should measure the frame time for a single measurement.
The actual frame time will be the median of these values.  
If we call _setCallGlFinish_ with _true_ the evaluator will call GLFinish after each frame.  
The evaluator is able to measure different statistics of a frame.
By calling _setStatIndex_ we tell him what we want to measure.
Possible values are:

* _"frame number"_ : Number of the current frame
* _"frame duration"_ : Time needed to render the frame in milliseconds
* _"VBOs rendered"_ : Number of renderer vertex buffer objects in the frame
* _"triangles rendered"_ : Number of triangles rendered in the frame
* _"lines rendered"_ : Number of lines rendered in the frame
* _"points rendered"_: Number of points rendered in the frame
* _"geometry nodes rendered"_ : Number of geometry nodes rendered in the frame
* _"I/O rate read"_ : Rate of I/O read operations in MiB/s
* _"I/O rate write"_ : Rate of I/O write operations in MiB/s

For our example we need _"frame duration"_ since we want to measure the frame time.
The last thing we need to do before measuring is to create an array for collecting the  measurements

<!---INCLUDE src=MeasureFrameTime.escript, start=48, end=55--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
//setting up the evaluator
var evaluator = new MinSG.StatsEvaluator;
evaluator.setCallGlFinish(true);
evaluator.setStatIndex(frameContext.getStatistics().getCounterForDescription("frame duration"));
evaluator.setNumberOfIterations(MEASURE_ITERATIONS);

var viewport = renderingContext.getViewport();
var values = [];
```
<!---END_CODESECTION--->

### The measurement loops
We measure the frame times by two loops.
Each loop runs for a fixed number of frames, which is set by a constant.
The first loop measures the frame time for a fixed camera position.
We do this in a loop, so that we can eventually come up with mean value.
In the second loop we measure along a camera path.
For each frame the camera will moved a bit.  
At the start of the measurement we call _beginMeasure_.
This will reset all values of the previous measurement.
Than we call _measure_ to execute the measurement and pass the frame context, the scene and the viewport to it.
To finalize the meausrement we call _endMeasure_.
We collect the meausred value by calling _evaluator.getResults().front()_ and add it to our array.

<!---INCLUDE src=MeasureFrameTime.escript, start=56, end=66--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js

//measuring with fixed camera position
for(var frame = 0; frame < MEASURE_FRAMES; frame++){
     evaluator.beginMeasure();
      evaluator.measure(frameContext, scene, viewport);
      evaluator.endMeasure(frameContext);
  
      var value = evaluator.getResults().front();
      
      values += value;   
    PADrend.SystemUI.swapBuffers();
```
<!---END_CODESECTION--->

In addition we need to move the camera in the second loop.
Before the loop we create a clone of the current camera.
We will move this clone instead of the current camera, so that its viewport is preserved.
Therefore we save it by pushing it to the camera stack.  
In the loop we calculate the position within the camera relative to the current iteration.
We set the camera to the relative position of the camera path and activate it.
The measuring works like in the last loop.  
After we are done with the loop, we restore the old camera.

<!---INCLUDE src=MeasureFrameTime.escript, start=68, end=87--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js

//measuring along a camera path
var measurementCamera = PADrend.getActiveCamera().clone();
frameContext.pushCamera();

for(var frame = 0; frame < MEASURE_FRAMES; frame++){
    var pathTime = path.getMaxTime() * frame / MEASURE_FRAMES;
      measurementCamera.setWorldTransformation(path.getWorldPosition(pathTime));
      frameContext.setCamera(measurementCamera);
  
     evaluator.beginMeasure();
      evaluator.measure(frameContext, scene, viewport);
      evaluator.endMeasure(frameContext);
  
      var value = evaluator.getResults().front();
      
      values += value;   
    PADrend.SystemUI.swapBuffers();
}

```
<!---END_CODESECTION--->

### Store results to disk
We will store the results as CSV file.
So it can be processed by tools like Excel.
Therefore we create a _DataTable_ that contains of two columns.
We apply the name of the first row by passing it in the constructor call.
Than we add another column and add our values to it.
Next up we store the data table to a file.

<!---INCLUDE src=MeasureFrameTime.escript, start=89, end=92--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js

//write result to a file
var dataTable = new DataTable("frame");
dataTable.addDataRow("time","ms",values);
```
<!---END_CODESECTION--->
