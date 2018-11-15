---
author: Henrik Heine, Sascha Brandt
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 3
permalink: from_c++_to_escript_bindings_and_macros
subcategory: EScript
title: From C++ to EScript
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
 Modified by: Sascha Brandt (sascha@brandt.graphics)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->

This chapter will show you a simple example how write EScript bindings for simple C++ objects.
We will basically just add a very simple C++ class to PADrend. For the sake of simplicity we will just add a two dimensional bounding box, which will be described by two `Vec2` instances.

This tutorial assumes, that you have a working C++ plugin project according to the tutorial [Creating a C++ Plugin](../../../3_Development_Guide/2_C++/1_Creating_a_C++_Plugin/Creating_a_C++_Plugin.md)

## Macros
The binding between C++ and EScript is done by C++ macros. In the following you find an overview of macros and what they are used for. Afterwards the tutorial continues with a simple example of a binding.

### Function definition macros
In order to define a function, you have to use these macros. Each of them comes in two flavors: long and short

The short version just uses the long version, but it modifies the last argument:
`LastArg` is transformed to `{ return EScript::value(LastArg); }`

Therefore you use the short version if you just want to do a single statement and return that result, like: `new E_Obj()`. If you want to call a void function or if you want to return something else, you can use the comma operator: `(someFunction(), nullptr)` This will result in calling `someFunction`, but discarding any return value and return the second argument instead. Therefore this is basically a short version for this: `{ someFunction(); return EScript::value(nullptr); }`

The first argument of every function definition macro is the `typeObject`. This is an instance of `EScript::Type` describing your wrapper type. Therefore this objet is typically aquired through a call to `E_MyType::getTypeObject()`. The function will be added to this typeObject.


#### Parameters
Each definition macro has two parameters `min` and `max`, describing the minimal and maximal parameter count allowed for this function. If you want to allow an arbitrary number of arguments, just pass `-1` as the maximal value. EScript will throw an exception if someone tries to call your function with an invalid amount of arguments.
You can access this arguments via the `parameter` variable. This is a variable of the type `ParameterValues` and it is basically a list or array to `ObjRef` instances.
The amount of given arguments can be accessed by `parameter.count()` and each argument by the index operator: `parameter[0]` ... `parameter[n-1]`

It is important to note, that the parameter array contains only `ObjRef` objects. Therefore you have to cast them to a concrete type in order to use them.

Convert an parameter to:
* a *basic* type (like `int`, `float`, `string`, etc.):
 * `int value = parameter[i].toInt()`
 * `float value = parameter[i].toFloat()`
 * etc.
* a pointer to an EScript type (or a wrapper type):
 * `E_TargetType* value = parameter[i].toType<E_TargetType>()`
 * e.g.: `E_Vec3* value = parameter[i].toType<E_Vec3>()`.
* any other type:
 * `TargetType value = parameter[i].to<TargetType>(rt)` (`rt` refers to the runtime)
 * e.g. `Vec3* value = parameter[i].to<Vec3*>(rt)`
 * or `Vec3 value = parameter[i].to<Vec3>(rt)`

> `parameter[i].to<TargetType>(rt)` will try to convert the wrapper objetc to the real object. Make sure to use the correct types, not every wrapper can be converted to a pointer, reference, etc.

If you want to test if a parameter is of a specific type, you have to convert it to a pointer type and check if it is not a `nullptr`. This can be done by using `toType<E_Type>()` or by using `to<Type*>(rt)`. Example:
```cpp
Vec2* vec = parameter[0].to<Vec2*>(rt);
if(vec != nullptr) {
  // do something with this Vec2*
} else {
  rt.warn("Parameter must be a Vec2");
}
```


#### Constructor
```cpp
// short version
ES_CTOR(typeObject, min, max, returnExpr)
// long version
ES_CONSTRUCTOR(typeObject, min, max, {
  // ...
  return ...;
})
```
The constructor is a special function. It always must return an instance of the wrapper class. So typically you would just return something like:
* `EScript::create(new MyType());`
* or `new E_MyType()`


#### Static class functions
```cpp
// short version
ES_FUN(typeObject, functionName, min, max, returnExpr)
// long version
ES_FUNCTION(typeObject, functionName, min, max, {
  // ...
  return ...;
})
```
With this macro you can add functions directly to the type object. The parameters are similar to the constructor, but this time, you must also define the name of the function as a string. Example:
```cpp
EScript::Type* typeObject = E_MyType::getTypeObject();
//! Vec2 getXZ(Vec3) this function will extract the x and z value of the given Vec3
ES_FUNCTION(typeObject, "getXZ", 1, 1, {
  Vec3 vec = parameter[0].to<Vec3>(rt);
  return EScript::create( new Vec2(vec.x(), vec.z()) );
})
```
You could use this function from EScript like this:
```js
var value = MinSG.MyType.getXZ(new Geometry.Vec3(1,2,3));
outln(value); // Output: Vec2(1 3)
```

#### Member functions
```cpp
// short version
ES_MFUN(typeObject, targetType, functionName, min, max, returnExpr)
ES_MFUNCTION(typeObject, targetType, functionName, min, max, {
  // ...
  return ...;
})
```
A member function will have access to the underlying object. Therefore you have to specify the actual type of the *real* object. For the wrapper class `E_MyType` this will typically be just `MyType`.
In order to access the concrete object, you have to use the `thisObj` pointer. You can also use the wrapper instance with the `thisEObj` variable, which is an `EScript::ObjPtr`.
Example from the `E_Vec3` wrapper class:
```cpp
//! Number|thisObj Vec3.x([value])
ES_MFUNCTION(typeObject, Vec3, "x", 0, 1, {
  if(parameter.count() == 1){
    thisObj->setX(parameter[0].to<float>(rt));
    return thisEObj;
  } else {
    return thisObj->getX();
  }
})
```

### Conversion macros
The conversion macros are used to convert between the wrapper class and your actual class back and forth.
#### From a *wrapper* object to a *real* object
```cpp
ES_CONV_EOBJ_TO_OBJ(eSourceType, targetType, expr)
```
This will convert a `eSourceType*` to the type specified by `targetType` using the expression given by `expr`. The `eSourceType` will always be a wrapper class, without any modifiers, like `E_Geometry::E_Vec3`. And the `targetType` will often be a pointer or reference to your actual type, like `Geometry::Vec3*`. For small classes like `Vec2` and `Vec3` a conversion to the type without modifiers is also useful, but it should be avoided for larger classes. A variable called `eObj` is a pointer to your `eSourceType` and can be used for your conversion.

Example:
```cpp
// eObj is a pointer to an E_Geometry object, therefore we first dereference it:
// *eObj is now an E_Geometry object, which is a subclass of EScript::ReferenceObject.
// This class overrides the dereference operator, therefore **eObj will return the wrapped object.
ES_CONV_EOBJ_TO_OBJ(E_Geometry::E_Vec3, Geometry::Vec3&, **eObj)
```

#### From a *real* object to a *wrapper* object
```cpp
ES_CONV_OBJ_TO_EOBJ(sourceType, eTargetType, expr)
```
This will convert a `sourceType` to an `eTargetType*` by using the expression `expr`. The `sourceType` is your *real* object class with some optional modifiers, typically `*` or `&`. `eTargetType` is the name of your wrapper class without any modifiers. A variable called `obj` is available inside of your expression and it holds an object of the type given by `sourceType`.

Example:
```cpp
ES_CONV_OBJ_TO_EOBJ(const Geometry::Vec3&, E_Geometry::E_Vec3, new E_Geometry::E_Vec3(obj))
```

## Example: A simple 2D Bounding Box in C++ 
For now we only want to add a simple class called `BoundingBox2D`. Typically you would therefore add a header and a source file for this class, but because it is an extremly simple example, we just put everything in the header file. So we just create a file called `BoundingBox2D.h` inside of your source folder, e.g., `MyProject/src/BoundingBox2D.h`. This file will hold the actual logic of our simple bounding box:

<!---INCLUDE src=files/BoundingBox2D.h, start=14, end=81--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```cpp
// prevent multiple includes of this file
#ifndef MY_EXTENSION_BOUNDINGBOX2D_H_
#define MY_EXTENSION_BOUNDINGBOX2D_H_

#include <Geometry/Vec2.h>

// Never pollute the global namespace!
namespace MyProject {
// This class is just a very simple example.
// This basic bounding box is defined by two Geometry::Vec2's, describing the two extreme corners
class BoundingBox2D {
private:
    Geometry::Vec2 min;
    Geometry::Vec2 max;
public:
    // Define some useful constructors
    BoundingBox2D() : min(0.0, 0.0), max(0.0, 0.0) {}
    BoundingBox2D(const BoundingBox2D& other) : min(other.min), max(other.max) {}
    BoundingBox2D(const Geometry::Vec2& pmin, const Geometry::Vec2& pmax) : min(pmin), max(pmax) {}
    BoundingBox2D(float minX, float minY, float maxX, float maxY) : min(minX, minY), max(maxX, maxY) {}
    
    // Define some helper methods to get/set all values
    float getMinX() { return min.x(); }
    void setMinX(float v) { min.setX(v); }
    
    float getMinY() { return min.y(); }
    void setMinY(float v) { min.setY(v); }
    
    float getMaxX() { return max.x(); }
    void setMaxX(float v) { max.setX(v); }
    
    float getMaxY() { return max.y(); }
    void setMaxY(float v) { max.setY(v); }
    
    float getWidth() { return max.x() - min.x(); }
    float getHeight() { return max.y() - min.y(); }
    
    float getArea() { return getWidth() * getHeight(); }
    
    Geometry::Vec2 getMin() { return min; }
    void setMin(Geometry::Vec2 v) { min = v; }
    Geometry::Vec2 getMax() { return max; }
    void setMax(Geometry::Vec2 v) { max = v; }
    
    Geometry::Vec2 getCenter() { return (min + max) * 0.5f; }
    
    // Define some additional features
    bool contains(Geometry::Vec2 v) {
        float x = v.x(), y = v.y();
        return x >= min.x() && x <= max.x() && y >= min.y() && y <= max.y();
    }
    
    bool intersects(BoundingBox2D* other) {
        return std::abs(getMinX() - other->getMinX()) < (getWidth() + other->getWidth()) / 2
            && std::abs(getMinY() - other->getMinY()) < (getHeight() + other->getHeight()) / 2;
    }
    
    // (In)equality operators
    inline bool operator==(const BoundingBox2D& other) {
        return min == other.min && max == other.max;
    }
    
    inline bool operator!=(const BoundingBox2D& other) {
        return min != other.min || max != other.max;
    }
};
}
#endif
```
<!---END_CODESECTION--->

As you can see, nothing fancy here. Just a plain, simple class. In order to make it accessible from EScript, we now have to create a corresponding wrapper class.

## Creating EScript bindings
Next we add the following two files to our source folder folder:
* `E_BoundingBox2D.h`
* `E_BoundingBox2D.cpp`

The header file is always very similar. You provide a type name, a constructor and a destructor. Furthermore you declare the `getTypeObject` and `init` functions, which will be implemented in the source file.

<!---INCLUDE src=files/E_BoundingBox2D.h, start=14, end=53--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```cpp
// As for all header files, we should prevent multiple includes:
#ifndef E_MY_EXTENSION_BOUNDINGBOX2D_H_
#define E_MY_EXTENSION_BOUNDINGBOX2D_H_

// Include some useful EScript stuff
#include <EScript/EScript.h>
#include <EScript/Objects/ReferenceObject.h>

// include your real class
#include "BoundingBox2D.h"

namespace MyProject {
/*! A binding class must inherit from EScript::ReferenceObject<T> where T is your actual class. 
 * If your class gets more complex, it might be better to use EScript::ReferenceObject<Util::Reference<BoundingBox2D>> (more on that in the bigger example)
 */
class E_BoundingBox2D : public EScript::ReferenceObject<MyProject::BoundingBox2D> {
    //! The human readable name of this type
    ES_PROVIDES_TYPE_NAME(BoundingBox2D)
public:
    //! returns the Type object for this type
    static EScript::Type * getTypeObject();
    //! this function is used to initialize this type, should be called from the ELibMinSGExt.cpp file
    static void init(EScript::Namespace & lib);
    
    //! most simple constructor, just forward all arguments. This will initialize an instance of your class with that parameters.
    template<typename...args> explicit E_BoundingBox2D(args&&... params) : ReferenceObject_t(E_BoundingBox2D::getTypeObject(),std::forward<args>(params)...) {}
    //! destructor
    virtual ~E_BoundingBox2D() {}
};
}

//! All conversions must be in the public namespace!
//! Convert an EScript object to the real object, typically you just dereference it.
ES_CONV_EOBJ_TO_OBJ(MyProject::E_BoundingBox2D, MyProject::BoundingBox2D&, **eObj)
ES_CONV_EOBJ_TO_OBJ(MyProject::E_BoundingBox2D, MyProject::BoundingBox2D*, &**eObj)
//! Convert real classes to EScript binding class. typically you just create a new instance.
ES_CONV_OBJ_TO_EOBJ(MyProject::BoundingBox2D&, MyProject::E_BoundingBox2D, new MyProject::E_BoundingBox2D(obj))
ES_CONV_OBJ_TO_EOBJ(MyProject::BoundingBox2D*, MyProject::E_BoundingBox2D, new MyProject::E_BoundingBox2D(*obj))

#endif
```
<!---END_CODESECTION--->

A very important part of the header file can be found at the end: The conversion macros.
Those macros are used to convert between an EScript object and the real object back and forth.

The source file of this header will now look like this:

<!---INCLUDE src=files/E_BoundingBox2D.cpp, start=14, end=97--->
<!---BEGINN_CODESECTION--->
<!---Automaticly generated section. Do not edit!!!--->
```cpp
#include "E_BoundingBox2D.h"
#include <E_Geometry/E_Vec2.h>

namespace MyProject {
//! returns an instance to an EScript::Type
EScript::Type * E_BoundingBox2D::getTypeObject() {
    // you want to have this static in order to return always the same instance
    // E_BoundingBox2D ---|> Object
    static EScript::ERef<EScript::Type> typeObject = new EScript::Type(EScript::Object::getTypeObject());
    return typeObject.get();
}

//! initMembers
void E_BoundingBox2D::init(EScript::Namespace& lib) {
    EScript::Type* typeObject = getTypeObject();
    // first define the class type in EScript
    declareConstant(&lib, getClassName(), typeObject);
    
    // now you should define all functions for your new type
    // this is done by several macros
    //! BoundingBox2D new BoundingBox2D([otherBB | min2D, max2D | minX, minY, maxX, maxY])
    ES_CONSTRUCTOR(typeObject, 0, 4,{ // typeObject, minimal parameter count, maximal parameter count, function body
        // Depending on the parameter count, we want to use an other constructor
        // Here we can return a new BoundingBox2D, because the corresponding macro can convert it to an E_BoundingBox2D
        // Of course we could also return a new E_BoundingBox2D directly
        switch(parameter.count()) {
            // parameterless constructor: BoundingBox2D()
            case 0: return EScript::create(new BoundingBox2D());
            // as already mentioned we could also do this:
            // case 0: return new E_BoundingBox2D();
            
            // Copy constructor: BoundingBox2(BoundingBox2D otherBB)
            case 1: return EScript::create(new BoundingBox2D( parameter[0].to<BoundingBox2D&>(rt) ));
            // Constructor using the extreme points: BoundingBox2D(Vec2 min, Vec2 max)
            case 2: return EScript::create(new BoundingBox2D( parameter[0].to<Geometry::Vec2&>(rt), parameter[1].to<Geometry::Vec2&>(rt) ));
            // float constructor: BoundingBox2D(float minX, float minY, float maxX, float maxY)
            case 4: return EScript::create(new BoundingBox2D( parameter[0].toFloat(), parameter[1].toFloat(), parameter[2].toFloat(), parameter[3].toFloat() ));
            // Something went wrong!
            default:
                rt.warn("new BoundingBox2D(): Wrong parameter count!");
                return EScript::create(new BoundingBox2D());
        }
    })
    
    // short version of the macro, the function body will be converted to this: return EScript::value( thisObj->getMinX() );
    ES_MFUN(typeObject, BoundingBox2D, "getMinX", 0, 0, thisObj->getMinX())
    /* This could be also written in a long version:
    ES_MFUNCTION(typeObject, BoundingBox2D, "getMinX", 0, 0, {
        return thisObj->getMinX();
    })
    */
    ES_MFUN(typeObject, BoundingBox2D, "setMinX", 1, 1, (thisObj->setMinX(parameter[0].toFloat()), thisEObj) )
    /* This could be also written in a long version:
    ES_MFUNCTION(typeObject, BoundingBox2D, "setMinX", 1, 1, {
        thisObj->setMinX(parameter[0].toFloat());
        return thisObj;
    })
    */
    ES_MFUN(typeObject, BoundingBox2D, "getMinY", 0, 0, thisObj->getMinY())
    //ES_MFUN(typeObject, BoundingBox2D, "setMinY", 1, 1, (thisObj->setMinY(parameter[0].toFloat()), thisEObj) )
    ES_MFUNCTION(typeObject, BoundingBox2D, "setMinY", 1, 1, {
        return EScript::value((thisObj->setMinY(parameter[0].toFloat()), thisEObj));
    })
    
    ES_MFUN(typeObject, BoundingBox2D, "getMaxX", 0, 0, thisObj->getMaxX())
    ES_MFUN(typeObject, BoundingBox2D, "setMaxX", 1, 1, (thisObj->setMaxX(parameter[0].toFloat()), thisEObj) )
    ES_MFUN(typeObject, BoundingBox2D, "getMaxY", 0, 0, thisObj->getMaxY())
    ES_MFUN(typeObject, BoundingBox2D, "setMaxY", 1, 1, (thisObj->setMaxY(parameter[0].toFloat()), thisEObj) )
    
    ES_MFUN(typeObject, BoundingBox2D, "getWidth", 0, 0, thisObj->getWidth())
    ES_MFUN(typeObject, BoundingBox2D, "getHeight", 0, 0, thisObj->getHeight())
    ES_MFUN(typeObject, BoundingBox2D, "getArea", 0, 0, thisObj->getArea())
    
    ES_MFUN(typeObject, BoundingBox2D, "getMin", 0, 0, EScript::create(thisObj->getMin()))
    ES_MFUN(typeObject, BoundingBox2D, "setMin", 1, 1, (thisObj->setMin(parameter[0].to<Geometry::Vec2>(rt)), thisEObj) )
    ES_MFUN(typeObject, BoundingBox2D, "getMax", 0, 0, EScript::create(thisObj->getMax()))
    ES_MFUN(typeObject, BoundingBox2D, "setMax", 1, 1, (thisObj->setMin(parameter[0].to<Geometry::Vec2>(rt)), thisEObj) )
    ES_MFUN(typeObject, BoundingBox2D, "getCenter", 0, 0, EScript::create(thisObj->getCenter()))
    
    ES_MFUN(typeObject, BoundingBox2D, "contains", 1, 1, thisObj->contains(parameter[0].to<Geometry::Vec2>(rt)))
    ES_MFUN(typeObject, BoundingBox2D, "intersects", 1, 1, thisObj->intersects(parameter[0].to<BoundingBox2D*>(rt)))
}

}
```
<!---END_CODESECTION--->

It only consists of two functions, the `getTypeObject` and `init` functions.

### getTypeObject
First of all you will always implement the `getTypeObject` function. This function must always return the same EScript type object instance. Therefore you typically just declare it statically. All functions will be later on added to this type object.

### init
Next you implement the init function, which is used to actually add all wrapper functions to the type object. Therefore you first get the type object by calling `getTypeObject`. Then you have to declare your class as a constant inside of the namespace, otherwise your type object won't be usable. Then you just continue with adding all kind of functions to your type object.

## Overall initialization
Each init function of your wrapper classes must be called from your EScript library initialization function. This is done by modifying your `src/ELibMyProject.cpp` file. This file should include all wrapper classes and call their corresponding init functions.

The init function will get your EScript namespace as the parameter. Afterwards you will initialize all of your wrapper classes, by just calling their init functions, with your own namespace as a parameter.
```cpp
// ...
#include "E_BoundingBox2D.h"

// ...

// Initializes your EScript bindings
void init(EScript::Namespace * lib) {
  // initialize EScript objects	
  E_BoundingBox2D::init(*lib);
  // ...
}
```

The only thing that remains, is to add your new source files to your CMakeLists.txt and compile your library.
```cmake
# ...
# Add your sources here
add_library(${PROJECT_NAME} SHARED 
  src/Main.cpp # The main entry point for the EScript library loader
  src/ELibMyProject.cpp # Initialize your EScript bindings here
  src/E_BoundingBox2D.cpp
)
# ...
```

After loading your plugin library in EScript, you should be able to create a new 2D Bounding Box in your EScript plugin.

```js
// ...
var bb = new ExampleProject.BoundingBox2D(0,0,2,4);
outln("2D BB Area: ", bb.getArea());
// ...
```


