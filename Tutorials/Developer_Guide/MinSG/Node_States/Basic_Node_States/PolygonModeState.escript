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
 
 //create a sphere mesh
 var mesh = Rendering.MeshBuilder.createSphere(50, 50);
 
 //create three geometry nodes including the mesh
 var node1 = new MinSG.GeometryNode(mesh);
 var node2 = new MinSG.GeometryNode(mesh);
 var node3 = new MinSG.GeometryNode(mesh);
 
 //move two nodes so that they are seperated
 node1.moveLocal(new Geometry.Vec3(-2.5, 0, 0));
 node3.moveLocal(new Geometry.Vec3(2.5, 0, 0));
 
 //create three polygone mode states with different modes
 var fillState = new MinSG.PolygonModeState();
 fillState.setMode(Rendering.PolygonModeParameters.FILL);
 
 var pointState = new MinSG.PolygonModeState();
 pointState.setMode(Rendering.PolygonModeParameters.POINT);
 
 var lineState = new MinSG.PolygonModeState();
 var parameter = new Rendering.PolygonModeParameters();
 parameter.setMode(Rendering.PolygonModeParameters.LINE);
 lineState.setParameters(parameter);
 
 //add the states to the nodes
 node1.addState(fillState);
 node2.addState(pointState);
 node3.addState(lineState);
 
 //create the scene graph
 var scene = new MinSG.ListNode();
 scene += node1;
 scene += node2;
 scene += node3;
 
 //Register the scene
 PADrend.registerScene(scene);
 //Selecting the scene to make it active
 PADrend.selectScene(scene);