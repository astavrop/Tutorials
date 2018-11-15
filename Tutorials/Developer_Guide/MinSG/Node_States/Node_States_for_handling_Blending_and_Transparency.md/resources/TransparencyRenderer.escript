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
 
static Vec2 = Geometry.Vec2;
static Vec3 = Geometry.Vec3;

var buildMesh = fn(r, g, b) {
	// First we build a simple Mesh, consisting of a single quad
	var mb = new Rendering.MeshBuilder();
	mb.color(new Util.Color4f(r,g,b,0.5));
	// Vertex 0:
	mb.position(new Vec3(0,0,0));
	mb.texCoord0(new Vec2(0,1));
	mb.addVertex();

	// Vertex 1:
	mb.position(new Vec3(10,0,0));
	mb.texCoord0(new Vec2(1,1));
	mb.addVertex();

	// Vertex 2:
	mb.position(new Vec3(10,10,0));
	mb.texCoord0(new Vec2(1,0));
	mb.addVertex();

	// Vertex 3:
	mb.position(new Vec3(0,10,0));
	mb.texCoord0(new Vec2(0,0));
	mb.addVertex();

	// create quad
	mb.addQuad(0,1,2,3);
	// return mesh
	return mb.buildMesh();
};

// Build GeometryNode with corresponding mesh
var geo = new MinSG.GeometryNode(buildMesh(1,0,0));
var geo2 = new MinSG.GeometryNode(buildMesh(0,1,0));
var geo3 = new MinSG.GeometryNode(buildMesh(0,0,1));
// Displace the planes along the z-axis
geo2.moveLocal(new Geometry.Vec3(0, 0, -3));
geo3.moveLocal(new Geometry.Vec3(0, 0, -6));

// Create new scene and add node to it
var sceneNode = new MinSG.ListNode();
sceneNode += new MinSG.TransparencyRenderer();
sceneNode += geo;
sceneNode += geo2;
sceneNode += geo3;
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);

