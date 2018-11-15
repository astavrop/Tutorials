// JSONDataStore.escript
// This file is part of the EScript programming language (https://github.com/EScript)
//
// Copyright (C) 2013-2014 Claudius Jähn <ClaudiusJ@live.de>
//
// Licensed under the MIT License. See LICENSE file for details.
// ---------------------------------------------------------------------------------
/**
 ** Configuration management for storing JSON-formatted data.
 **/
var T = new Type;

T._printableName @(override) ::= $JSONDataStore;

T.data @(private,init) := Map;
T.filename @(private) := "";
T.autoSave @(private) := void;

//! (ctor)
T._constructor ::= fn(Bool _autoSave = false){
	this.autoSave = _autoSave;
};

T.clear ::= fn(){
	this.data.clear();
	if(autoSave)
		this.save();
};

T.getFilename ::= fn(){
	return this.filename;
};

/*!	Get a config-value.
	If the value is not set, the default value is returned and memorized.	*/
T.get ::= fn( String key, defaultValue = void){
	var fullKey = key.toString();
	var group = this.data;

	// Key is subgroup key
	if(key.contains(".")){
		var groupNames = key.split(".");
		key = groupNames.popBack();
		foreach(groupNames as var groupName){
			var newGroup = group[groupName];
			if(! (newGroup---|>Map) ){
				if( void!==defaultValue )
					this.set(fullKey,defaultValue);
				return defaultValue;
			}
			group = newGroup;
		}
	}

	var value = parseJSON(toJSON(group[key])); // deep copy
	if(void===value){
		if(void!==defaultValue)
			this.set(fullKey,defaultValue);
		return defaultValue;
	}
	return value;
};

/*! Load a json-formatted config file and store the filename.
	\return true on success */
T.init ::= fn(String filename, warnOnFailure = true ){
	this.filename = filename;
	try{
		var s = IO.loadTextFile(filename);
		var c = parseJSON(s);
		if(c---|>Map){
			this.data = c;
		}
		else{
			this.data = new Map;
		}
	}catch(e){
		if(warnOnFailure)
			Runtime.warn("Could not load config-file("+filename+"): "+e);
		return false;
	}
	return true;
};

//! Save configuration to file.
T.save ::= fn(_filename = void){
	if(!_filename)
		_filename = this.filename;
	if(_filename){
		var s = toJSON(this.data);
		if(s.length()>0){
			IO.saveTextFile(_filename,s);
		}
	}
};

//! Set a short info-string for a config entry
T.setInfo ::= fn(key, value){
	this.set(key+" (INFO)",value);
};


/*! Store a copy of the value with the given key.
	If the key contains dots (.), the left side is interpreted as a subgroup.
	If the value is void, the entry is removed.
	\example
		set( "Foo.bar.a1" , 2 );
		---> { "Foo" : { "bar : { "a1" : 2 } } }
	\note if autoSave is true, the config file is saved immediately
	*/
T.set ::= fn(String key, value){
	if(void===value){
		unset(key);
		return;
	}
	var group = this.data;
	if(key.contains(".")){
		var groupNames = key.split(".");
		key = groupNames.popBack();
		foreach(groupNames as var groupName){
			var newGroup = group[groupName];
			if(! (newGroup---|>Map) ){
				newGroup = new Map;
				group[groupName] = newGroup;
			}
			group = newGroup;
		}
	}
	var newJSON = toJSON(value);
	if(toJSON(group[key]) != newJSON){ // data changed?
		group[key]=parseJSON(newJSON);// deep clone
		if(autoSave)
			this.save();
	}
};

T.unset ::= fn(String key){
	var group = this.data;

	// Key is subgroup key
	var groupNames = key.split(".");
	key = groupNames.popBack();
	foreach(groupNames as var groupName){
		group = group[groupName];
		if(! (group---|>Map) )
			return;
	}

	group.unset(key);
	if(autoSave)
		this.save();
};


T._get ::= T.get;
T._set ::= fn(key,value){
	this.set(key,value);
	return value;
};

module.on('./StdNamespace', [T] => fn(T,StdNamespace){
	StdNamespace.JSONDataStore := T;
});

return T;
