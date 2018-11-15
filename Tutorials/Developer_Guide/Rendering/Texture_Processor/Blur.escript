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

static TextureProcessor = Std.module('LibRenderingExt/TextureProcessor');

// typical vertex shader for TextureProcessor
// it just forwards the position and texture coordinate
var vertexShaderCode = "
void main(void){
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = ftransform();
}";

var fragmentShaderCode = "
// 3 * 3 Kernel
#define KERNEL_SIZE 9

// input texture
uniform sampler2D uImage;
// dimensions of input
uniform float uWidth;
uniform float uHeight;

// used to convert from bitmap space [0..size-1] to texture space [0..1]
const float step_w = 1.0/uWidth;
const float step_h = 1.0/uHeight;

// Gaussian kernel
// 1 2 1
// 2 4 2
// 1 2 1	
// sum = 16
const float kernel[KERNEL_SIZE] = { 
	1.0/16.0, 2.0/16.0, 1.0/16.0,
	2.0/16.0, 4.0/16.0, 2.0/16.0,
	1.0/16.0, 2.0/16.0, 1.0/16.0 
};

const vec2 offset[KERNEL_SIZE] = { 
	vec2(-step_w, -step_h), vec2(0.0, -step_h), vec2(step_w, -step_h), 
	vec2(-step_w, 0.0), vec2(0.0, 0.0), vec2(step_w, 0.0), 
	vec2(-step_w, step_h), vec2(0.0, step_h), vec2(step_w, step_h) 
};

void main(void) {
	vec2 uv = gl_TexCoord[0].st;
	vec4 sum = vec4(0.0);
	for(int i = 0; i < KERNEL_SIZE; i++) {
		vec4 tmp = texture2D(uImage, uv + offset[i]);
		sum += tmp * kernel[i];
	}
	gl_FragColor = sum;
}
";

// create input and output textures
var input = Rendering.createTextureFromFile("presets/PADrendIcon.png");
static width = input.getWidth();
static height = input.getHeight();
var output = Rendering.createStdTexture(width, height, true);

// create shader
var shader = Rendering.Shader.createShader(vertexShaderCode, fragmentShaderCode);
shader.setUniform(renderingContext, new Rendering.Uniform('uWidth', Rendering.Uniform.FLOAT, [width]), false);
shader.setUniform(renderingContext, new Rendering.Uniform('uHeight', Rendering.Uniform.FLOAT, [height]), false);

// create and execute TextureProcessor
(new TextureProcessor)
	.setInputTextures([input])
	.setOutputTexture(output)
	.setShader(shader)
	.execute();

// just save the result to the filesystem
Rendering.saveTexture(renderingContext, output, "presets/blurredOutput.png");
