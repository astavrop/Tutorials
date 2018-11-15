---
author: Henrik Heine
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 4
permalink: vectors
subcategory: PADrend Basics
title: Vectors
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->


## Vector types
The geometry libary contains 2-, 3- and 4-dimensional vectors. They share many functions and therefore they are described only once in this section and not for each vector separately. The type `VecX` refers to the corresponding vector type (`Vec2`, `Vec3` or `Vec4`). The components are named `x`, `y`, `z` and `w`. So a `Vec2` only has x and y components, while a `Vec4` has all components. Each component can be accessed via `get` and `set` methods, like `getX()` or `setX(42)`. Each setter returns the `this` object for chaining, so you could write `myVector.setX(10).setY(20)` in order to set two components. Furthermore each component can be accessed in a `DataWrapper` like fashion. For example the `x` function has one optional parameter. If no parameter is given, it will behave like `getX`, but if the parameter is given, it behaves like `setX`.

### Operators
Many operators are defined for each vector type. Each of them supports the unary minus, which will just negate each component of the vector.
The following binary operators are supported:

| Operator | Type of other operand | Description |
| ----- | ----- | ----- |
| + | VecX | Component wise addition |
| - | VecX | Component wise subtraction |
| * | Number | Multiplication of each component with the given number |
| / | Number | Division of each component by the given number |

`+=`, `-=`, `*=` and `/=` are also supported, but they modify the `this` object instead of returning a new instance.

### Functions
The signature of the functions and their description is summarized by the following list:
* `Number dot(VecX other)`: calculates the dot product
* `Number length()`: Returns the euclidean length of the vector
* `VecX getNormalized()`: Returns a normalized copy the vector
* `VecX normalize()`: Normalizes the vector und returns itself
* `Bool isZero()`: Whether all components are zero or not
* `Array toArray()`: Returns an array containing all components

### Constructors
All constructors are able to receive different sets of parameters. Of course each one can be created without any parameters, which will just initialize all components with zero. Each vector constructor is also able to receive one number for each component, like `new Vec2(x, y)` or `new Vec4(x, y, z, w)`. Furthermore they support a copy constructor, like `new Vec2(otherVec2)`. Additionally you can create a vector by providing an array of components, like `new Vec2([0, 1])`. The `Vec4` type allows one additional set of parameters: `new Vec4(Vec3 v, Number w)`

### Vec2
The following functions are special for the `Vec2` type.
* `Number distance(Vec2 other)`: Returns the euclidean distance between the two vectors
* `Vec2 setValue(Number x, Number y | Array | Vec2)`: Sets the values of each component and returns itself

### Vec3
The following functions are special for the `Vec3` type.
* `Number distance(Vec3 other)`: Returns the euclidean distance between the two vectors
* `Number distanceSquared(Vec3 other)`: Returns the square of the euclidean distance between the two vectors
* `Vec3 getProjection(Vec3 planeBase, Vec3 planeNormal)`: Returns the projection of this point onto the given plane
* `Number lengthSquared()`: Returns the squared length of this vector
* `Number maxAbsValue()`: The maximum absolute value of the components of this vector
* `Vec3 reflect(Vec3 planeNormal)`: Changes the direction of this vector as if it was reflected on a plane. The function returns the `this` object
* `Vec2 setValue(Number x, Number y, Number z| Array | Vec2)`: Sets the values of each component and returns itself


### Vec4
The following functions are special for the `Vec4` type.
* `Vec2 setValue(Number x, Number y, Number z, Number w | Array | Vec2)`: Sets the values of each component and returns itself
* `Vec3 xyz()`: Returns a new vector, which only consists of the x, y and z components


