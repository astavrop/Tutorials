/*
	This file is part of the Util library.
	Copyright (C) 2007-2014 Claudius Jähn <claudius@uni-paderborn.de>
	
	This library is subject to the terms of the Mozilla Public License, v. 2.0.
	You should have received a copy of the MPL along with this library; see the 
	file LICENSE. If not, you can obtain one at http://mozilla.org/MPL/2.0/.
*/
#include "FileLocator.h"
#include "FileUtils.h"
#include "../StringUtils.h"

namespace Util {


std::pair<bool,FileName> FileLocator::locateFile(const FileName& relFile)const{
	if(FileUtils::isFile(relFile))
		return std::make_pair(true,relFile);
		
	FileName foundPath;
	if(	FileUtils::findFile(relFile,searchPaths,foundPath) )
		return std::make_pair(true,foundPath);

	return std::make_pair(false,relFile);
}


}
