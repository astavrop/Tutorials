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
 
 //creates a geometry node with a material state and attaches a light source to it
 var createNodeWithLightSource = fn(xMovement, Util.Color4f ambient, Util.Color4f diffuse, Util.Color4f specular, shininess){
 	//creating a geometry node containing the mesh
 	var mesh = Rendering.MeshBuilder.createSphere(50, 50);
 	var geoNode = new MinSG.GeometryNode(mesh);
 	geoNode.moveLocal(new Geometry.Vec3(xMovement, 0, 0));
 	
 	//create a material state and setting its properties
 	var materialState = new MinSG.MaterialState();
 	materialState.setAmbient(ambient);
 	materialState.setDiffuse(diffuse);
 	materialState.setSpecular(specular);
 	materialState.setShininess(shininess);
 	
 	//creating a new light node having a white light color
	var pointLightNode = new MinSG.LightNode(MinSG.LightNode.POINT);
	pointLightNode.setAmbientLightColor(new Util.Color4f(1.0, 1.0, 1.0, 1.0));
	pointLightNode.setSpecularLightColor(new Util.Color4f(1.0, 1.0, 1.0, 1.0));
	pointLightNode.setDiffuseLightColor(new Util.Color4f(1.0, 1.0, 1.0, 1.0));
	pointLightNode.moveLocal(new Geometry.Vec3(xMovement, 5, 5));
	
	//creating a light state so that only the geometry node ist illuminated by the light source
	var lightingState = new MinSG.LightingState(pointLightNode);
	lightingState.setEnableLight(true);
	
	//adding the states to the node
	geoNode.addState(materialState);
	geoNode.addState(lightingState);
	
	//creating a subtree for the created nodes
	var lstNode = new MinSG.ListNode();
	lstNode += geoNode;
	lstNode += pointLightNode;
	
	//returning the subtree
	return lstNode;
 };
 
 //color of a brass like material
 var ambientPart = new Util.Color4f(0.2125, 0.1275, 0.054, 1.0);
 var diffusePart = new Util.Color4f(0.714, 0.4284, 0.18144, 1.0);
 var specularPart = new Util.Color4f(0.393548, 0.271906, 0.166721, 1.0);
 var shininess = 25.6;
 
 //black color for switching single parts of the phong equation off 
 var blackColor = new Util.Color4f(0.0, 0.0, 0.0, 1.0);
 
 //creating four nodes
 //the first three nodes show the single parts of the phong equation individually 
 var nodeAmbient = createNodeWithLightSource(-4.5, ambientPart, blackColor, blackColor, 0.0); 
 var nodeDiffuse = createNodeWithLightSource(-1.5, blackColor, diffusePart, blackColor, 0.0); 
 var nodeSpecular = createNodeWithLightSource(1.5, blackColor, blackColor, specularPart, 25.6); 
 //the last node shows the resulting phong illumination
 var nodePhong = createNodeWithLightSource(4.5, ambientPart, diffusePart, specularPart, 25.6);  
 
 //creating the scene graph
 var scene = new MinSG.ListNode();
 scene += nodeAmbient;
 scene += nodeDiffuse;
 scene += nodeSpecular;
 scene += nodePhong;
  
 //Register the scene
 PADrend.registerScene(scene);
 //Selecting the scene to make it active
 PADrend.selectScene(scene);