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
static ImageCompareEvaluator = Std.module('ImageCompare/ImageCompareEvaluator');
static DataTable = Std.module('LibUtilExt/DataTable');

//constants
static MEASURE_FRAMES = 10;

//setting up path of the shaders needed for the comparing
var fileLocator = new Util.FileLocator();
fileLocator.addSearchPath("modules/MinSG/data/");
MinSG.AbstractOnGpuComparator.initShaderFileLocator(fileLocator);

//creating two scenes
var mesh1 = Rendering.MeshBuilder.createBox(new Geometry.Box(0, 0, -2, 1, 1, 1));
var mesh2 = Rendering.MeshBuilder.createSphere(50, 50);

var scene_1 = new MinSG.ListNode();
var geoNode = new MinSG.GeometryNode(mesh1);
scene_1 += geoNode;

var scene_2 = new MinSG.ListNode();
geoNode = new MinSG.GeometryNode(mesh2);
geoNode.moveLocal(new Geometry.Vec3(0, 0, -2));
scene_2 += geoNode;

PADrend.registerScene(scene_1);
PADrend.selectScene(scene_1);
PADrend.registerScene(scene_2);
PADrend.selectScene(scene_1);

//setting up the camera path
var path = PathManagement.createPath();
path.createWaypoint(PADrend.getActiveCamera().getWorldTransformationSRT(), 0);

var transform = PADrend.getActiveCamera().getWorldTransformationSRT();
var translation = transform.getTranslation();
transform.translateLocal(translation);
transform.rotateLocal_deg(45.0, new Geometry.Vec3(0,1,0));
transform.translateLocal(-translation);
path.createWaypoint(transform, 1);

//creating and setting up the evaluator
var evaluator = new ImageCompareEvaluator();
evaluator.setImageComparator(new MinSG.SSIMComparator());
evaluator.setScenes(scene_1, scene_2);

//setting up the camera for the measurement
var measurementCamera = PADrend.getActiveCamera().clone();
frameContext.pushCamera();

var values = [];

//measurement loop runs for a fixed number of frames
var progress = new Util.ProgressIndicator("Measuring", MEASURE_FRAMES, 0.1);
for(var frame=0; frame < MEASURE_FRAMES; ++frame) {
	var pathTime = path.getMaxTime() * frame / MEASURE_FRAMES;
  	measurementCamera.setWorldTransformation(path.getWorldPosition(pathTime));
  	frameContext.setCamera(measurementCamera);
  
  	// measure
  	evaluator.beginMeasure();
  	evaluator.measure(frameContext, PADrend.getRootNode(), renderingContext.getViewport(););
  	evaluator.endMeasure(frameContext);
  
  	var value = evaluator.getResults().front();
  	values += value;   
  
 	//optional output the images that were compared
 	//as well as the resulting difference image
 	Rendering.drawTextureToScreen(renderingContext, renderingContext.getViewport();,  [evaluator.getResultTexture()], [new Geometry.Rect(0, 0, 1, 1)]);
	PADrend.SystemUI.swapBuffers();
		
  	progress.increment();
}

//restore defaults
frameContext.popCamera();
PADrend.selectScene(scene_1);

//write results to file
var dataTable = new DataTable("frame");
dataTable.addDataRow("quality","",values);
dataTable.exportCSV(__DIR__ + "/result/measurments.csv", ",");

