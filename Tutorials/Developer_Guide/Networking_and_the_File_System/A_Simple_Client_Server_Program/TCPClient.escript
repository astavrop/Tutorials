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

static TCPConnection = Util.Network.TCPConnection;

var client = TCPConnection.connect("127.0.0.1", 8080);
if(!client) {
	outln("Failed to connect!");
	return;
}

client.sendString("Ping");
var data;
while(!data) {
	data = client.receiveString();
}
outln("Received: ", data);

client.close();
