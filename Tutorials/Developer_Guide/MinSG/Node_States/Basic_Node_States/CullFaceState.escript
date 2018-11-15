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
 
 // creates a square. color and position are passed as parameter
 // the function returns a geometry node containing the square
 var createNodeWithRect = fn(color, xMovement){
 	var meshBuilder = new Rendering.MeshBuilder();
 	meshBuilder.color(color);
 	
 	meshBuilder.position(new Geometry.Vec3(xMovement, 0, 0));
 	meshBuilder.addVertex();
 	meshBuilder.position(new Geometry.Vec3(xMovement + 1, 0, 0));
 	meshBuilder.addVertex();
 	meshBuilder.position(new Geometry.Vec3(xMovement + 1, 1, 0));
 	meshBuilder.addVertex();
 	meshBuilder.position(new Geometry.Vec3(xMovement, 1, 0));
 	meshBuilder.addVertex();
 	
 	meshBuilder.addQuad(0, 1, 2, 3);
 	
 	var mesh = meshBuilder.buildMesh();
 	var node = new MinSG.GeometryNode(mesh);
 	
 	return node;
 };
 
 //creating four squares, each having an unique color
 var node1 = createNodeWithRect(new Util.Color4f(1, 0, 0, 1), -3.5);
 var node2 = createNodeWithRect(new Util.Color4f(0, 1, 0, 1), -1.5);
 var node3 = createNodeWithRect(new Util.Color4f(0, 0, 1, 1), 0.5);
 var node4 = createNodeWithRect(new Util.Color4f(1, 1, 0, 1), 2.5);
 
 //different culling states
 //enable back face culling
 var stateCullBack = new MinSG.CullFaceState();
 stateCullBack.setCullMode(Rendering.CULL_BACK);
 //enable front face culling
 var stateCullFront = new MinSG.CullFaceState();
 stateCullFront.setCullMode(Rendering.CULL_FRONT);
  //enable front and back face culling
 var stateCullBoth = new MinSG.CullFaceState();
 stateCullBoth.setCullMode(Rendering.CULL_FRONT_AND_BACK);
 //disable culling
 var stateCullingOff = new MinSG.CullFaceState();
 stateCullingOff.setCullingEnabled(false);

 //adding the states to the nodes
 node1.addState(stateCullBack);
 node2.addState(stateCullFront);
 node3.addState(stateCullBoth);
 node4.addState(stateCullingOff);
 
 //build the scene graph
 var scene = new MinSG.ListNode();
 scene += node1;
 scene += node2;
 scene += node3;
 scene += node4;
 
 //register the scene ande activate it
 PADrend.registerScene(scene);
 PADrend.selectScene(scene);  
 