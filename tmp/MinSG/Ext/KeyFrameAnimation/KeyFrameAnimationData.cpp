/*
	This file is part of the MinSG library extension KeyFrameAnimation.
	Copyright (C) 2010-2012 Benjamin Eikel <benjamin@eikel.org>
	Copyright (C) 2010-2012 Claudius Jähn <claudius@uni-paderborn.de>
	Copyright (C) 2010 David Maicher
	Copyright (C) 2010-2012 Ralf Petring <ralf@petring.net>
	
	This library is subject to the terms of the Mozilla Public License, v. 2.0.
	You should have received a copy of the MPL along with this library; see the 
	file LICENSE. If not, you can obtain one at http://mozilla.org/MPL/2.0/.
*/
#include "KeyFrameAnimationData.h"
#include <Rendering/Mesh/Mesh.h>
#include <Util/Macros.h>

namespace MinSG {

KeyFrameAnimationData::KeyFrameAnimationData(Rendering::MeshIndexData _indexData, std::vector<Rendering::MeshVertexData>  _framesData,
		std::map<std::string, std::vector<int> > _animationData) : 
	indexData(std::move(_indexData)), framesData(std::move(_framesData)), animationData(std::move(_animationData)) {
}

KeyFrameAnimationData * KeyFrameAnimationData::clone() const {
	return new KeyFrameAnimationData(indexData, framesData, animationData);
}

}
