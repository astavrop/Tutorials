/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2016 Florian Pieper <fpieper@mail.upb.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

static ImageViewer = new Type();

ImageViewer.init := fn(){
	this.imagePanel := void;
	
	this.window := this.createWindow();
	this.window.setEnabled(true);
};

ImageViewer.createWindow := fn(){
	var window = gui.createWindow(800, 800, "Image Viewer Tutorial Version 1");
	window.setPosition(50, 50);
	
	var contentPanel = gui.createPanel(800, 700);
	contentPanel.setExtLayout(
			GUI.POS_X_ABS|GUI.REFERENCE_X_LEFT|GUI.ALIGN_X_LEFT|
			GUI.POS_Y_ABS|GUI.REFERENCE_Y_TOP|GUI.ALIGN_Y_TOP|
			GUI.WIDTH_ABS|GUI.HEIGHT_ABS,
			new Geometry.Vec2(0,0),new Geometry.Vec2(-1, -1) 
    );

    contentPanel += [{
    	GUI.TYPE : GUI.TYPE_PANEL,
    	GUI.FLAGS : GUI.BORDER,	
    	GUI.POSITION : [GUI.POS_X_ABS|GUI.REFERENCE_X_LEFT|GUI.ALIGN_X_LEFT|
						GUI.POS_Y_ABS|GUI.REFERENCE_Y_TOP|GUI.ALIGN_Y_TOP ,0,0],
    	GUI.SIZE : [GUI.WIDTH_ABS|GUI.HEIGHT_ABS, -20, 75],
    	GUI.CONTENTS : [this.createMenu(), this.createToolBar()]    
    }];
    
	this.imagePanel = gui.create({
    	GUI.TYPE : GUI.TYPE_PANEL,
    	GUI.FLAGS : GUI.BORDER,	
    	GUI.WIDTH : 750,
    	GUI.HEIGHT : 400,
    	GUI.POSITION : [GUI.POS_X_ABS|GUI.REFERENCE_X_LEFT|GUI.ALIGN_X_LEFT|
						GUI.POS_Y_ABS|GUI.REFERENCE_Y_TOP|GUI.ALIGN_Y_TOP ,0,0],
    	GUI.SIZE : [GUI.WIDTH_ABS|GUI.HEIGHT_ABS, -20, -100]   
    });
	
	contentPanel += [{GUI.TYPE : GUI.TYPE_NEXT_ROW}];
	contentPanel.add(this.imagePanel);
	window += contentPanel;
	
	return window;
};

ImageViewer.createMenu := fn(){
	var menu = gui.createPanel(100, 50, GUI.AUTO_LAYOUT);
	
	menu += [
		{
			GUI.TYPE				:	GUI.TYPE_MENU,
			GUI.TOOLTIP				:	"File",
			GUI.ICON				:	"#File",
			GUI.MENU				:	[
				{
					GUI.LABEL : "Open Folder...",
					GUI.ON_CLICK : [this] => fn(imageViewer){
						;
					}
				},
				
				{
					GUI.LABEL : "Open Image File...",
					GUI.ON_CLICK : [this] => fn(imageViewer){
						;
					}
				},
				
				'----',
				
				{
					GUI.LABEL : "Save File as...",
					GUI.ON_CLICK : [this] => fn(imageViewer){
						;
					}
				},
				
				{
					GUI.LABEL : "Save File...",
					GUI.ON_CLICK : [this] => fn(imageViewer){
						
					}
				},
				
				'----',
				
				{
					GUI.LABEL : "Close",
					GUI.ON_CLICK : [this] => fn(imageViewer){					
						imageViewer.window.close();
					}
				}
			],	
		},
		
		{
			GUI.TYPE				:	GUI.TYPE_MENU,
			GUI.TOOLTIP				:	"Settings",
			GUI.ICON				:	"#Settings",
			GUI.MENU_WIDTH			: 	150,
			GUI.MENU				:	[
				{
					GUI.LABEL : "Choose Color...",
					GUI.ON_CLICK : [this] => fn(imageViewer){
						;
					}
				}
			
			],
		},
	];
	
	
	return menu;
};

ImageViewer.createToolBar := fn(){
	gui.loadIconFile(__DIR__ + "/resources/icons.json");
	
	var toolBar = gui.createPanel(450, 55, GUI.AUTO_LAYOUT);
	
	toolBar += [
		{
			GUI.TYPE : GUI.TYPE_BUTTON,
			GUI.ICON : "#Tut_Left",
			GUI.TOOLTIP : "Previouse Image",
			GUI.ON_CLICK : [this] => fn(imageViewer){
				;
			}
		},
		{
			GUI.TYPE : GUI.TYPE_BUTTON,
			GUI.ICON : "#Tut_Right",
			GUI.TOOLTIP : "Next Image",
			GUI.ON_CLICK : [this] => fn(imageViewer){
				;
			}
			
		}	
	];
	
	static btnDrawTool;
	static btnMoveTool;
	
	btnDrawTool = gui.create({
		GUI.TYPE : GUI.TYPE_BUTTON,
		GUI.ICON : "#Tut_Pen",
		GUI.TOOLTIP : "Draw Tool",
		GUI.ON_CLICK : [this] => fn(imageViewer){
			btnDrawTool.setSwitch(true);
			btnMoveTool.setSwitch(false);
		}
	});
	
	btnMoveTool = gui.create({
		GUI.TYPE : GUI.TYPE_BUTTON,
		GUI.ICON : "#Tut_Move",
		GUI.TOOLTIP : "Move Tool",
		GUI.ON_CLICK : [this] => fn(imageViewer){
			btnDrawTool.setSwitch(false);
			btnMoveTool.setSwitch(true);
		}
	});
	
	toolBar += btnDrawTool;
	toolBar += btnMoveTool;
	
	return toolBar;
};

var imageViewer = new ImageViewer();
imageViewer.init();