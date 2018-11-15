---
author: Henrik Heine
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 3
permalink: matrices
subcategory: PADrend Basics
title: Matrices
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


## Matrix types
The geometry library suppots 3*3 and 4*4 matrices (`Matrix3x3` and `Matrix4x4`).
In contrast to the vector types, these two classes differ heavily, therefore they are completely described separately.

### Matrix3x3
If the constructor is invoked without any parameters, the matrix is initialized to be an identity matrix. The constructor can also receive another `Matrix3x3` instance or an `Array`. In the former case the new matrix is a copy of the given one and in the later case, all components are initialized with the values inside of the array. Furthermore the constructor can be called with two `Matrix3x3` instances and a number. The number should be in the range [0, 1] and it is used to interpolate between the two given matrices.

The following operators are supported:

| Operator | Type of other operand | Description |
| ----- |----- | ----- |
| + | Matrix3x3 | Component wise addition |
| - | Matrix3x3 | Component wise subtraction |
| * | Matrix3x3<br>Number<br>Vec3 | Matrix multiplication<br>Component wise multiplication<br>Matrix-Vector multiplication (result is Vec3) |

The functions provided by the `Matrix3x3` type are described in the following list:
* `Number at(row, column)`: Returns the value of the specified component
* `static Matrix3x3 createRotation(Number deg, Vec3 axis)`: Returns a rotation matrix, which describes a rotation of `deg` many degrees around the given axis
* `Number det()`: Returns the determinant of this matrix
* `Vec3 getCol(Number column)`: Return the specified column
* `Vec3 getRow(Number row)`: Returns the specified row
* `Matrix3x3 getInverse()`: Returns the inverse of this matrix
* `Matrix3x3 getTransposed()`: Returns a transposed copy of this matrix
* `Matrix3x3 rotateLocal_deg(Number degrees, Vec3 axis)`: Rotates this matrix around the given axis and returns itself
* `Matrix3x3 rotateLocal_rad(Number radians, Vec3 axis)`: Rotates this matrix around the given axis and returns itself
* `Matrix3x3 set(Matrix3x3 | row,column,value | v0,...,v8)`: Sets one or more values of this matrix
* `Matrix3x3 setIdentity()`: Sets this matrix to an identity matrix and returns itself
* `Matrix3x3 setRotation(Vec3 direction, Vec3 up)`: Sets this matrix to the given rotation
* `Array toArray()`: Returns an array of all components

### Matrix4x4
If the constructor is invoked without any parameters, the matrix is initialized to be an identity matrix. The constructor can also receive another `Matrix4x4` instance or an `Array`. In the former case the new matrix is a copy of the given one and in the later case, all components are initialized with the values inside of the array. Furthermore the constructor can be called with an `SRT` instance, from which this matrix is then created.

The only supported operator is the multiplication operator, which can be used in conjunction with a Vec3, Vec4, Matrix4x4, SRT and a Number.

The functions provided by the `Matrix4x4` type are described in the following list. If not stated otherwise, each function will return the `this` object.
* `Matrix4x4 inverse()`: Returns the inverse of this matrix
* `Matrix4x4 getTransposed()`: Returns a transposed copy of this matrix
* `Matrix4x4 lookAt(Vec3 pos, Vec3 target, Vec3 up)`: Creates a viewing transformation, see [gluLookAt](https://www.opengl.org/sdk/docs/man2/xhtml/gluLookAt.xml)
* `Matrix4x4 rotate(Number degrees, Number x, Number y, Number z)`: Rotates this matrix
* `Matrix4x4 rotate_deg(Number degrees, x,y,z | Vec3)`: Rotates this matrix
* `Matrix4x4 rotate_rad(Number radians, x,y,z | Vec3)`: Rotates this matrix
* `Matrix4x4 scale(Number x, Number y, Number z)`: Scales this matrix
* `Matrix4x4 setIdentity()`: Sets this matrix to identity
* `Vec3 transformDirection(Vec3 | x,y,z)`: Transforms the given direction vector
* `Vec3 transformPosition(Vec3 | x,y,z)`: Transforms the given position vector
* `Array toArray()`: Returns an array of all components
* `Bool convertsSafelyToSRT()`: Can be used to check whether it is (relatively) safe to convert a matrix to an SRT without loss of information
* `SRT toSRT()`: creates a SRT instance from this matrix
* `Matrix4x4 translate(Vec3 | x,y,z)`: Translates this matrix by the given vector


