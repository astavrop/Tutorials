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
	this.shownImageFile := new Std.DataWrapper();
	this.shownImageFile.onDataChanged += [this] => fn(imageViewer, file){
		if(!file)
			return;
			
		var image = gui.loadImage(file);
		
		imageViewer.imagePanel.clear();
		imageViewer.imagePanel.add(image);
		
		imageViewer.currentImage = image;
	};
	
	this.currentImage := void;
	
	this.imagesInFolder := void;
	this.imageFolderIndex := 0;

	this.imagePanel := void;
	
	this.window := this.createWindow();
	this.window.setEnabled(true);
};

ImageViewer.getAllImagesInFolder := fn(folder){
	if(!folder || !IO.isDir(folder))
		return void;
	
	var images = [];
	var filter = [".png", ".jpg", ".bmp"];
	
	var files = IO.dir(folder, IO.DIR_FILES);
	
	foreach(files as var file){
		foreach(filter as var fileEnding){
			if(file.endsWith(fileEnding))
				images += file;
		}
	} 
	
	if(images.empty())
		return void;
	
	return images;
};

ImageViewer.saveCurrentImageToFile := fn(file){
	if(!this.currentImage || !file)
		return;

	var bitmap = this.currentImage.getImageData().getBitmap();
	Util.saveBitmap(bitmap, file);
};

//creating the UI
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
						var diag = new GUI.FileDialog
						(
							"Open Image Folder...",
							__DIR__,
							void,
							[imageViewer] => fn(imageViewer, folder){
								imageViewer.imageFolderIndex = 0;
								imageViewer.imagesInFolder = imageViewer.getAllImagesInFolder(folder);
								
								if(!imageViewer.imagesInFolder)
									return;
									
								imageViewer.shownImageFile(imageViewer.imagesInFolder[imageViewer.imageFolderIndex]);
							}
						);
						diag.folderSelector = true;
						diag.init();
					}
				},
				
				{
					GUI.LABEL : "Open Image File...",
					GUI.ON_CLICK : [this] => fn(imageViewer){
						var diag = new GUI.FileDialog
						(
							"Open Image File...",
							__DIR__,
							[".png", ".jpg", ".bmp"],
							[imageViewer] => fn(imageViewer, fileName){
								imageViewer.imageFolderIndex = 0;
								imageViewer.imagesInFolder = void;
								imageViewer.shownImageFile(fileName);
							} 
						);
						diag.initialFilename = "";
						diag.init();
					}
				},
				
				'----',
				
				{
					GUI.LABEL : "Save File as...",
					GUI.ON_CLICK : [this] => fn(imageViewer){
						if(!imageViewer.currentImage || !imageViewer.shownImageFile())
							return;
					
						var diag = new GUI.FileDialog
						(
							"Save File as...",
							__DIR__,
							[".png", ".jpg", ".bmp"],
							[imageViewer] => fn(imageViewer, fileName){
								if(IO.isFile(fileName)){
									var overWriteMsg = gui.createPopupWindow(300,100,"The file already exists. Do you want to overwrite it?");
									overWriteMsg.addAction(
										"Yes", 
										[imageViewer, fileName] => fn(imageViewer, fileName){
											imageViewer.saveCurrentImageToFile(fileName);
										});
									overWriteMsg.addAction("No");
									overWriteMsg.init();
								}
								else
									imageViewer.saveCurrentImageToFile(fileName);
							} 
						);
						diag.initialFilename = "";
						diag.init();
					}
				},
				
				{
					GUI.LABEL : "Save File...",
					GUI.ON_CLICK : [this] => fn(imageViewer){
						if(!imageViewer.currentImage || !imageViewer.shownImageFile())
							return;
							
						imageViewer.saveCurrentImageToFile(imageViewer.shownImageFile());
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
				if(!imageViewer.imagesInFolder || imageViewer.imageFolderIndex == 0)
					return;
				
				imageViewer.imageFolderIndex--;
				imageViewer.shownImageFile(imageViewer.imagesInFolder[imageViewer.imageFolderIndex]);
			}
		},
		{
			GUI.TYPE : GUI.TYPE_BUTTON,
			GUI.ICON : "#Tut_Right",
			GUI.TOOLTIP : "Next Image",
			GUI.ON_CLICK : [this] => fn(imageViewer){
				if(!imageViewer.imagesInFolder || imageViewer.imageFolderIndex >= imageViewer.imagesInFolder.count()-1)
					return;
				
				imageViewer.imageFolderIndex++;
				imageViewer.shownImageFile(imageViewer.imagesInFolder[imageViewer.imageFolderIndex]);
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