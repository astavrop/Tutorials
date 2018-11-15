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

// Build GeometryNode with corresponding mesh
var geo = new MinSG.GeometryNode(Rendering.MeshBuilder.createSphere(50, 50));
// Create chess texture of size 1024*1024, with tiles of side length 64
var chess = Rendering.createChessTexture(1024, 1024, 64);
// Create new TextureState
var texState = new MinSG.TextureState(chess);
// You could also set the TextureUnit:
texState.setTextureUnit(0); // only needed if you add more than one texture though...
// Add state to node
geo += texState;

var vertexShaderCode = "
void main(void) {
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = ftransform();
}
";
var fragmentShaderCode = "
uniform sampler2D chessTexture;
uniform bool showTexture;

void main(void) {
	vec2 uv = gl_TexCoord[0].st;
	vec4 result = vec4(1, 0.5, 0.5, 1);
	if (showTexture) result = texture2D(chessTexture, uv);
	gl_FragColor = result;
}
";

var shader = Rendering.Shader.createShader(vertexShaderCode, fragmentShaderCode);
var shaderState = new MinSG.ShaderState(shader);

// Our chess texture is bound to texture unit 0
shaderState.setUniform("chessTexture", Rendering.Uniform.INT, [0]);
// Set the showTexture uniform to true in the shader
shaderState.setUniform("showTexture", Rendering.Uniform.BOOL, [true]);

// Create our ShaderUniformState and set the showTexture uniform to false
var uniformState = new MinSG.ShaderUniformState();
uniformState.setUniform("showTexture", Rendering.Uniform.BOOL, [false]);

// First add the shaderState and then our ShaderUniformState so that latter
// will take effect. 
geo += shaderState;
geo += uniformState;

// Create new scene and add node to it
var sceneNode = new MinSG.ListNode();
sceneNode += geo;
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
