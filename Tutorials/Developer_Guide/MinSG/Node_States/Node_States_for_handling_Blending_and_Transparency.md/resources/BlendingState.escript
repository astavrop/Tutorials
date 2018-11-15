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

//This variable is used to switch between two blending functions.
var useConstantAlpha = false;

//Creates a quad with a specific color. The function returns a
//geometry node including the mesh of the quad. The z-parameter
//sets the quad's displacement along the z-axis.
var createQuad = fn(z, r, g, b){
	var meshBuilder = new Rendering.MeshBuilder();
	meshBuilder.color(new Util.Color4f(r, g, b, 0.5));
	
	meshBuilder.position(new Geometry.Vec3(-0.5, 0, z));
	meshBuilder.addVertex();

	meshBuilder.position(new Geometry.Vec3(0.5, 0, z));
	meshBuilder.addVertex();
	
	meshBuilder.position(new Geometry.Vec3(0.5, 1, z));
	meshBuilder.addVertex();

	meshBuilder.position(new Geometry.Vec3(-0.5, 1, z));
	meshBuilder.addVertex();
	
	meshBuilder.addQuad(0, 1, 2, 3);
	return new MinSG.GeometryNode(meshBuilder.buildMesh());
};

//Three quads
var node1 = createQuad(0, 1, 0, 0);
var node2 = createQuad(1, 0, 1, 0);
var node3 = createQuad(2, 0, 0, 1);

//Building the scene graph
var scene = new MinSG.ListNode();
scene += node1;
scene += node2;
scene += node3;

//Creating a bending state
var blendingState = new MinSG.BlendingState();

//Two setting two different blending functions. The boolean variable
//useCostantAlpha can be used to switch between both settings.
if(useConstantAlpha){
	blendingState.setBlendConstAlpha(0.3);
	blendingState.setBlendFuncSrc(Rendering.BlendFunc.CONSTANT_ALPHA);
	blendingState.setBlendFuncDst(Rendering.BlendFunc.CONSTANT_ALPHA);
}
else{
	blendingState.setBlendFuncSrc(Rendering.BlendFunc.SRC_ALPHA);
	blendingState.setBlendFuncDst(Rendering.BlendFunc.ONE_MINUS_SRC_ALPHA);
}

//Add the blending state to the root node, so that it is applied on
//the whole scene.
scene.addState(blendingState);

//Register the scene and set it active
PADrend.registerScene(scene);
PADrend.selectScene(scene);