/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2016 Henrik Heine <hheine@mail.uni-paderborn.de>
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

var buildMesh = fn() {
	// First we build a simple Mesh, consisting of a single quad
	var mb = new Rendering.MeshBuilder();
	mb.color(new Util.Color4f(1,1,1,1));
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

// build GeometryNode with corresponding mesh
var geo = new MinSG.GeometryNode(buildMesh());
// create chess texture of size 1024*1024, with tiles of side length 64
var chess = Rendering.createChessTexture(1024, 1024, 64);
// create new TextureState
var textureState = new MinSG.TextureState(chess);
// you could also set the TextureUnit:
textureState.setTextureUnit(0); // only needed if you add more than one texture though...

var vertexShaderCode = "
void main(void) {
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = ftransform();
}
";
var fragmentShaderCode = "
struct sg_LightSourceParameters {
	int type; 							// has to be DIRECTIONAL, POINT or SPOT
	vec3 position; 						// position of the light  ????????????????????????????????
	vec3 direction; 					// direction of the light, has to be normalized ????????????????????????????????
	vec4 ambient, diffuse, specular;	// light colors for all lights
	float constant, linear, quadratic;	// attenuations for point & spot lights
	float exponent, cosCutoff;			// spot light parameters
};

uniform sampler2D chessTexture;
uniform sg_LightSourceParameters	sg_LightSource[8];
uniform int							sg_lightCount;

void main(void) {
	vec2 uv = gl_TexCoord[0].st;
	vec4 result = texture2D(chessTexture, uv);
	result.r *= uv.s;
	result.g *= uv.t;
	if(sg_lightCount > 1) {
		result += sg_LightSource[1].ambient;
	}
	gl_FragColor = result;
}
";
var shader = Rendering.Shader.createShader(vertexShaderCode, fragmentShaderCode);
var shaderState = new MinSG.ShaderState(shader);
// our chess texture is bound to texture unit 0
shaderState.setUniform("chessTexture", Rendering.Uniform.INT, [0]);

//creating a new light node
var pointLightNode = new MinSG.LightNode(MinSG.LightNode.POINT);
//setting the light color
pointLightNode.setAmbientLightColor(new Util.Color4f(0.5, 0.5, 0.0, 1.0));
pointLightNode.setSpecularLightColor(new Util.Color4f(1.0, 0.0, 0.0, 1.0));
pointLightNode.setDiffuseLightColor(new Util.Color4f(1.0, 0.0, 0.0, 1.0));
//move the lightsource above the scene
pointLightNode.moveLocal(new Geometry.Vec3(0, 5, 0));

// add lighting state  to node
var lightingState = new MinSG.LightingState(pointLightNode);
lightingState.setEnableLight(true);

// add group state to node
var groupState = new MinSG.GroupState();
groupState.addState(textureState);
groupState.addState(shaderState);
geo += groupState;
geo += lightingState;


// create new scene and add node to it
var sceneNode = new MinSG.ListNode();
sceneNode += pointLightNode;
sceneNode += geo;
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
