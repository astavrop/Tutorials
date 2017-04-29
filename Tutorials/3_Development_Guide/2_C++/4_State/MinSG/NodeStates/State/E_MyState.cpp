/*
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Stanislaw Eppinger (eppinger@mail.uni-paderborn.de)
 PADrend Version 1.0.0
*/
#include <E_MinSG/Ext/MyState/E_MyState.h>

#include <MinSG/Ext/MyState/MyState.h>

#include <MinSG/Core/FrameContext.h>
#include <EScript/EScript.h>

#include <E_MinSG/Core/Nodes/E_Node.h>
#include <E_MinSG/Core/States/E_State.h>

using namespace EScript;
using namespace MinSG;

namespace E_MinSG {
  
EScript::Type * E_MyState::getTypeObject() {
	// E_MyState ---|> E_State ---|> Object
	static EScript::ERef<EScript::Type> typeObject = new EScript::Type(E_State::getTypeObject());
	return typeObject.get();
}


/**
 * initMembers
 */
void E_MyState::init(EScript::Namespace & lib) {
  // E_MyState ---|> E_State ---|> Object
  EScript::Type * typeObject = E_MyState::getTypeObject();
  declareConstant(&lib,getClassName(),typeObject);
  
  //! [ESMF] new MinSG.MyState()
  ES_CTOR(typeObject,0,0,EScript::create(new MinSG::MyState))

  addFactory<MinSG::MyState,E_MyState>();
}
//---

E_MyState::E_MyState(MinSG::MyState * _obj, EScript::Type * type):E_State(_obj,type?type:getTypeObject()){
}

E_MyState::~E_MyState() = default;

}