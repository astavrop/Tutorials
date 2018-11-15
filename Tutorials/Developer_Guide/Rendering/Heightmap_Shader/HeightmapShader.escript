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

static Vec2 = Geometry.Vec2;
static Vec3 = Geometry.Vec3;
var sceneNode = new MinSG.ListNode();

// creates a regular grid of the size width*height. Each single grid cell has a size of tileSize*tileSize
var makeGrid = fn(Number width, Number height, Number tileSize = 1) {
	var xTiles = width / tileSize; // number of tiles in x direction
	var mb = new Rendering.MeshBuilder();
	mb.color(new Util.Color4f(1, 1, 1, 1));
	for(var y=0; y<height; y+=tileSize) {
		for(var x=0; x<width; x+=tileSize) {
			mb.position(new Vec3(x * tileSize, 0, y * tileSize));
			mb.texCoord0(new Vec2(x / width, y / height));
			var id = mb.addVertex();
			if(x > 0 && y > 0) {
				mb.addQuad(id, id - xTiles, id - xTiles - 1, id - 1);
			}
		}
	}
	return mb.buildMesh();
};

var mesh = makeGrid(256, 256); // create grid
var terrain = new MinSG.GeometryNode(mesh); // create geometry node with mesh

// load heightmap
var heightmap = Rendering.createTextureFromFile('presets/Heightmap.png');
var textureState = new MinSG.TextureState(heightmap);
textureState.setTextureUnit(0);
terrain += textureState;

// create shader
var vertexShaderCode = "
uniform sampler2D heightmap;
uniform float scale = 1.0;
uniform float offset = 0.0;

varying float normalizedHeight;
varying float height;

void main(void) {
	normalizedHeight = texture2D(heightmap, gl_MultiTexCoord0.st).r;
	height = offset + scale * normalizedHeight;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	vec4 pos = ftransform();
	pos.y += height;
	gl_Position = pos;
}
";
var fragmentShaderCode = "
varying float normalizedHeight;
varying float height;

void main(void) {
	gl_FragColor = vec4(normalizedHeight, normalizedHeight, normalizedHeight, 1);
}
";
var shader = Rendering.Shader.createShader(vertexShaderCode, fragmentShaderCode);
var shaderState = new MinSG.ShaderState(shader);


shaderState.setUniform("heightmap", Rendering.Uniform.INT, [0]);
shaderState.setUniform("scale", Rendering.Uniform.FLOAT, [32]);
terrain += shaderState;

sceneNode += terrain;
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
