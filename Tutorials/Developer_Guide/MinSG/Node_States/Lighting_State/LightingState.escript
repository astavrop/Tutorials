/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2016 Florian Pieper <fpieper@mail.upb.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

//Use the lighting state or just enable the light source? 
var useLightingState = true;

//creating the scene nodes
var scene = new MinSG.ListNode();

var mesh = Rendering.MeshBuilder.createSphere(50, 50);
var node = new MinSG.GeometryNode(mesh);
node.moveLocal(new Geometry.Vec3(-2, 0, 0));
var node2 = new MinSG.GeometryNode(mesh);
node2.moveLocal(new Geometry.Vec3(2, 0, 0));

//creating a new light node
var pointLightNode = new MinSG.LightNode(MinSG.LightNode.POINT);
//setting the light color
pointLightNode.setAmbientLightColor(new Util.Color4f(1.0, 0.0, 0.0, 1.0));
pointLightNode.setSpecularLightColor(new Util.Color4f(1.0, 0.0, 0.0, 1.0));
pointLightNode.setDiffuseLightColor(new Util.Color4f(1.0, 0.0, 0.0, 1.0));
//move the lightsource above the scene
pointLightNode.moveLocal(new Geometry.Vec3(0, 5, 0));

//create the scene graph
scene += node;
scene += node2;
scene +=pointLightNode;

if(useLightingState){
	//if using the LightingState, create one, attache the light node to it,
	//activate it and add it to one of the geometry nodes 
	var state = new MinSG.LightingState(pointLightNode);
	node.addState(state);
	state.setEnableLight(true);
}
else{
	//otherwise just switch on the light node
	pointLightNode.switchOn(frameContext);
}

//register the scene and activate it
PADrend.registerScene(scene);
PADrend.selectScene(scene);

