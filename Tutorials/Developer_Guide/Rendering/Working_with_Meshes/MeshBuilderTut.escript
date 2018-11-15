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

var clipSphere = fn(node){
	var numSegments = 20; //number of segments in horizontal and vertical direction
	var mesh = Rendering.MeshBuilder.createSphere(numSegments, numSegments);

	//Cutting the mesh
	Rendering.eliminateTrianglesBehindPlane(mesh, new Geometry.Vec3(0.0, 0.0, 0.0), new Geometry.Vec3(-1.0, 0.0, 0.0));
	
	return mesh;
};

var createThreeConesWithDifferentDrawState = fn(rootNode){
	var numSegments = 20; //number of segments in horizontal and vertical direction

	var mesh1 = Rendering.MeshBuilder.createSphere(numSegments, numSegments);
	var mesh2 = Rendering.MeshBuilder.createSphere(numSegments, numSegments);
	var mesh3 = Rendering.MeshBuilder.createSphere(numSegments, numSegments);
	var mesh4 = Rendering.MeshBuilder.createSphere(numSegments, numSegments);
	
	//Setting draw modes
	mesh1.setDrawTriangles(); //inital setting
	mesh2.setDrawLines(); //draw lines only, rectangular shaped
	mesh3.setDrawLineStrip(); //draw lines only, triangular shaped
	mesh4.setDrawPoints(); //draw only points (positions of vertices) 
	
	var node1 = new MinSG.GeometryNode(mesh1);
	var node2 = new MinSG.GeometryNode(mesh2);
	var node3 = new MinSG.GeometryNode(mesh3);
	var node4 = new MinSG.GeometryNode(mesh4);
	
	//Setting positions
	node1.setRelPosition(new Geometry.Vec3(-2, 0, 0));
	node2.setRelPosition(new Geometry.Vec3( 2, 0, 0));
	node3.setRelPosition(new Geometry.Vec3(-8, 0, 0));
	node4.setRelPosition(new Geometry.Vec3( 8, 0, 0));
	
	rootNode += node1;
	rootNode += node2;
	rootNode += node3;
	rootNode += node4;
};

var createBox = fn(node, r, g, b){
	var meshBuilder = new Rendering.MeshBuilder();
	
	//Adding the vertices
	meshBuilder.addVertex(new Geometry.Vec3(0,0,0), new Geometry.Vec3(0,0,1), r, g, b, 1, 0, 0);//0
	meshBuilder.addVertex(new Geometry.Vec3(0,1,0), new Geometry.Vec3(0,0,1), r, g, b, 1, 0, 0);//1
	meshBuilder.addVertex(new Geometry.Vec3(1,1,0), new Geometry.Vec3(0,0,1), r, g, b, 1, 0, 0);//2
	meshBuilder.addVertex(new Geometry.Vec3(1,0,0), new Geometry.Vec3(0,0,1), r, g, b, 1, 0, 0);//3
	
	meshBuilder.addVertex(new Geometry.Vec3(0,0,-1), new Geometry.Vec3(0,0,-1), r, g, b, 1, 0, 0);//4
	meshBuilder.addVertex(new Geometry.Vec3(0,1,-1), new Geometry.Vec3(0,0,-1), r, g, b, 1, 0, 0);//5
	meshBuilder.addVertex(new Geometry.Vec3(1,1,-1), new Geometry.Vec3(0,0,-1), r, g, b, 1, 0, 0);//6
	meshBuilder.addVertex(new Geometry.Vec3(1,0,-1), new Geometry.Vec3(0,0,-1), r, g, b, 1, 0, 0);//7

	//Front side
	//First triangle
	meshBuilder.addIndex(0);
	meshBuilder.addIndex(3);
	meshBuilder.addIndex(2);
	
	//Second triangle
	meshBuilder.addIndex(0);
	meshBuilder.addIndex(2);
	meshBuilder.addIndex(1);
	
	//Top side
	meshBuilder.addTriangle(2,6,5);
	meshBuilder.addTriangle(1,2,5);
	
	//Back side
	meshBuilder.addQuad(4,5,6,7);
	//Bottom side
	meshBuilder.addQuad(0,4,7,3);
	
	//Right side
	meshBuilder.addQuad(3,7,6,2);
	//Left side
	meshBuilder.addQuad(0,1,5,4);
	
	//Build the mesh
	var mesh = meshBuilder.buildMesh();
	return mesh;
};
var mesh = createBox(node, 0, 1, 0);
//Create a list node holding the scene
var sceneNode = new MinSG.ListNode();
//Create a geometry node holding the mesh
var node = new MinSG.GeometryNode(mesh);
//Adding the geometry node to the scene node
sceneNode += node;
	
//Register the scene
PADrend.registerScene(sceneNode);
//Selecting the scene to make it active
PADrend.selectScene(sceneNode);

//createBox(node, 0, 1, 0);
//createThreeConesWithDifferentDrawState(sceneNode);
//clipSphere(node);

