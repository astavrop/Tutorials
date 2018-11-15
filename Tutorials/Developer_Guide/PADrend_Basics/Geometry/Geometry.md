---
author: Henrik Heine
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 2
permalink: geometry
subcategory: PADrend Basics
title: Geometry
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


# Geometry
This library contains several geometric objects, data structures and calculations. The most common types are the different vector and matrix classes.

## Vector types
These are described in their own file: [Vectors.md](Vectors.md)

## Matrix types
These are described in their own file: [Matrices.md](Matrices.md)

## SRT
The SRT (Scale, Rotate, Translate) object is used to describe transformations. Such transformations could be described by a `Matrix4x4`, but it is easier to handle them via SRT objects. If you look at any matrix, it is typically not easy to determine the rotation of such a matrix. Therefore SRT obejcts basically store the scale, rotation and translation separately, which makes it much easier to query those values.

### Constructor
The constructor accepts several different sets of parameters:
* no parameter: Creates an identity instance
* `SRT`: Copy constructor
* `Vec3 position, Vec3 direction, Vec3 up, Number scale=1.0`: Creates a new SRT based on the given values
* `SRT a, SRT b, Number blend`: Creates an interpolation between the given SRT's
* `Array`: Initializes all values based on an array of the form: `[tX, tY, tZ, qX, qY, qZ, qW, scale]` The `t`-values are used for the translation and the `q`-values are used to create a quaternion.

The following functions are supported. If not stated otherwise, the return value is the instance itself.
* `Vec3 applyRotation(Vec3)`: Rotates the given vector and returns the result
* `Vec3 getDirVector()`: Returns the direction of this instance
* `Matrix3x3 getRotation()`: Returns the rotation matix represented by this instance
* `Vec3 getTranslation()`: Returns the translation of this instance
* `Vec3 getUpVector()`: Returns the up vector
* `Number getScale()`: Returns the scale
* `SRT inverse()`: Returns an inversed copy of this instance
* `SRT resetRotation()`: Resets the rotation
* `SRT rotateLocal_deg(Number degrees, Vec3 axis)`: Rotates localy around the given axis
* `SRT rotateLocal_rad(Number radians, Vec3 axis)`: Rotates localy around the given axis
* `SRT rotateRel_deg(Number degrees, Vec3 axis)`: Rotates around the given axis
* `SRT rotateRel_rad(Number radians, Vec3 axis)`: Rotates around the given axis
* `SRT scale(Number)`: Scales this instance
* `SRT setRotation(Vec3 dir, Vec3 up | Quaternion | Matrix3x3)`: Sets the rotation
* `SRT setScale(Number)`: Sets the scale
* `SRT setTranslation(Vec3)`: Sets the translation
* `SRT setValue(...)`: Same parameters as in the constructor
* `Array toArray()`: Returns an array containing all components:  `[tX, tY, tZ, qX, qY, qZ, qW, scale]`, where the `t`-values are used for the translation and the `q`-values are describing the rotation
* `SRT translate(Vec3)`: translates this instance
* `SRT translateLocal(Vec3)`: translates this instance locally
* `Vec3|SRT mul(Vec3 | SRT)`: Returns the result of the multiplication of this instance with the given parameter


## Quaternion
A quaternion is a four dimensional vector, which is often used to efficiently describe the rotation of an object. It consists of the four components: `x`, `y`, `z` and `w`
They can be accessed via `get` and `set` methods, like:
* `Number getX()`
* `Quaternion setX(Number value)`

The following operators are supported:

| Operator | Type of other operand | Description |
| ----- | ----- | ----- |
| * | Number | Component wise multiplication |
| / | Number | Component wise division |
| *= | Number | Component wise multiplication, without creating a new instance |
| /= | Number | Component wise division, without creating a new instance |

The quaternion type defines the following functions. If not stated otherwise, each function returns the `this` object.
* `Quaternion makeRotate(Number degrees, Vec3 axis | degrees,x,y,z)`: Rotates this instance around the given axis
* `Quaternion inverse()`: Returns the inverse of this quaternion
* `Quaternion conjugate()`: Returns a new quaternion, which is the conjugated form of this instance
* `Number dot(Quaternion)`: Calculates the dor product
* `Array toArray()`: Returns an array of all components
* `Matrix3x3 toMatrix()`: Returns a matrix describing this rotation
* `static Quaternion lerp(Quaternion a, Quaternion b, Number blend)`: Returns the linear interpolation between the two quaternions
* `static Quaternion slerp(Quaternion a, Quaternion b, Number blend)`: Returns the spherical linear interpolation between the two quaternions
* `static Quaternion matrixToQuaternion(Matrix3x3)`: Creates a quaternion from the given matrix
* `Number length()`: Returns the euclidean length of this quaternion
* `Quaternion normalize()`: Normalizes this instance
* `Vec3 toEuler()`: Returns the rotation in euler angles
* `static Quaternion eulerToQuaternion(Vec3)`: Creates a quaternion from euler angles


