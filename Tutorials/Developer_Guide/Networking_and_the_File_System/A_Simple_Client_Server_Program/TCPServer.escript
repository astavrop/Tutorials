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

static TCPServer = Util.Network.TCPServer;
static TCPConnection = Util.Network.TCPConnection;

var server = TCPServer.create(8080);
if(!server) {
	outln("Failed to start server");
	return;
}

var count = 0;
var client;
while(!client) {
	outln("Waiting for client");
	Util.sleep(1000); // wait one second
	client = server.getIncomingConnection();
	if(count++ == 10) {
		outln("Timeout!");
		server.close(); // never forget to close!
		return;
	}
}

// client is connected, now we just respond
var data;
while(!data) {
	data = client.receiveString();
}
outln("Received: ", data);
client.sendString("Pong");

Util.sleep(1000);
server.close();
client.close();
