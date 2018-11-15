/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2016 Stanislaw Eppinger <eppinger@mail.uni-paderborn.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

 // Create cubes 
var cube1 = new MinSG.GeometryNode(Rendering.MeshBuilder.createBox(new Geometry.Box(0,0,0,1,1,1)));
var cube2 = new MinSG.GeometryNode(Rendering.MeshBuilder.createBox(new Geometry.Box(0,0,0,1,1,1)));
// Displace the second cube
cube2.moveLocal(new Geometry.Vec3(-2, 0, 0));

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


// Create new scene and add the flickerRenderer and the cubes to it
var sceneNode = new MinSG.ListNode();
sceneNode += flickerRenderer;
sceneNode += cube1;
sceneNode += cube2;
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
