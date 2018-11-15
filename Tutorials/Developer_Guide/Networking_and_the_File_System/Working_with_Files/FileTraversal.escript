/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2016/2017 Florian Pieper <fpieper@mail.upb.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

static printFile = fn(filePath){
	var fileContent = IO.loadTextFile(filePath);
	outln("Content of file " + filePath + ":");
	outln(fileContent);
};

static traverseFolder = fn(rootFolder){
	var queue = [rootFolder];
	
	while(!queue.empty()){
		var f = queue.popFront();
	
		if(IO.isFile(f)){
			outln("Found a file: " + f);
			printFile(f);
		}
		
		if(IO.isDir(f)){
			outln("Found a folder: " + f);
			
			var content = IO.dir(f, IO.DIR_BOTH);
			foreach(content as var entry){
				queue += entry;
			}
		}
	}
};

static traverseFolderAlternative = fn(rootFolder){
	var c = IO.dir(rootFolder, IO.DIR_RECURSIVE|IO.DIR_BOTH);
	foreach(c as var f){
		if(IO.isFile(f)){
			outln("Found a file: " + f);
			printFile(f);
		}
			
		if(IO.isDir(f)){
			outln("Found a folder: " + f);
		}
	}
};


var rootFolder = __DIR__ + "/test_folder";
traverseFolder(rootFolder);
outln("\n________________________________________\n");
traverseFolderAlternative(rootFolder);
