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

static PM = Std.module('Waypoints/PathManagement');
static pathFile = __DIR__ + "/test.path";

var scene = new MinSG.ListNode();
var mesh = Rendering.MeshBuilder.createBox(new Geometry.Box(2, 0, -4, 1, 1, 1));
var node = new MinSG.GeometryNode(mesh);
scene += node;

PADrend.registerScene(scene);
PADrend.selectScene(scene);

var pathNode = void;

if(IO.isFile(pathFile)){
	outln("Loading path from file...");
	pathNode = PM.loadPath(pathFile);
	scene += pathNode;
}
else{
	outln("Creating path...");
	pathNode = PM.createPath(scene);
	PM.activatePath(pathNode);
	
	PADrend.getActiveCamera().getWorldTransformationSRT().translateLocal(new Geometry.Vec3(0, 1 ,0));
	
	PM.createWaypointAtCam(0);
	
	var transform = PADrend.getActiveCamera().getWorldTransformationSRT();
	transform.translateLocal(new Geometry.Vec3(0, 0 ,-10.0));
	transform.rotateLocal_deg(-90.0, new Geometry.Vec3(0,1,0));
	
	PM.createWaypoint(transform, 3);
	
	transform.translateLocal(new Geometry.Vec3(0, 0 ,-10.0));
	transform.rotateLocal_deg(-135.0, new Geometry.Vec3(0,1,0));
	
	PM.createWaypoint(transform, 6);
	
	PM.closeLoop();
	
	PM.setTimecodesByDistance(pathNode, 3);
}

PM.showPath(true);

PM.animation_active(true);

PM.savePath(pathFile);
