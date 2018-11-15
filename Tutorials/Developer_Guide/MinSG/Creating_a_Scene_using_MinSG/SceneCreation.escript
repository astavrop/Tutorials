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

//building nodes
var rootNode = new MinSG.ListNode();
var listNode = new MinSG.ListNode();

var mesh1 = Rendering.MeshBuilder.createBox(new Geometry.Box(-2, 0, 0, 1, 1, 1));
var mesh2 = Rendering.MeshBuilder.createBox(new Geometry.Box(2, 0, 0, 1, 1, 1));
var mesh3 = Rendering.MeshBuilder.createBox(new Geometry.Box(0, 0, -2, 1, 1, 1));

var geometryNode1 = new MinSG.GeometryNode(mesh1);
var geometryNode2 = new MinSG.GeometryNode(mesh2);
var geometryNode3 = new MinSG.GeometryNode(mesh3);

//giving nodes a unique id
PADrend.getSceneManager().registerNode("root", rootNode);
PADrend.getSceneManager().registerNode("some_list_node", listNode);

PADrend.getSceneManager().registerNode("geometry_node_1", geometryNode1);
PADrend.getSceneManager().registerNode("geometry_node_2", geometryNode2);
PADrend.getSceneManager().registerNode("geometry_node_3", geometryNode3);

//Building the scene graph
rootNode.addChild(geometryNode1);
rootNode.addChild(listNode);

listNode += geometryNode2;
listNode += geometryNode3;

//Setting some meta data
var NodeMetaInfo = Std.module('LibMinSGExt/NodeMetaInfo');
var date = getDate();

NodeMetaInfo.accessMetaInfo_CreationDate(rootNode)("" + date["year"] + "-"+ date["mon"] + "-" + date["mday"] );
NodeMetaInfo.accessMetaInfo_Title(rootNode)("Test Scene");
NodeMetaInfo.accessMetaInfo_Author(rootNode)("Max Mustermann");
NodeMetaInfo.accessMetaInfo_License(rootNode)("free");
NodeMetaInfo.accessMetaInfo_Note(rootNode)("Some info about the scene.");

//Register the root node of the scene graph
PADrend.registerScene(rootNode);
//Selecting the root node to be the active scene
PADrend.selectScene(rootNode);