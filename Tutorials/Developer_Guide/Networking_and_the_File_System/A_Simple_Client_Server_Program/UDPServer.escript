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

var socket = Util.Network.createUDPNetworkSocket(8080);
socket.open();

// wait to receive a message

var count = 0;
while(true) {
	outln("Waiting for a message");
	Util.sleep(1000); // wait one second
	var msg = socket.receive();
	if(msg) {
		outln("Received: ", msg.data);
		outln("From: ", msg.host, ":", msg.port);
		// In this simple example we don't want to remember the sender
		// Therefore we just add it as a target, send the message and then we remove the target
		socket.addTarget(msg.host, msg.port).sendString("Pong");
		socket.removeTarget(msg.host, msg.port);
		return;
	} else if(count++ == 10) {
		outln("Timeout!");
		return;
	}
}
