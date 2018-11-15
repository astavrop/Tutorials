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

var T = new Type(ExtObject);

T._constructor := fn(){
	
	//Creating a frame buffer object and binding a texture to it. The texture serves as rendering target for the frame buffer object.
	this.fbo := new Rendering.FBO();
	this.mirrorTexture := Rendering.createStdTexture(renderingContext.getWindowWidth(), 
													renderingContext.getWindowHeight(),
													true);
	renderingContext.pushAndSetFBO(this.fbo);
	this.fbo.attachColorTexture(renderingContext, this.mirrorTexture);
	renderingContext.popFBO();
	Rendering.checkGLError();
	
	//Creating the test scene
	this.createScene();
	
	//before each frame render the mirrored scene to a texture
	this.beforeFrame := [this] => fn(thisObj, x){
		//mirror the scene
		var nodeMatrix = thisObj.rootNode.getWorldTransformationMatrix();
		var scaleMatrix = new Geometry.Matrix4x4([1, 0, 0, 0,
												  0, 1, 0, 0,
												  0, 0,-1, 0,
												  0, 0, 0, 1]);
		var newNodeMatrix = nodeMatrix * scaleMatrix;
		thisObj.rootNode.setWorldTransformation(newNodeMatrix.toSRT());
	
		//deactivate the mirror mesh, so that it is not part of the mirrored scene
		thisObj.mirrorNode.deactivate();
		
		//set rendering target
		renderingContext.pushAndSetFBO(thisObj.fbo);
		
		//clear the texture and draw the scene to it
		renderingContext.clearScreen(PADrend.getBGColor());
		PADrend.getRootNode().display(frameContext, PADrend.getRenderingFlags());
		
		//restore the previouse state (e.g. pop the frame buffer object, restore the old transformation and activate the mirror mesh)
		renderingContext.popFBO();
		thisObj.rootNode.setWorldTransformation(nodeMatrix.toSRT());
		thisObj.mirrorNode.activate();
	};
	
	//register the beforeFrame function so that it is called before each frame
	Util.registerExtension('PADrend_BeforeRendering', this.beforeFrame);
};


T.createScene := fn(){
	this.rootNode := new MinSG.ListNode();
	
	//Building a GeometryNode for the mirror. Its mesh is a simple rectangle. A texture state is added to the node, so that the mirror texture is drawn to the rect.
	this.mirrorNode := new MinSG.GeometryNode();
	this.mirrorNode.addState(new MinSG.TextureState(this.mirrorTexture));
	
	var meshBuilder = new Rendering.MeshBuilder();
	meshBuilder.addVertex(new Geometry.Vec3(-2,0,0), new Geometry.Vec3(0,0,1), 1, 1, 1, 1, 0, 0);//0
	meshBuilder.addVertex(new Geometry.Vec3( 2,0,0), new Geometry.Vec3(0,0,1), 1, 1, 1, 1, 1, 0);//1
	meshBuilder.addVertex(new Geometry.Vec3( 2,2,0), new Geometry.Vec3(0,0,1), 1, 1, 1, 1, 1, 1);//2
	meshBuilder.addVertex(new Geometry.Vec3(-2,2,0), new Geometry.Vec3(0,0,1), 1, 1, 1, 1, 0, 1);//3
	meshBuilder.addQuad(0, 1, 2, 3);

	this.mirrorNode.setMesh(meshBuilder.buildMesh(););
	
	//create the test scene form some objects
	var mesh1 = Rendering.MeshBuilder.createBox(new Geometry.Box(0, 0, 0, 2, 2, 2));
	Rendering.setColor(mesh1, new Util.Color4f(1,0,0,1));
	var mesh2 = Rendering.MeshBuilder.createCone(1.0, 2.0, 100); 
	Rendering.setColor(mesh2, new Util.Color4f(0,1,0,1));
	var mesh3 = Rendering.MeshBuilder.createSphere(100, 100);
	Rendering.setColor(mesh3, new Util.Color4f(0,0,1,1));
	
	var node1 = new MinSG.GeometryNode(mesh1);
	var node2 = new MinSG.GeometryNode(mesh2);
	var node3 = new MinSG.GeometryNode(mesh3);
	
	node1.setRelPosition(new Geometry.Vec3(1, 0, 15));
	node2.rotateLocal_deg(90.0, new Geometry.Vec3(0, 0, 1));
	node2.setRelPosition(new Geometry.Vec3(0, 0, 12));
	node3.setRelPosition(new Geometry.Vec3(3, 0, 12));
	
	//build the scene graph
	rootNode += node1;
	rootNode += node2;
	rootNode += node3;
	
	rootNode += this.mirrorNode;
	
	this.rootNode := rootNode;
};

//register the scene to PADrend
var t = new T();
var sceneNode = t.rootNode;

PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);