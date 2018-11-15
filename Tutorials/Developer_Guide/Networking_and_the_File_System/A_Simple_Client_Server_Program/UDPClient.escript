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

// This script is basically a client, therefore it is OK to let the system use some random port
var socket = Util.Network.createUDPNetworkSocket(); // no port or 0 means that a random port is chosen
socket.open();
socket.addTarget("127.0.0.1", 8080);
socket.sendString("Ping");
// wait for response

var count = 0;
while(true) {
	outln("Waiting for response");
	Util.sleep(1000); // wait one second
	var msg = socket.receive();
	if(msg) {
		outln("Received: ", msg.data);
		outln("From: ", msg.host, ":", msg.port);
		return;
	} else if(count++ == 10) {
		outln("Timeout!");
		return;
	}
}
