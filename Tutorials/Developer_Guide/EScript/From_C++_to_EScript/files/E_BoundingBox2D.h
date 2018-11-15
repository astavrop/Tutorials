/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2016 Henrik Heine <hheine@mail.uni-paderborn.de>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

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
