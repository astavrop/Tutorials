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

 static dataWrapper = new Std.DataWrapper("Nothing in here");

 var createWindow = fn(){
 	var window = gui.createWindow(400, 250, "DataWrapper Tutorial");
	window.setPosition(50, 50);

 	var contentPanel = gui.createPanel(400, 150, GUI.AUTO_LAYOUT);

 	contentPanel += [
 		{
 			GUI.TYPE : GUI.TYPE_LABEL,
 			GUI.DATA_WRAPPER : dataWrapper
 		},
 		{
 			GUI.TYPE : GUI.TYPE_NEXT_ROW
 		},
 		{
 			GUI.TYPE : GUI.TYPE_SELECT,
 			GUI.LABEL : "Choose some item",
 			GUI.OPTIONS : [["An item"], ["Another Item"], ["Something different"]],
 			GUI.DATA_WRAPPER : dataWrapper
 		}
 	];

 	window += contentPanel;
 	window.setEnabled(true);
 };

 createWindow();
