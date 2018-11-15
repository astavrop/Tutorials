---
author: Henrik Heine
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 1
permalink: geometricobjects
subcategory: PADrend Basics
title: GeometricObjects
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# Geometric Objects
The Geometry library already provides us with many different geometric objects, which are described in this chapter. If not stated otherwise a method that returns an object of the same type, returns the `this` object.

## Box
This type basically represents a simple cuboid. A new box can be constructed by using one of the following sets of parameters:
* `new Box()`: Empty box at (0,0,0)
* `new Box(Box other)`: Copy constructor
* `new Box(Vec3 center, Number width, Number height, Number depth)`
* `new Box(Number x, Number y, Number z, Number width, Number height, Number depth)`

Of course it is possible to get and set the minimum/maximum values of each dimension, like `getMinX()` or `setMinX(42)`. Furthermore you can query the side length of each dimension via `getExtentX/Y/Z`. `getExtentMax()` returns the largest extent of the box. Of course you can also query each single corner point of the box. This is done calling `getCorner(Number index)` with a number in the range [0, 7].
Other important methods of this type are listed below:

* `Number getBoundingSphereRadius()`: Returns the radius of the bounding sphere
* `Number getDistance(Vec3 pos)`: Returns the distance between the given point and the closest point on the box
* `Number getDistanceSquared(pos)`: Returns the squared distance
* `Box getIntersection(Box other)`: Returns a new box, which is the intersection between `this` object and the given box
* `Number getVolume()`: Returns the volume of the box
* `Box include(Box|Vec3 other)`: Increases the size of this box, such that it fully contains the given parameter. This methods returns the `this` object
* `Bool intersects(Box other)`: Whether this box intersects the other one
* `Array splitUp(Number partsX, Number partsY, Number partsZ)`: Subdivides this box into several smaller ones and returns them as an array


## Line3
Represents an infinite line, which is internally described by an origin and a direction. It can be constructed with the following sets of parameters:
* `new Line3()`
* `new Line3(Line3 other)`
* `new Line3(Vec3 origin, Vec3 direction)`

Of course it is possible to get/set the origin and direction by their corresponding getter and setter methods. Other important methods are listed below

* `Number distance(Vec3 pos)`: Returns the distance between the point and the closest point on the line
* `Vec3 getClosestPoint(Vec3 pos)`: Returns the closest point on the line
* `Line3 normalize()`: Normalizes this object and returns it


## Segment3
This type represents a3D line segment, which has a start and end point. You can use the following constructor calls:
* `new Segment3()`
* `new Segment3(Segment3 other)`
* `new Segment3(Vec3 a, Vec3 b)`

You can modify the first and second point with their corresponding gettter/setter methods, like `getFirstPoint()`.
The following methods are also provided:

* `Number distance(Vec3 pos)`
* `Vec3 getDirection()`: Returns the direction from the first point to the second point
* `Vec3 getClosestPoint(Vec3 pos)`
* `Number length()`: Returns the length of this segment


## Plane
An infinite plane defined by its normal and the offset from (0, 0, 0). It can be constructed by using one the following parameter sets:
* `new Plane()`: creates an undefined plane
* `new Plane(Vec3 normal, Number offset)`
* `new Plane(Vec3 pos, Vec3 normal)`
* `new Plane(Vec3 a, Vec3 b, Vec3 c)`: Constructs a plane from three points

Normal and position can be get/set with their corresponding methods, like `getNormal()`.

* `Bool isUndefined()`
* `Vec3 getProjection(Vec3 point)`: Projects the point onto the plane
* `Number planeTest(Vec3 point)`: Returns the signed distance of the given point to the plane. Returns a value smaller than zero if the point is below the plane, a value greater than zero if it is above zero and exactly zero if it is directly on the plane.


## Rect
Constructor:
* `new Rect()`
* `new Rect(Rect other)`
* `new Rect(Number x, Number y, Number width, Number height)`

Minimum and maximum values can get/set with their corresponding methods, like `getMinX()`. The same holds for the width and height. They can be also retrieved via functions like `x()`/`x(newValue)` Other methods are:
* `Number getX()` same as `getMinX()` (analog for y)
* `Rect setX(Number value)` same as `setMinX(value)` (analog for y)
* `Vec2 getCenter()`
* `Bool intersects(Rect other)`: Whether this rect intersects the other one
* `Bool contains(x,y | Vec2 | Rect)`: Whether this rectangle fully contains the given coordinate/rectangle
* `Rect setPosition(x,y | Vec2)`: Simply sets the x and y value
* `Rect setSize(w,h)`: Simply sets width and height
* `Rect moveRel(x,y | Vec2)`: Increases the position of thiss rectangle by the given values
* `Rect include(x,y | Vec2)`: Increases the size of this rectangle such that it contains the given parameter

Operators:
* `+= Vec2` basically syntactic sugar for `moveRel(vec2)`
* `-= Vec2` basically syntactic sugar for `moveRel(-vec2)`
* `- Vec2` Create rect by moving this by a given vector
* `+ Vec2` Create rect by moving this by a given vector


