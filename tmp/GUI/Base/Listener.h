/*
	This file is part of the GUI library.
	Copyright (C) 2013 Benjamin Eikel <benjamin@eikel.org>
	
	This library is subject to the terms of the Mozilla Public License, v. 2.0.
	You should have received a copy of the MPL along with this library; see the 
	file LICENSE. If not, you can obtain one at http://mozilla.org/MPL/2.0/.
*/
#ifndef GUI_LISTENER_H
#define GUI_LISTENER_H

#include <Util/Registry.h>
#include <functional>
#include <list>

namespace Geometry {
template<typename T_> class _Vec2;
typedef _Vec2<float> Vec2f;
}
namespace Util {
namespace UI {
struct ButtonEvent;
struct KeyboardEvent;
struct MotionEvent;
}
class StringIdentifier;
}

namespace GUI {

class Component;

/**
 * Type of functions reacting on an action. The function receives the component
 * that caused the action as parameter, and the associated action name. If it
 * returns @c true, the callee signalizes that is processed the action and no
 * other action handlers will be called. If it returns @c false, the callee
 * signalizes that it did not process the action and the next action handler
 * will be called.
 */
typedef std::function<bool (Component *, 
							const Util::StringIdentifier &)> HandleActionFun;

/**
 * Type of functions reacting on the destruction of a component. The function
 * will be called only once for the destruction of the respective component.
 * After that, it will be removed from the registry automatically.
 */
typedef std::function<void ()> HandleComponentDestructionFun;

/**
 * Type of functions reacting on a change of a component's data. The function
 * receives the component for which the data has changed as parameter.
 */
typedef std::function<void (Component *)> HandleDataChangeFun;

/**
 * Type of functions reacting on the end of a frame. The function receives the
 * time since the start of the program in seconds as parameter.
 */
typedef std::function<void (double)> FrameListenerFun;

/**
 * Type of functions reacting on global key events. The function receives the
 * keyboard event as parameter
 * If it returns @c true, the callee signalizes that is processed the event and
 * no other event handlers will be called. If it returns @c false, the callee
 * signalizes that it did not process the event and the next event handler
 * will be called.
 */
typedef std::function<bool (const Util::UI::KeyboardEvent &)> HandleKeyFun;

/**
 * Type of functions reacting on a mouse button event onto a component. The
 * function receives the component onto which the mouse button event was
 * detected, and the mouse button event.
 * If it returns @c true, the callee signalizes that is processed the event and
 * no other event handlers will be called. If it returns @c false, the callee
 * signalizes that it did not process the event and the next event handler
 * will be called.
 */
typedef std::function<bool (Component *, 
							const Util::UI::ButtonEvent &)> HandleMouseButtonFun;

/**
 * Type of functions reacting on a mouse click (mouse button down and mouse 
 * button up) onto a component. The function receives the component onto which
 * the mouse click was detected, the mouse button, and the local position of
 * the click inside the component.
 * If it returns @c true, the callee signalizes that is processed the click and
 * no other click handlers will be called. If it returns @c false, the callee
 * signalizes that it did not process the click and the next click handler
 * will be called.
 * 
 * @note In order to receive mouse clicks on a component, the component has to
 * get activated via MouseButtonListener first.
 */
typedef std::function<bool (Component *, 
							unsigned int, 
							const Geometry::Vec2f &)> HandleMouseClickFun;

/**
 * Type of functions reacting on a mouse motion event onto a component. The
 * function receives the component onto which the mouse motion event was
 * detected, and the mouse motion event.
 * If it returns @c true, the callee signalizes that is processed the event and
 * no other event handlers will be called. If it returns @c false, the callee
 * signalizes that it did not process the event and the next event handler
 * will be called.
 */
typedef std::function<bool (Component *, 
							const Util::UI::MotionEvent &)> HandleMouseMotionFun;



//! Registry for functions reacting on actions.
typedef Util::Registry<std::list<HandleActionFun>> ActionListenerRegistry;
//! Registry for functions reacting on the destruction of a component.
typedef Util::Registry<std::list<HandleComponentDestructionFun>> ComponentDestructionListenerRegistry;
//! Registry for functions reacting on a change of a component's data.
typedef Util::Registry<std::list<HandleDataChangeFun>> DataChangeListenerRegistry;
//! Registry for functions reacting on the end of a frame.
typedef Util::Registry<std::list<FrameListenerFun>> FrameListenerRegistry;
//! Registry for functions reacting on global key events.
typedef Util::Registry<std::list<HandleKeyFun>> KeyListenerRegistry;
//! Registry for functions reacting on a mouse button event.
typedef Util::Registry<std::list<HandleMouseButtonFun>> MouseButtonListenerRegistry;
//! Registry for functions reacting on a mouse click.
typedef Util::Registry<std::list<HandleMouseClickFun>> MouseClickListenerRegistry;
//! Registry for functions reacting on a mouse motion event.
typedef Util::Registry<std::list<HandleMouseMotionFun>> MouseMotionListenerRegistry;



//! Handle obtained by the registration of a HandleActionFun.
typedef ActionListenerRegistry::handle_t ActionListenerHandle;
//! Handle obtained by the registration of a HandleComponentDestructionFun.
typedef ComponentDestructionListenerRegistry::handle_t ComponentDestructionListenerHandle;
//! Handle obtained by the registration of a HandleDataChangeFun.
typedef DataChangeListenerRegistry::handle_t DataChangeListenerHandle;
//! Handle obtained by the registration of a FrameListenerFun.
typedef FrameListenerRegistry::handle_t FrameListenerHandle;
//! Handle obtained by the registration of a HandleKeyFun.
typedef KeyListenerRegistry::handle_t KeyListenerHandle;
//! Handle obtained by the registration of a HandleMouseButtonFun.
typedef MouseButtonListenerRegistry::handle_t MouseButtonListenerHandle;
//! Handle obtained by the registration of a HandleMouseClickFun.
typedef MouseClickListenerRegistry::handle_t MouseClickListenerHandle;
//! Handle obtained by the registration of a HandleMouseMotionFun.
typedef MouseMotionListenerRegistry::handle_t MouseMotionListenerHandle;

}

#endif // GUI_LISTENER_H
