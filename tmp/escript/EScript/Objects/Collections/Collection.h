// Collection.h
// This file is part of the EScript programming language (https://github.com/EScript)
//
// Copyright (C) 2011-2013 Claudius Jähn <ClaudiusJ@live.de>
// Copyright (C) 2012-2013 Benjamin Eikel <benjamin@eikel.org>
//
// Licensed under the MIT License. See LICENSE file for details.
// ---------------------------------------------------------------------------------
#ifndef COLLECTION_H
#define COLLECTION_H

#include "../Type.h"
#include "../../Utils/ObjArray.h"

namespace EScript {
class Iterator;

//! (abstract) [Collection] ---|>  Object]
class Collection : public Object {
		ES_PROVIDES_TYPE_NAME(Collection)
	public:
		static Type* getTypeObject();
		static void init(Namespace & globals);
		// ---
		Collection(Type * type = nullptr) : Object(type?type:getTypeObject()) { }
		virtual ~Collection()	{ }

		//! ---o
		virtual Object * getValue(ObjPtr key);
		//! ---o
		virtual void setValue(ObjPtr key,ObjPtr value);
		//! ---o
		virtual void clear();
		//! ---o
		virtual size_t count()const;
		//! ---o
		virtual Iterator * getIterator();

		//! ---o
		virtual Object * rt_findValue(Runtime & runtime,ObjPtr value);
		virtual bool rt_contains(Runtime & runtime,ObjPtr value);
		virtual Object * rt_reduce(Runtime & runtime,ObjPtr function,ObjPtr initialValue, const ParameterValues & additionalValues);
		virtual Object * rt_map(Runtime & runtime,ObjPtr function, const ParameterValues & additionalValues);
		virtual Object * rt_extract(Runtime & runtime,StringId functionId,bool decision = true);


		//! ---|> Object
		bool rt_isEqual(Runtime &runtime,const ObjPtr & other) override;
};
}

#endif // COLLECTION_H
