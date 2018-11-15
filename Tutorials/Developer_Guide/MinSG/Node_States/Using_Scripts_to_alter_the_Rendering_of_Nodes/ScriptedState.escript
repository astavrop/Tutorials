/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2016 Henrik Heine <hheine@mail.uni-paderborn.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

var sceneNode = new MinSG.ListNode();

// Define new ScriptedState
var MyState = new Type(MinSG.ScriptedState);
MyState.doEnableState @(override) ::= fn(node, rp) {
	var camPos = frameContext.getCamera().getWorldOrigin();
	var nodePos = node.getWorldPosition();
	var diff = (camPos - nodePos).length();
	if(diff > 20) return MinSG.STATE_SKIP_RENDERING;
	return MinSG.STATE_OK;
};

// create simple cube
var cube = new MinSG.GeometryNode(Rendering.MeshBuilder.createBox(new Geometry.Box(0,0,0,1,1,1)));
// add state to cube
cube += new MyState();
// add cube to scene
sceneNode += cube;

// activate scene
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
