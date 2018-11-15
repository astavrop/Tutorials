/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2017 Florian Pieper <fpieper@mail.upb.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

static vertexShader = "
void main(void)
{
  gl_Position = ftransform();
  gl_TexCoord[0] = gl_MultiTexCoord0;
}
";

static fragmentShader = 
"
uniform sampler2D TUnit_1;

uniform float pixelSize;

float getColor(float x, float y){
	vec3 color = vec3(texture2D(TUnit_1, vec2(x,y)));
	return (color[0] + color[1] + color[2]) / 3.0;
}

void main(){
	mat3 filterKernelGx = mat3(1, 0, -1, 2, 0, -2, 1, 0, -1); // Gx sobel filter mask
	mat3 filterKernelGy = mat3(1, 2, 1, 0, 0, 0, -1, -2, -1); // Gy sobel filter mask

	float x = gl_TexCoord[0].s;
	float y = gl_TexCoord[0].t;
	
	float color_x = 0;
	float color_y = 0;
	float color = 0;
	
	if(x-pixelSize > 0.0 && x+pixelSize < 1.0 && y-pixelSize > 0.0 && y+pixelSize < 1.0){
		for(int xOffset = -1; xOffset <=1; xOffset++){
			for(int yOffset = -1; yOffset <=1; yOffset++){
				color_x += getColor(x + (xOffset * pixelSize), y + (yOffset * pixelSize)) * filterKernelGx[xOffset + 1][yOffset + 1];
				color_y += getColor(x + (xOffset * pixelSize), y + (yOffset * pixelSize)) * filterKernelGy[xOffset + 1][yOffset + 1];
			}
		}
	}
	
	color = sqrt(color_x*color_x + color_y*color_y);
	
	gl_FragColor = vec4(color, color, color, 1);
}
";

var Effect = new Type( Std.module('Effects/PPEffect') );

Effect._constructor ::= fn(){
	this.fbo := new Rendering.FBO;
	renderingContext.pushAndSetFBO(fbo);
	
	this.colorTexture_Input := Rendering.createHDRTexture(renderingContext.getWindowWidth(), renderingContext.getWindowHeight(), true);
	this.colorTexture_Output := Rendering.createHDRTexture(renderingContext.getWindowWidth(), renderingContext.getWindowHeight(), true);
	fbo.attachColorTexture(renderingContext, colorTexture_Input);
	
	this.depthTexture := Rendering.createDepthTexture(renderingContext.getWindowWidth(), renderingContext.getWindowHeight());
	fbo.attachDepthTexture(renderingContext, depthTexture);
	
	out(fbo.getStatusMessage(renderingContext), "\n");
	renderingContext.popFBO();
	
	this.shader := Rendering.Shader.createShader(vertexShader, fragmentShader);
	renderingContext.pushAndSetShader(this.shader);
	shader.setUniform(renderingContext,'TUnit_1', Rendering.Uniform.INT, [0]) ;
	renderingContext.popShader();
};

/*! ---|> PPEffect  */
Effect.begin @(override) ::= fn(){
	renderingContext.pushAndSetFBO(fbo);
	fbo.attachColorTexture(renderingContext, colorTexture_Input);
	fbo.attachDepthTexture(renderingContext, depthTexture);
};

/*! ---|> PPEffect  */
Effect.end @(override) ::=fn(){
	fbo.detachDepthTexture(renderingContext);
	
	renderingContext.pushAndSetShader(shader);
	shader.setUniform(renderingContext,'pixelSize', Rendering.Uniform.FLOAT, [1.0/renderingContext.getWindowWidth()]) ;
	
	fbo.attachColorTexture(renderingContext, colorTexture_Output);
	Rendering.drawTextureToScreen(renderingContext, new Geometry.Rect(0,0,renderingContext.getWindowWidth(), renderingContext.getWindowHeight()),
								  this.colorTexture_Input, new Geometry.Rect(0,0,1,1));
	
	renderingContext.popFBO();
	renderingContext.popShader();
	renderingContext.pushAndSetShader(void);
	Rendering.drawTextureToScreen(renderingContext, new Geometry.Rect(0,0,renderingContext.getWindowWidth(), renderingContext.getWindowHeight()),
								  this.colorTexture_Output, new Geometry.Rect(0,0,1,1));
	renderingContext.popShader();
};

return new Effect;