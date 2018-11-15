/*
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Stanislaw Eppinger (eppinger@mail.uni-paderborn.de)
 PADrend Version 1.0.0
*/
#ifndef MYPROJECT_E_MYSTATE_H
#define MYPROJECT_E_MYSTATE_H

#include "MyState.h"
#include <E_MinSG/Core/States/E_State.h>

namespace EScript {
class Namespace;
class Runtime;
class Type;
}

namespace MyProject {
/***
 **   E_MyState ---|> E_State ---|> Object
 **/
class E_MyState : public E_MinSG::E_State {
		ES_PROVIDES_TYPE_NAME(MyState)
	public:
		template<class, class, class> friend class Util::PolymorphicWrapperCreator;

		static EScript::Type* getTypeObject();
		static void init(EScript::Namespace & lib);

		virtual ~E_MyState();

		const MyState * operator*()const	{	return static_cast<const MyState*>(ref().get());	}
		MyState * operator*()	{	return static_cast<MyState*>(ref().get());	}

	protected:
		E_MyState(MyState * obj, EScript::Type * type=nullptr);
};

}

ES_CONV_EOBJ_TO_OBJ(MyProject::E_MyState, MyProject::MyState*, **eObj)

#endif /* MYPROJECT_E_MYSTATE_H */
