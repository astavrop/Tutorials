---
author: Stanislaw Eppinger
category: Developer Guide
last_updated: November 14, 2018
license: cc-by-sa 4.0
order: 4
permalink: extending_minsg_states_using_c++
subcategory: MinSG - A Minimalist Scene Graph
title: Extending MinSG States using C++
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Stanislaw Eppinger (eppinger@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# State

This chapter provides an example of how to implement a State in C++ with bindings to EScript and how to use this state in EScript. This tutorial is the addition to the description of PADrend's States. 

This tutorial assumes, that you have a working C++ plugin project according to the tutorial [Creating a C++ Plugin](extending_your_plugin_with_c++)

## Implementing a State in C++

In this example we will implement the same state as in the EScript example, i.e. a state which skips rendering if the node, which this state is assigned to, is more than 20 units away from the camera. We call this state `MyState`. We need to inherit from the base class `State` and override the `doEnableState()` method. For didactical purposes we also override the `doDisableState()` method although we don't need to since we don't have to clean anyhting up in our example. The header file `MyState.h` which will be added to your `src` folder looks like this: 

<!---INCLUDE src=files/MyState.h, start=7, end=24--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```cpp
#ifndef MYPROJECT_MYSTATE_H
#define MYPROJECT_MYSTATE_H

#include <MinSG/Core/States/State.h>

namespace MyProject {

class MyState : public MinSG::State {
  PROVIDES_TYPE_NAME(MyState)
public:
  State::stateResult_t doEnableState(MinSG::FrameContext & context, MinSG::Node * node, const MinSG::RenderParam & rp) override;
  void doDisableState(MinSG::FrameContext & context,MinSG::Node *, const MinSG::RenderParam & rp) override;
  MyState * clone() const override;
};

}

#endif /* MYPROJECT_MYSTATE_H */
```
<!---END_CODESECTION--->

In the same folder we'll add the source file `MyState.cpp`, which implements our overridden methods and the actual logic:

<!---INCLUDE src=files/MyState.cpp, start=7, end=32--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```cpp
#include "MyState.h"

#include <MinSG/Core/FrameContext.h>
#include <MinSG/Core/Nodes/CameraNode.h>

namespace MyProject {

using namespace MinSG;
  
State::stateResult_t MyState::doEnableState(FrameContext & context, Node * node, const RenderParam & rp){
  auto camPos = context.getCamera()->getWorldOrigin();
  auto nodePos = node->getWorldOrigin();
  auto diff = (camPos - nodePos).length();
  if (diff > 20) return State::stateResult_t::STATE_SKIP_RENDERING;
  return State::stateResult_t::STATE_OK;
}

void MyState::doDisableState(FrameContext & context, Node * node, const RenderParam & rp) {
  //Clean up everything you have done in doEnableState, e.g. popping shaders from the rendering context
}

MyState * MyState::clone() const {
  return new MyState(*this);
}

}
```
<!---END_CODESECTION--->

The logic of the `doEnableState()` is the same as in the EScript version. We compute the distance between the camera and the node and if it's higher than 20 we return `STATE_SKIP_RENDERING` and the node will not be rendered. Otherwise `STATE_OK` will be returned and the node will be rendered.  
The next step is to provide the EScript bindings in order to use our state in EScript.

### Providing the EScript Bindings

To be able to use our state in EScript we need to provide the bindings. We will not cover all the details, if you want to know more you should take a look at the SimpleExample in the C++ DevGuide.  
First we will add the header file `E_MyState.h` to your `src` folder which looks like this: 

<!---INCLUDE src=files/E_MyState.h, start=7, end=44--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```cpp
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
```
<!---END_CODESECTION--->

Note the two Macros `ES_PROVIDES_TYPE_NAME(MyState)` and `ES_CONV_EOBJ_TO_OBJ(...)` which need to be used in order to provide the name of the class and the conversion.  
Now we need to add the source file `E_MyState.cpp` to the same folder and implement the `init()` method which provides the name and methods of our class to EScript:

<!---INCLUDE src=files/E_MyState.cpp, start=7, end=45--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```cpp
#include "E_MyState.h"

#include <MinSG/Core/FrameContext.h>
#include <EScript/EScript.h>

#include <E_MinSG/Core/Nodes/E_Node.h>
#include <E_MinSG/Core/States/E_State.h>

using namespace EScript;

namespace MyProject {
  
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
  
  //! [ESMF] new MyProject.MyState()
  ES_CTOR(typeObject,0,0,EScript::create(new MyState))

  addFactory<MyState,E_MyState>();
}
//---

E_MyState::E_MyState(MyState * _obj, EScript::Type * type) : E_MinSG::E_State(_obj,type?type:getTypeObject()){
}

E_MyState::~E_MyState() = default;

}
```
<!---END_CODESECTION--->

For further information about providing the EScript binding process you should read the [Creating Object Bindings](../../../3_Development_Guide/2_C++/3_Creating_Object_Bindings/Creating_Object_Bindings.md) tutorial in the C++ DevGuide. It seems very complicated at first but what you basically do is copying and working examples and replace the name of the class with your class name.

Now, you only need to call the `init` method of your new EScript class. 
```
// ...
#include "E_MyState.h"

// ...

// Initializes your EScript bindings
void init(EScript::Namespace * lib) {
  // initialize EScript objects	
  E_MyState::init(*lib);
  // ...
}
```

Don't forget to add your new source files to your CMakeLists.txt and compile your library.
```
# ...
# Add your sources here
add_library(${PROJECT_NAME} SHARED 
  src/Main.cpp # The main entry point for the EScript library loader
  src/ELibMyProject.cpp # Initialize your EScript bindings here
  src/MyState.cpp
  src/E_MyState.cpp
)
# ...
```

### Using the state

Now we can go ahead and instantiate our state in EScript:

```
var ourState = new MyProject.MyState();
```

This state can be handled as every other state and e.g. be added to a particular node.


