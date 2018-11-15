/*
	This file is part of the Rendering library.
	Copyright (C) 2012 Benjamin Eikel <benjamin@eikel.org>
	
	This library is subject to the terms of the Mozilla Public License, v. 2.0.
	You should have received a copy of the MPL along with this library; see the 
	file LICENSE. If not, you can obtain one at http://mozilla.org/MPL/2.0/.
*/
#ifndef RENDERING_STREAMERXYZ_H_
#define RENDERING_STREAMERXYZ_H_

#include "AbstractRenderingStreamer.h"
#include <vector>
namespace Util{
class FileName;
}

namespace Rendering {

class StreamerXYZ : public AbstractRenderingStreamer {
	public:
		StreamerXYZ() :
			AbstractRenderingStreamer() {
		}
		virtual ~StreamerXYZ() {
		}

		Mesh * loadMesh(std::istream & input) override {
			return loadMesh(input, 0);
		}
		Mesh * loadMesh(std::istream & input, std::size_t numPoints);
		Util::GenericAttributeList * loadGeneric(std::istream & input) override;
		
		
		/*! Distributes the points in the given xyz-input file into @p numberOfClusters many .xyz-files
			in the same directory (having a number postfix).
			This function should handle files of arbitrary size.	*/		
		static void clusterPoints( const Util::FileName & inputFile, size_t numberOfClusters );
		static void clusterPoints( std::istream & input, std::vector<std::ostream*> & outputs );

		static uint8_t queryCapabilities(const std::string & extension);
		static const char * const fileExtension;
};

}

#endif /* RENDERING_STREAMERXYZ_H_ */
