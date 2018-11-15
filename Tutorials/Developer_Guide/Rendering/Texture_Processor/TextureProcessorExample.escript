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
static TextureProcessor = Std.module('LibRenderingExt/TextureProcessor');

// typical vertex shader for TextureProcessor
// it just forwards the position and texture coordinate
var vertexShaderCode = "
void main(void){
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = ftransform();
}";

var fragmentShaderCode = "
#version 120
uniform sampler2D uTexture;
void main(void) {
	vec2 uv = gl_TexCoord[0].st;
	vec4 color = texture2D(uTexture, uv);
	color.rgb = 1 - abs(2 * color.rgb - 1);
	gl_FragColor = color;
}
";
// create shader
var shader = Rendering.Shader.createShader(vertexShaderCode, fragmentShaderCode);

// create input and output textures
var input = Rendering.createNoiseTexture(256, 256, false, 0.01);
var output = Rendering.createStdTexture(256, 256, true);

// create and execute TextureProcessor
(new TextureProcessor)
	.setInputTextures([input])
	.setOutputTexture(output)
	.setShader(shader)
	.execute();

// just save the result to the filesystem
Rendering.saveTexture(renderingContext, output, "presets/output.png");
