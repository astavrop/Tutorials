/*
	This file is part of the GUI library.
	Copyright (C) 2008-2013 Benjamin Eikel <benjamin@eikel.org>
	Copyright (C) 2008-2012 Claudius Jähn <claudius@uni-paderborn.de>
	Copyright (C) 2008-2012 Ralf Petring <ralf@petring.net>
	
	This library is subject to the terms of the Mozilla Public License, v. 2.0.
	You should have received a copy of the MPL along with this library; see the 
	file LICENSE. If not, you can obtain one at http://mozilla.org/MPL/2.0/.
*/
#include "Checkbox.h"
#include "../GUI_Manager.h"
#include "../Base/Draw.h"
#include "../Base/AbstractShape.h"
#include "ComponentPropertyIds.h"
#include <Util/UI/Event.h>

namespace GUI {

//! (ctor)
Checkbox::Checkbox(GUI_Manager & _gui,bool _checked,const std::string & _text,flag_t _flags/*=0*/)
		:Container(_gui,Geometry::Rect(0,0,16,16),_flags),boolValueRef(nullptr),intValueRef(nullptr),intBitMask(0),value(_checked),
		keyListener(createKeyListener(_gui, this, &Checkbox::onKeyEvent)),
		mouseButtonListener(createMouseButtonListener(_gui, this, &Checkbox::onMouseButton)),
		mouseClickListener(createMouseClickListener(_gui,
													this,
													[this](Component *, unsigned int, const Geometry::Vec2 &) {
														if(!isLocked()) {
															action();
														}
														return true;
													})) {
	setFlag(SELECTABLE,true);

	// create Label
	textLabel=new Label(getGUI());
	textLabel->setTextStyle(Draw::TEXT_ALIGN_LEFT|Draw::TEXT_ALIGN_MIDDLE);
	addContent(textLabel.get());

	if(!_text.empty()){
		setText(_text);

		// guess the initial size using the default font
		const Geometry::Vec2 textSize = Draw::getTextSize(_text,getGUI().getActiveFont(PROPERTY_DEFAULT_FONT));
		setSize( textSize.getWidth()+getGUI().getGlobalValue(PROPERTY_CHECKBOX_LABEL_INDENTATION), textSize.getHeight() );
	}
}

//! (dtor)
Checkbox::~Checkbox() = default;

//! ---|> Component
void Checkbox::doLayout(){
	Geometry::Rect r=getLocalRect();

	const float indentation = getGUI().getGlobalValue(PROPERTY_CHECKBOX_LABEL_INDENTATION);
	r.changeSize(-indentation,0);
	r.moveRel(indentation,0);
	textLabel->setRect(r);
}

//! ---|> Component
void Checkbox::doDisplay(const Geometry::Rect & region){
	enableLocalDisplayProperties();
	displayDefaultShapes();
	
	const Geometry::Rect r=Geometry::Rect(3,2,8,8);

	if (isActive()){
		getGUI().displayShape(PROPERTY_CHECKBOX_SHAPE,r,0);

		Draw::moveCursor(Geometry::Vec2(1,1));

		if(isChecked())
			getGUI().displayShape(PROPERTY_CHECKBOX_MARKER_SHAPE,r,AbstractShape::ACTIVE);

		Draw::moveCursor(-Geometry::Vec2(1,1));
	}
	else{
		getGUI().displayShape(PROPERTY_CHECKBOX_SHAPE,r,AbstractShape::ACTIVE);
		if(isChecked())
			getGUI().displayShape(PROPERTY_CHECKBOX_MARKER_SHAPE,r);
	}
	if(isSelected()){
		Geometry::Rect rect=getLocalRect();
		rect.changeSizeCentered(2, 2);
		getGUI().displayShape(PROPERTY_SELECTION_RECT_SHAPE,rect);
	}
	disableLocalDisplayProperties();
	
	displayChildren(region);
}

//! ---|> MouseButtonListener
bool Checkbox::onMouseButton(Component * /*component*/, const Util::UI::ButtonEvent & buttonEvent){
	if(buttonEvent.pressed){
		select();
		if(buttonEvent.button == Util::UI::MOUSE_BUTTON_LEFT) {
			activate();
		}
	}
	return true;

}

bool Checkbox::onKeyEvent(const Util::UI::KeyboardEvent & keyEvent) {
	if(!isLocked() && (keyEvent.key == Util::UI::KEY_RETURN || keyEvent.key == Util::UI::KEY_SPACE)){
		select();
		if(keyEvent.pressed){
			activate();
		}else{
			if(isActive())
				action();
			deactivate();
		}
		return true;
	}
	return false;
}


bool Checkbox::isChecked()const{
	if(boolValueRef)
		return *boolValueRef;
	else if(intValueRef)
		return (*intValueRef)&intBitMask;
	else
		return value;
}


void Checkbox::setChecked(bool b){
	invalidateRegion();
	if(boolValueRef)
		(*boolValueRef)=b;
	else if(intValueRef){
		if(b)
			(*intValueRef)|=intBitMask;
		else
			(*intValueRef)-=((*intValueRef)&intBitMask);
	}
	else
		value=b;
}


void Checkbox::setValueRef(bool * _boolRef){
	intValueRef=nullptr;
	intBitMask=0;
	boolValueRef=_boolRef;
}


void Checkbox::setValueRef(unsigned int * _intValueRef,unsigned int _intBitMask){
	intValueRef=_intValueRef;
	intBitMask=_intBitMask;
	boolValueRef=nullptr;
}

//! ---o
void Checkbox::action(){
	setChecked(!isChecked());
	getGUI().componentDataChanged(this);
}


void Checkbox::setText(const std::string & text){
	textLabel->setText(text);
	invalidateRegion();
}


std::string Checkbox::getText()const{
	return textLabel->getText();
}

}
