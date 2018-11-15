/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2017 Florian Pieper <fpieper@mail.upb.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

//loading modules
static PathManagement = Std.module('Waypoints/PathManagement');
static DataTable = Std.module('LibUtilExt/DataTable');

//constants
static MEASURE_FRAMES = 20;
static MEASURE_ITERATIONS = 3;

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

//creating a camera path
var path = PathManagement.createPath();
var srt = new Geometry.SRT();
path.createWaypoint(srt, 0);
srt.setTranslation(new Geometry.Vec3(0, 0, -50)); 
path.createWaypoint(srt, 1);

//setting up the evaluator
var evaluator = new MinSG.StatsEvaluator;
evaluator.setCallGlFinish(true);
evaluator.setStatIndex(frameContext.getStatistics().getCounterForDescription("frame duration"));
evaluator.setNumberOfIterations(MEASURE_ITERATIONS);

var viewport = renderingContext.getViewport();
var values = [];

//measuring with fixed camera position
for(var frame = 0; frame < MEASURE_FRAMES; frame++){
 	evaluator.beginMeasure();
  	evaluator.measure(frameContext, scene, viewport);
  	evaluator.endMeasure(frameContext);
  
  	var value = evaluator.getResults().front();
  	
  	values += value;   
	PADrend.SystemUI.swapBuffers();
}

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

frameContext.popCamera();

//write result to a file
var dataTable = new DataTable("frame");
dataTable.addDataRow("time","ms",values);
dataTable.exportCSV(__DIR__ + "/result/frameTime.csv" , ",");
