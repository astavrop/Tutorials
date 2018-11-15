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
static ColorDialog = new Type();

static Tool = new Type();
Tool.mouseDown := fn(x, y, button){};
Tool.mouseMove := fn(x, y, dx, dy, button){};
Tool.mouseUp := fn(x, y, button){};

static DrawTool = new Type(Tool);
static MoveTool = new Type(Tool);

ColorDialog.selectColor := fn(index){
	foreach(this.colorLabels as var label){
		label.setFlag(GUI.BORDER, false);
	}
	
	if(index < 0 || index >= this.colors.size()){
		this.currentColor = void;
		return;
	}
	
	this.currentColor = this.colors[index];
	this.colorLabels[index].setFlag(GUI.BORDER, true);
};

ColorDialog.getIndexForColor := fn(colorToCheck){
	if(!colorToCheck)
		return -1;
		
	foreach(this.colors as var index, var color){
		if(color == colorToCheck)
			return index;
	}
	
	//color not found
	return -1;
};

ColorDialog.createContent := fn(){
	var colorPanel = gui.createPanel(370,60);
	
	foreach(this.colors as var index, var color){
		var lbl = gui.create({
			GUI.TYPE : GUI.TYPE_BUTTON,
			GUI.COLOR : color,
			GUI.PROPERTIES : [new GUI.ColorProperty(GUI.PROPERTY_BUTTON_HOVERED_TEXT_COLOR, color)],
			GUI.LABEL : "COL",
			GUI.WIDTH : 40,
			GUI.HEIGHT : 40,
			GUI.ON_CLICK : [index, this] => fn(selfIndex, dialog){
				dialog.selectColor(selfIndex);
			}
		});
		
		this.colorLabels += lbl;
		colorPanel += lbl;
	}

	this.diag := gui.createDialog({
		GUI.TYPE : GUI.TYPE_POPUP_DIALOG,
		GUI.LABEL : "Choose Color...",
		GUI.SIZE : [400, 130],
		GUI.CONTENTS : [colorPanel],
		GUI.ACTIONS : [
			["Abort",fn(){;}],
			["Okay", [this] => fn(colorDialog){
				colorDialog.onConfirm(colorDialog.currentColor);
			}]
		],
	});
};

ColorDialog.init := fn(oldColor){
	this.colors := [
		new Util.Color4f(1.0, 1.0, 1.0, 1.0),
		new Util.Color4f(1.0, 1.0, 0.0, 1.0),
		new Util.Color4f(1.0, 0.0, 1.0, 1.0),
		new Util.Color4f(1.0, 0.0, 0.0, 1.0),
		new Util.Color4f(0.0, 1.0, 1.0, 1.0),
		new Util.Color4f(0.0, 1.0, 0.0, 1.0),
		new Util.Color4f(0.0, 0.0, 1.0, 1.0),
		new Util.Color4f(0.0, 0.0, 0.0, 1.0)
	];
	
	this.currentColor := oldColor;
	this.colorLabels := [];
	this.onConfirm := new Std.MultiProcedure();

	this.createContent();
	
	var index = this.getIndexForColor(this.currentColor);
	this.selectColor(index);
};

ColorDialog.openDialog := fn(callBackFunction, oldColor){
	this.init(oldColor);
	this.onConfirm += callBackFunction;
	this.diag.init();
};

//----------------------------------------------------------------

DrawTool._constructor := fn(color = Util.Color4f(0,0,0,1)){
	this.image := void;
	this.color := color;
};

DrawTool.setColor := fn(color){
	this.color = color;
};

DrawTool.setImage := fn(image){
	this.image = image;
};

DrawTool.paintPixel := fn(x,y){
	if(!this.image)
		return;
		
	if(!this.color){
		outln("No color set!");
		return;
	}
	
	var accessor = this.image.getImageData().createPixelAccessor();
	
	for(var px = x-1; px <= x+1; px++)
		for(var py = y-1; py <= y+1; py++)
			if(px >= 0 && py >= 0 && px < accessor.getWidth() && py < accessor.getHeight())
				accessor.writeColor(px, py, this.color);
		
	this.image.dataChanged();
};

DrawTool.mouseDown = fn(x, y, button){
	if(button == Util.UI.MOUSE_BUTTON_LEFT)
		this.paintPixel(x, y);
};

DrawTool.mouseMove = fn(x, y, dx, dy, button){
	if(button == Util.UI.MASK_MOUSE_BUTTON_LEFT)
		this.paintPixel(x, y);
};

DrawTool.mouseUp = fn(x, y, button){
	if(button == Util.UI.MOUSE_BUTTON_LEFT)
		this.paintPixel(x, y);
};

//----------------------------------------------------------------

MoveTool._constructor := fn(imagePanel){
	this.imagePanel := imagePanel;
};

MoveTool.scroll := fn(dx, dy){
	if(!this.imagePanel)
		return;
		
	var delta = new Geometry.Vec2(-dx, -dy);
	
	var oldPosition = this.imagePanel.getScrollPos();
	var newPosition = oldPosition + delta;
	
	this.imagePanel.scrollTo(newPosition);
};

MoveTool.mouseMove = fn(x, y, dx, dy, button){
	if(button == Util.UI.MASK_MOUSE_BUTTON_LEFT){
		this.scroll(dx, dy);		
	}
};

//-----------------------------------------------------------------

ImageViewer.init := fn(){
	this.shownImageFile := new Std.DataWrapper();
	this.shownImageFile.onDataChanged += [this] => fn(imageViewer, file){
		if(!file)
			return;
			
		var image = gui.loadImage(file);
		
		imageViewer.imagePanel.clear();
		imageViewer.imagePanel.add(image);
		
		imageViewer.drawTool.setImage(image);
		
		imageViewer.currentImage = image;
	};
	
	this.currentImage := void;
	
	this.imagesInFolder := void;
	this.imageFolderIndex := 0;

	this.imagePanel := void;
	
	this.window := this.createWindow();
	
	this.pencileColor  := new Std.DataWrapper(new Util.Color4f(0, 0, 0, 1));
	
	this.drawTool := new DrawTool(this.pencileColor());
	this.moveTool := new MoveTool(this.imagePanel);
	this.currentTool := new Tool(); 
	
	this.pencileColor.onDataChanged += [this.drawTool] => fn(drawTool, newColor){
		drawTool.setColor(newColor);
	};
	
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

ImageViewer.openColorDialog := fn(){
	var dialog = new ColorDialog();
	dialog.openDialog([this] => fn(imageViewer, newColor){
			imageViewer.pencileColor(newColor);
		},
		this.pencileColor());
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
	
	//Mouse Listener
	Util.registerExtensionRevocably('PADrend_UIEvent', 
		[this] => fn(imageViewer, event){
			if(event.type == Util.UI.EVENT_MOUSE_BUTTON || event.type == Util.UI.EVENT_MOUSE_MOTION){
				if(!imageViewer.currentImage || !imageViewer.imagePanel.getAbsRect().contains(event.x, event.y))
					return;
					
				var x = event.x - imageViewer.currentImage.getAbsRect().getX();
				var y = event.y - imageViewer.currentImage.getAbsRect().getY();
					
				if(event.type == Util.UI.EVENT_MOUSE_BUTTON){
					if(event.pressed)
						imageViewer.currentTool.mouseDown(x, y, event.button);
					else	
						imageViewer.currentTool.mouseUp(x, y, event.button);
				}
				if(event.type == Util.UI.EVENT_MOUSE_MOTION){
					imageViewer.currentTool.mouseMove(x, y, event.deltaX, event.deltaY, event.buttonMask);
				}
			}
		}
	);
	
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
						imageViewer.openColorDialog();
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
			
			imageViewer.currentTool = imageViewer.drawTool;
		}
	});
	
	btnMoveTool = gui.create({
		GUI.TYPE : GUI.TYPE_BUTTON,
		GUI.ICON : "#Tut_Move",
		GUI.TOOLTIP : "Move Tool",
		GUI.ON_CLICK : [this] => fn(imageViewer){
			btnDrawTool.setSwitch(false);
			btnMoveTool.setSwitch(true);
			
			imageViewer.currentTool = imageViewer.moveTool;
		}
	});
	
	toolBar += btnDrawTool;
	toolBar += btnMoveTool;
	
	return toolBar;
};

var imageViewer = new ImageViewer();
imageViewer.init();