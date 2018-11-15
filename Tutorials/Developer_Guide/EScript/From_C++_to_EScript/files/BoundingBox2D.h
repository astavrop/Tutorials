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
