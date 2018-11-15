/*
	This file is part of the GUI library.
	Copyright (C) 2008-2013 Benjamin Eikel <benjamin@eikel.org>
	Copyright (C) 2008-2012 Claudius Jähn <claudius@uni-paderborn.de>
	Copyright (C) 2008-2012 Ralf Petring <ralf@petring.net>
	
	This library is subject to the terms of the Mozilla Public License, v. 2.0.
	You should have received a copy of the MPL along with this library; see the 
	file LICENSE. If not, you can obtain one at http://mozilla.org/MPL/2.0/.
*/
#ifndef GUI_TEXTAREA_H
#define GUI_TEXTAREA_H

#include "Container.h"
#include "../Base/ListenerHelper.h"
#include "../Base/Fonts/AbstractFont.h"
#include <array>
#include <memory>

namespace GUI {

class Scrollbar;
class TextareaTextProcessor;

/***
 **  Textarea ---|> Container
 **/
class Textarea: public Container {
		PROVIDES_TYPE_NAME(Textarea)
	public:
		Textarea(GUI_Manager & gui,flag_t flags);
		virtual ~Textarea();

		void setText(const std::string & newText);
		std::string getText()const;

		// ---|> Component
		virtual bool onSelect() override;
		virtual bool onUnselect() override;
		virtual void doLayout() override											{	updateScrollPos();	}

		typedef std::pair<uint32_t,size_t> cursor_t; // line,pos
		typedef std::pair<cursor_t,cursor_t> range_t; // min,max

		const std::string & getLine(uint32_t)const;
		std::string getText(const range_t &)const;
		
		float getTextHeight()const;
		void moveCursor(const cursor_t & _cursorPos,bool updateSelection=false);
		bool isTextSelected()const		{	return selectionStart!=cursor;	}

		AbstractFont* _getActiveFont()const		{	return fontReference.get();	}
		uint32_t _getLineHeight()const			{	return lineHeight;	}
		cursor_t getCursor()const				{	return cursor;	}
		cursor_t getSelectionStart()const		{	return selectionStart;	}
		size_t getNumberOfLines()const			{	return lines.size();	}
	private:
		cursor_t trimToLineLength(cursor_t p)const{	return std::make_pair(p.first,std::min(getLine(p.first).length(),p.second)); }
		
		void consolidate();
		cursor_t _deleteText(const range_t &);
		// ---|> Component
		virtual void doDisplay(const Geometry::Rect & region) override;

		bool onKeyEvent(const Util::UI::KeyboardEvent & keyEvent);
		bool onMouseButton(Component * component, const Util::UI::ButtonEvent & buttonEvent);
		bool onMouseMove(Component * component, const Util::UI::MotionEvent & motionEvent);

		range_t _insertText(const cursor_t & pos,const std::string & s);
		void markForConsolidation(size_t line1,size_t line2){
			linesToConsolidate.first = std::min(linesToConsolidate.first,std::min(line1,line2));
			linesToConsolidate.second = std::max(linesToConsolidate.second,std::max(line1,line2));
		}
		range_t range(cursor_t p1,cursor_t p2)const{
			p1 = trimToLineLength(p1);
			p2 = trimToLineLength(p2);
			return p1<p2 ? std::make_pair(p1,p2) : std::make_pair(p2,p1);
		}
		void updateScrollPos();

		std::vector<std::string> lines;
		Util::Reference<AbstractFont> fontReference; // this is updated by the actual font property on each call of display
		uint32_t lineHeight;
		cursor_t cursor;
		cursor_t selectionStart;
		bool dataChanged;
		std::pair<size_t,size_t> linesToConsolidate;
		Util::Reference<TextareaTextProcessor> processor;

	// ----------------
		
	//!	@name Scrolling
	//	\{
		Util::WeakPointer<Scrollbar> scrollBar;
		std::unique_ptr<DataChangeListenerHandle> optionalScrollBarListener;
		Geometry::Vec2 scrollPos;
		
	public:
		const Geometry::Vec2 & getScrollPos()const	{	return scrollPos;	}
		void scrollTo(const Geometry::Vec2 &);
	//	\}
		
		
	// ----------------

	//!	@name TextUpdates
	//	\{
	public:
		void executeTextUpdate(Textarea::range_t _r1,const std::string & text);
		void redoTextUpdate();
		void undoTextUpdate();
	private:
		//! TextUpdate
		class TextUpdate{
			std::string newText,oldText;
			Textarea::range_t r1,r2;
		public:
			bool extendable; //!< can this command be extended with further data?
			TextUpdate(Textarea::range_t _r1,std::string text ) : 
					newText(std::move(text)),r1(std::move(_r1)),extendable(true){	}
			TextUpdate() : extendable(false){}
			void execute(Textarea &);
			void extend(Textarea& ta,const std::string & s);
			void undo(Textarea &);
			const Textarea::cursor_t &getInsertionCursor()const{	return r2.second;	}
		};
		std::vector<TextUpdate> commands;
		size_t activeTextUpdateIndex;
		
		KeyListener keyListener;
		MouseButtonListener mouseButtonListener;
		OptionalMouseMotionListener optionalMouseMotionListener;
	//	\}
};
//! (internal)
class TextareaTextProcessor : public Util::ReferenceCounter<TextareaTextProcessor>{
public:
	virtual ~TextareaTextProcessor(){}
	virtual void displayText(Textarea&) = 0;
	virtual void consolidateLines(Textarea&,const std::pair<size_t,size_t>&) = 0;
	virtual Geometry::Vec2 cursorToTextPos(const Textarea&,const Textarea::cursor_t&) = 0;
	virtual Textarea::cursor_t textPosToCursor(const Textarea&,const Geometry::Vec2 &)const = 0;

	virtual void onLinesInserted(Textarea&,size_t first,size_t number) = 0;
	virtual void onLineErased(Textarea&,size_t first,size_t number) = 0;

};

}

#endif // GUI_TEXTAREA_H
