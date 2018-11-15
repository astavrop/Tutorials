---
author: Henrik Heine
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 2
permalink: a_simple_client_server_program
subcategory: Networking and the File System
title: A Simple Client-Server Program
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# Networking with PADrend

## TCP
You won't find any sockets or clients, because PADrend only gives you a very high level look on the network. In PADrend you only have a `TCPServer` and `TCPConnection`s.

### TCPServer
The TCPServer is of course only used if you want to listen for incomming connections. To do so, you have to create a server, which listens on a specific port. This is done by calling `TCPServer.create(port)`. In case of an error, it will just return `false`. Otherwise it will return a `TCPServer` instance, which is already listening. You can close this instance any time by calling `close()`. Furthermore you can test if the server is listening by calling `isOpen()`.

The server will automatically accept all incoming connections. You can get new connections by calling `getIncomingConnection()`. This will return `false` if there is no new incoming connection and it will return an instance of `TCPConnection` if there is. This connection is then used to communicate.

### TCPConnection
On the server side you get connections as return values from a call to `getIncomingConnection()`. On the client side you have to establish a connection by specifying the correct host and port: `TCPConnection.connect(host, port)`. In the case of an error, it will return false. Otherwise it returns a connection instance. You can close this connection any time by calling `close()`. Of course it is also possible to query the state of the connection by calling `isOpen()`.

Messages are sent by the `sendString` method. The first parameter to this function is the string that should be sent. The second parameter is optional and represents a delimiter. By default the delimiter is `'\0'`. This delimiter is an important difference to other languages! It will always use a delimiter!
> So if you plan to communicate with other services, be aware of this!

The sendString method will return the `this` object for chaining, so you could for example concatenate several calls like this:
```
con.sendString("First Message").sendString("Second Message");
// or a "fire and forget" like fashion
TCPConnection.connect(host, port).sendString("Hello!").close();
```

In order to receive data, you have to call the `receiveString` method. It has an optional parameter, which can be either a delimiter or a length. By default the delimiter is again `'\0'`. This method will return false if there was nothing to receive. If it has received something, the resulting string is returned.
* `receiveString(length)` will return false as long as the input buffer does not hold enough bytes.
* `receiveString(delimiter)` will return false as long as the delimiter is not found.
> Both methods will never block!

#### Example
The following simple example just demonstrates the basic usage of the TCPConnection. In order to run it, you have to start two PADrend instances. One of them will run the server and the other one the client.

Server side:
<!---INCLUDE src=TCPServer.escript, start=14 ,end=46--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
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
```
<!---END_CODESECTION--->

Client side:
<!---INCLUDE src=TCPClient.escript, start=14 ,end=29--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
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
```
<!---END_CODESECTION--->

## UDP
The UDP communication is handled via the `UDPNetworkSocket` type. In contrast to most other types, this type doesn't have a constructor. Furthermore it is not created by a static method of itself.
Instead you have to use the following method: `Util.Network.createUDPNetworkSocket(port, maxSize)`

Both arguments are optional. By default the port is set to 0 and the maximum paket size is set to 1024. Afterwards you have to open the connection via `open()`. If the port was 0, it is set a random number. You can query the port afterwards with `getPort()`. Similar to a TCPConnection, the UDPNetworkSocket also has the following two methods: `close()` and `isOpen()`

If you have read carefully you might have noticed that up to now, we don't have any recipients specified. In PADrend this is done by adding targets: `UDPNetworkSocket addTarget(String host, Number port)`. If you want to remove an target, you call: `UDPNetworkSocket removeTarget(String host, Number port)`.

You send a message via the `sendString(String data)` method. This message will be send to all targets you have added via `addTarget` and it returns the number of recipients.

If you want to receive a message, you use the `receive()` method. This method returns void if there is nothing to receive and an `ExtObject` otherwise. This ExtObject has the following fields set:
* `data`: a string representing the received data
* `dataSize`: The size of the message
* `host`: The host from which this message was received
* `port`: The port of the sender

#### Example
The following simple example just demonstrates the basic usage of the UDPNetworkSocket. In order to run it, you have to start two PADrend instances. One of them will run the server and the other one the client.

Server side:
<!---INCLUDE src=UDPServer.escript, start=14 ,end=36--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
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
```
<!---END_CODESECTION--->

Client side:
<!---INCLUDE src=UDPClient.escript, start=14 ,end=34--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```js
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
```
<!---END_CODESECTION--->





