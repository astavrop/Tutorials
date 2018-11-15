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
 
static TreeQuery = Std.module('LibMinSGExt/TreeQuery');

static createSceneGraph = fn(){
	var root = new MinSG.ListNode();
	var listNodes = [];
	listNodes += root;
	PADrend.getSceneManager().registerNode("root_node", root);
	
	for(var i = 0; i < 12; i++){
		listNodes += new MinSG.ListNode();
		PADrend.getSceneManager().registerNode("list_node" + i, listNodes[listNodes.size()-1]);
	}
	
	for(var i = 0; i <= 3; i++){
		for(var j = 1; j <= 3; j++){
			listNodes[i] += listNodes[i*3 + j];
		}
	}	
	
	var mesh = Rendering.MeshBuilder.createSphere(20, 20);
	var offset = 2;
	var x = 0;
	var y = 0;
	var nodeCounter = 0;
	
	for(var i = 4; i < listNodes.size(); i++){
		for(var j = 0; j < 3; j++){
			var node = new MinSG.GeometryNode(mesh);
			PADrend.getSceneManager().registerNode("geometry_node" + nodeCounter, node);
			listNodes[i] += node;
			node.setRelPosition(new Geometry.Vec3( x, y, 0));
			x += offset;
			nodeCounter++;
		}
		y += offset;
		x = 0;
	}
	
	return root;
};

static printQueryResult = fn(resultNodes){
	outln("Found " + resultNodes.toArray().size() + " result nodes");

	foreach(resultNodes as var node){
		var id = PADrend.getSceneManager().getNameOfRegisteredNode(node);
		if(id)
			outln(id);
	}
};

static executeQuery = fn(query, startNode){
	var resultNodes = TreeQuery.execute(query, PADrend.getSceneManager(), [startNode]);
	printQueryResult(resultNodes);
};

static executeQueryByHand = fn(query, startNode){
	var context = TreeQuery.createContext(PADrend.getSceneManager(), [startNode]);
	var executeableQuery = TreeQuery.parse(query);
	var resultNodes = executeableQuery(context);
	
	printQueryResult(resultNodes);
};

var root = createSceneGraph();
PADrend.registerScene(root);
PADrend.selectScene(root);

var query1 = "/child";
var query2 = "child";
var query3 = "./child";

outln("Executing first query...");
executeQuery(query1, root);

outln("\nExecuting second query...");
executeQuery(query2, root);

outln("\nExecuting third query...");
executeQueryByHand(query3, root);
