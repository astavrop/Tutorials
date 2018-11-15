---
author: Henrik Heine
category: Developer Guide
last_updated: March 14, 2018
license: cc-by-sa 4.0
order: 1
permalink: introduction_to_escript
subcategory: EScript@1
title: Introduction to EScript
---
<!------------------------------------------------------------------------------------------------
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Henrik Heine (hheine@mail.uni-paderborn.de), Florian Pieper (fpieper@mail.uni-paderborn.de)
 PADrend Version 1.0.0
------------------------------------------------------------------------------------------------->

EScript is an object-oriented scripting language for controlling C++ applications. It is compiled and executed by a virtual machine. EScript ships with PADrend and can be used for rapid prototyping. It is also possible to run the virtual machine as stand alone application.

## Syntax
The syntax is similar to C and JavaScript, therefore statements always ends with a semicolon and there are two kinds of comments. A single line comment starts with `//` and a multiline comment is enclosed with `/*` and `*/`.

## Data Types and Operators
### Primitive Types
EScript supports the following primitive `call-by-value` types:
* `Number` representing double precision numbers. Number literals must be either integrals (decimal, hexadecimal or binary) or floating point numbers. Example: `42 27.4 0x1a -2.7e+10 0b101010`
* `String` must be surrounded by either `"` or by `'`. Example `"test"` and `'test'`. Strings can contain the typical escape sequences and can contain newline characters.
* `Bool` Either `true` or `false`
* `Identifier` immutable name starting with a dollar sign, which is often used for constants: `$example`
* `Void` The `void` value is similar to the null value of many high level languages.

In an expression `false` and `void` are the only values that are evaluated as false. Every other value (also the numeric value `0`) is evaluated as true.
```javascript
outln(false || false); // Output: false
outln(false || void); // Output: false
outln(false || 0); // Output: true
outln(false || ""); // Output: true
```

### Some Operators
```javascript
outln( 2+40 ); // Output: 42
outln( 2*21 ); // Output: 42
outln( "4" + "2" ); // Output: 42
outln( "foo"+"bar" ); // Output: foobar
outln( "wup " * (6/2) ); // Output: wup wup wup
outln( 1>2 ); // Output: false
outln( !true ); // Output: false
outln( true & true ); // Output: true
outln( false || true ); // Output: true
outln( "foo" == "bar" ); // Output: false
outln( "foo" != "bar" ); // Output: true
```
Strings are automatically converted to numbers, if they are ussed in a binary expression and the left operand is a number:
```javascript
outln( 12 + "3" ); // Output: 15
outln( 10 * "10" ); // Output: 100
outln( 10 == "10" ); // Output: true
outln( 10 == "10.0" ); // Output: true
```
If the left operand is a string, the right operand is automatically converted to a string:
```javascript
outln( "12" + 3 ); // Output: 123
outln( "10" == 10 ); // Output: true
outln( "10.0" == 10 ); // Output: false
```
EScript supports many different operators. The precedence is given by the table in [OperatorPrecedence.md](OperatorPrecedence.md)
### Equality
EScript supports different equality operators. One with automatic conversion (`==`) and one without(`===`).
```javascript
outln( 10 == "10" ); // Output: true
outln( 10 === "10" ); // Output: false
outln( 10 === 10 ); // Output: true
outln( true == "foo" ); // Output: true
outln( true === "true" ); // Output: false
outln( "true" == true ); // Output: true
outln( "true" === true ); // Output: false
```

### Calling Functions
Functions can be called just like in C or JavaScript:
```javascript
// call global function 'load':
load("someScript.escript");
// call function 'saveTextFile' in namespace 'IO':
IO.saveTextFile( "foo.txt" , "bar" );
// call global method 'outln'
outln(a, b, c, 42, "test");
```

### Math Functions
Many functions that are typically present in a math namespace are directly defined for all numbers. For example instead of calling `sin` or `sqrt` with a number as a parameter, you call the function on the number object itself:
```javascript
outln(9.sqrt()); // Output: 3
outln((3.141).sin()); // Output: 0.000592654
```

### Local Variables
Local variables are declared with the `var` keyword followed by the name of the variable:
```javascript
var foo; // empty variable named foo (containing void)
var x = 500 - 80 / 2; // variable x containing a number
// The variable "message" will be of type String
var message = "Please click the button";
// Dynamically change the type to Number
message = 5;
```
One important difference to C is, that local variables are valid in the tighest enclosing block, but *excluding* functions defined inside the block. So they are also valid *before* they are declared. Local variables and parameters are allocated on the stack for every call of the surrounding function.
```javascript
{
	outln(x); // Output: void
	var x = 5;
	outln(x); // Output: 5
  var fun = fn() {
    outln(x); // warning: Variable not found 'x'
  };
}
```
The following script will throw a warning: `Variable not found: 'x'`
```javascript
{
	outln(x);
}
```

### Static Variables
The scope of static variables is the tighest enclosing block, *including* functions defined inside the block. Static variables are allocated *once* for all calls of the enclosing function.
```
static factorial = fn( Number n ) {
  return (n == 0) ? 1 : factorial (n - 1) * n; // factorial is visible, because it is static
};
out( factorial( 5 ) ); // Output: 120
```

## Built-in Collection Types
EScript already contains two different collection types (Array and Map), both of them are able to change their size dynamically.

Arrays are collections with numbers as keys and arbitrary objects as values. They can be created by using the array syntax or by instantiating a new array object:
```javascript
var numbers = [3, 23, 7, 3, 100, 1, 35];
var colors = ["red", "green", "blue"];
var array = new Array();
array[10] = 42;
outln(numbers[4]); // Output: 100
outln(numbers[10]); // Output: void
outln(numbers.count()); // Output: 7
outln(number.empty()); // Output: false
```

Maps are basically associative arrays with arbitrary keys (except `void`) and arbitrary values. EScript also supports a map literal, using curly braces. If you want to create an empty map, you must instantiate a new map, because the literal won't work. This is due to the fact that empty curly braces are recognized as empty blocks and not as empty maps.
```javascript
var fruits = {
  "lemon" : "yellow",
  "cherry" : "red"
};
fruits["apple"] = "green";
var map = new Map();
map[42] = "some Value";
```

## Control Structures
EScript supports the typical set of control structures.

### if/else
```javascript
var result = someFunction ();
if(result) {
  out("Success");
} else {
  out("Failure");
}
var num = calculateSomething ();
if(num < 0)
  out("Too small");
else if(num >= 0 && num <= 100)
  out("Range okay");
else
  out("Too large");
```

### Ternary Operator ? :
```javascript
var abs = value >=0 ? value : -value;
```

### while and do-while
```javascript
var i = 0;
while(i<10) {
  out(i++, " ");
} // Output: 0 1 2 3 4 5 6 7 8 9
var j = 0;
do {
	out(j++, " ");
} while(j < 10); // Output: 0 1 2 3 4 5 6 7 8 9
```

### Looping with for
```javascript
var sum = 0;
for(var i = 0; i < 100; ++i) {
  sum += i;
}
outln("Sum of numbers: ", sum);
```

### Collection Iteration with foreach
The general syntax of the foreach loop is: `foreach(<container> as <key>, <value>) <statement>` or if you're only interested in the values: `foreach(<container> as <value>) <statement>`
```javascript
var chars = [’a’, ’c’, ’k’, ’b’, ’d’, ’x’, ’j’];
foreach(chars as var index, var currentChar) {
  if(currentChar === ’x’) {
    outln("Character ’x’ found at index ", index);
    break;
  }
}
foreach(chars as var currentChar) {
  if(currentChar === ’x’) {
    outln("Character ’x’ was found");
    break;
  }
}
```

### Exception Handling
Exceptions can be caught by using a try-catch statement:
```javascript
try {
  outln(42/0); // will throw a division by zero exception
} catch(e) {
  outln(e);
}
```
You can throw any object as an exception like this: `throw 42;` or `throw new Exception();`

But in order to get a full stacktrace you should throw an exception by calling the `Runtime.exception(msg)` function:
```javascript
Runtime.exception("some message");
```

## Functions
One important difference to C is, that in EScript functions are first class objects and that they don't have a name. Functions are defined with the `fn` keyword and because a function is just another object, the definition is a statement and therefore it must end with a semicolon.
```javascript
var square = fn(num) {
  return num * num;
}; // don't forget this semicolon!
var a = square(5);
outln( a ); // Outputs: 25
```

### Recursion
Remember local variables are only visible inside the surrounding scope, but *excluding* nested functions. Therefore the following code wouldn't work, because the `factorial` variable is not visible inside the function.
```javascript
var factorial = fn(Number x){
	if(x>1)
		return x*factorial(x-1); // Warning: Variable 'factorial' not found
	return x;
};
out( factorial(4) );
```
To overcome this issue you must define the factorial variable static or you can use the special `thisFn` keyword, which is a reference to the current function:
```javascript
var factorial = fn(Number x){
	if(x>1)
		return x*thisFn(x-1);
	return x;
};
out( factorial(4) ); // Output: 24
```

### Type Restrictions
The parameters of a function can be restricted to specific types. An exception is thrown if the type does not match.
```javascript
var square = fn(Number num) {
  return num * num;
};
square(5); // ok
square("foo"); // runtime error
```
It is also possible to allow multiple types for a single parameter. Furthermore it is important to know, that void is an independent type!
```javascript
var print = fn([Number, String] value) {
  outln(value);
};
print(42); // ok
print("foo"); // ok
print(void); // runtime error
var print2 = fn([Number, String, void] value) {
  outln(value);
};
print(void); // ok
```

### Default Values
Parameters can have default values. If a type restriction is specified, the default value must also be of that type!
```javascript
var print = fn(value = "no value") {
  outln(value);
};
print("hello"); // Output: hello
print(); // Output: no value
var print2 = fn(String value = void) {
  outln(value);
};
print2(); // runtime error
```

### Varargs
The last parameter of a function definition can be used for a variable argument list. The function can then accept arbitrary many values that are stored as an array in the last parameter.
```javascript
var sum = fn( numbers... ) { // all arguments are automatically passed as an array
  var sum = 0;
  foreach( numbers as var n)
    sum += n;
  return sum;
};
outln( sum( 10,100,1000,4 ) ); // Output: 1114
```

### Multiple Return Values
EScript does not support multiple return values directly, but it has some syntactic sugar to automatically assign multiple values to the content of an array: `[ lValue* ] = Array`
```javascript
var calc = fn() {
  return [17, 42]; // returns an array
};
[var a, var b] = calc();
outln("a:", a, " b:", b); // Output: a:17 b:42
```

### Parameter Binding
You can set the first parameters of a function to fixed values by using a so called function binder (*FnBinder*): `Array => Function`
The result of this expression is a FnBinder object that is used as a wrapper around the function. You can use this object like a normal function, but it will always call the underlying function with the first parameters fixed:
```javascript
var myFun = fn(a, b, c) {
  out("a:", a, "b:", b, " c:", c );
};
myFun(1, 2, 3); // Output: a:1 b:2 c:3
// create a wrapper that always passes 100 and 200 as the first two parameters
var myBoundFun = [ 100, 200 ] => myFun;
myBoundFun( 300 ); // Output: a:100 b:200 c:300
```

Furthermore the *FnBinder* is used to combine an object with a function: `Object -> Function`
The result of this expression is again a FnBinder object. The bound object will be the `this` object of the function.
```javascript
var print = fn() {
	outln(this);
};
print(); // Output: void
var boundedPrint = 42 -> print;
boundedPrint(); // Output: 42
```

## EScript OOP
One of EScript's many similarities to JavaScript is the handling of types. EScript is not a class based language, but instead a prototype based language. The easiest way to get started with user defined objects is by using the `ExtObject`. You can create a new instance of an `ExtObject` and define new attributes for it. You can afterwards access and modify the attributes as you like.
```javascript
var car = new ExtObject;
car.color := "red"; // := creates a new member
car.speed := 190;
car.outputDesc := fn() {
  out("This is a ", this.color , " car ");
  out("with top speed ", this.speed , ".\n");
};
car.speed = 185;
car.outputDesc();
```
As you can see object attributes are defined with this syntax: `object.attribute := value;`. You can change the value of an attribute afterwards by using the normal assignment syntax: `object.attribute = value;`.
If there is already an attribute with this name defined, EScript won't give a warning. If on the other hand an attribute is accessed that was not defined earlier, EScript will give warning:
```javascript
car.acceleration = 0; // Warning: Attribute not found 'acceleration'
```

### Types and Inheritance
As already mentioned, EScript is not a class based language, but a prototype based one. But it is possible to achieve something similar to a class, by instantiating a new `Type`:
```javascript
var Shape = new Type;
Shape.color := "white"; // Define object attribute with value "white"

// New type that is derived from Shape
var Polygon = new Type(Shape);
Polygon.numVertices := 3;

// New type that is derived from Shape
var Circle = new Type(Shape);
Circle.radius := 0;

// instantiate a new Circle
var circle = new Circle;
circle.color = "red";
circle.radius = 5;
```
Here one must be careful, because every attribute of a new instance will be set to the specified value. If the value is a value type, like a number or a string, the value is copied. But if it is a reference type, every instance will point to the same object!
```javascript
Polygon.vertices := [];
var a = new Polygon;
a.vertices[0] = 42;
var b = new Polygon;
outln(b.vertices[0]); // Output: 42
```
This code will output the value `42`, because both instances are refering to the same array!
To overcome this issue you can provide attributes with annotations: `object.attribute @(<list of annotations) := value;`. In this case we look at the `init` annotation:
```javascript
Polygon.vertices @(init) := Array;
var a = new Polygon;
a.vertices[0] = 42;
var b = new Polygon;
outln(b.vertices[0]); // Output: void
```
If you instanciate a new Polygon, the `vertices` attribute will be now set to a new array.

Other useful annotations are the `private` and `const` annotations. A *private* attribute can be only accessed by the `this` object. The value of a *const* attribute cannot be changed afterwards.

Another annotation is used to denote that a function is overiding the parent function:
```javascript
var Parent = new Type;
Parent.print ::= fn() {
  outln("I'm the parent!");
};
var Child = new Type(Parent);
Child.print @(override) ::= fn() {
  outln("I'm the child!");
};
```
You can overide a function without using this annotation, but it is recommended to use this annotation, because EScript will give a warning if there is no function to override:
```javascript
// Warning: Attribute marked with @(override) does not override.
Child.println @(override) ::= fn() {
  outln("I'm the child!");  
};
```
As you can see, this annotation will give you a hint if you accidentally try to override a function that does not exist in the parent.

#### Static Attributes
You can define static attributes by using `::=` instead of `:=`. In many cases you can define your object functions statically, because they are the same for all instances.
```javascript
var T = new Type;
T.value := 42;
T.print ::= fn() {
  outln("value=" + this.value);
};
var a = new T;
a.value = 10;
a.print(); // Output: value=10
T.print(); // Output: value=42
```
Because EScript is prototype based, the `this` object of the *Type* object will point to the type itself and therefore `T.print()` will print out the value of the prototype.

#### Constructor
It is also possible to define an own constructor. This is done by implementing an attribute with the special name `_constructor`. If a new instance of the type is instanciated with the `new` keyword, this attribute is called:
```javascript
var Animal = new Type;
Animal.name := void;
Animal._constructor ::= fn(n){
	name = n;
};
Animal.print ::= fn(){
	out("My name is ", name, "\n");
};
var a = new Animal("Pubert");
a.print();
```
Before the body of a constructor is executed, the constructor of the super type is executed. If you want to give some parameters to the super constructor, you have to use the following syntax:
`Type._constructor ::= fn(constructorParams) @(super(constructorParams)) { ... }`
```javascript
var Animal = new Type;
Animal.name := void;
Animal.canFly := void;
Animal._constructor ::= fn(n, f){
	name = n;
	canFly = f;
	out("Animal created\n");
};
Animal.print ::= fn(){
	out("My name is ", name, "and I can ", (canFly ? "fly" : "not fly"), ".\n");
};

var Dragon = new Type(Animal);
Dragon._constructor ::= fn(n) @(super(n + " the Great", true)){ // explicit call to super constructor
	out("Dragon created\n");
};

var a = new Dragon("Pubert");
a.print();
```

## Operators in EScript
In EScript there are several default operator and also the possibility to overload operators. In the following you find a short introduction to operators.

### Operator Precendence
The following table summarizes the operator precendence from highest (0) to lowest (22).

| Precendence | Operator | Description | Associativity |
| ----- | ----- | ----- | ----- |
| 0 | `@` | | Right |
| 1 | `.`<br>`[ ]`<br>`( )` | Member access<br>Indexing<br>Function call | Left |
| 2 | `new` | Create new instance | Left |
| 3 | `fn` | Function definition | Right |
| 4 | `++`<br>`--`<br>(unary) `-`<br>`~`<br>`!` | Increment<br>Decrement<br>Unary minus<br>Bitwise not<br>Logical not | Right |
| 5 | `*` `/` | Multiplication and Division | Left |
| 6 | `%` | Modulo | Left |
| 7 | `+` `-` | Addition and Subtraction | Left |
| 8 | `<<` `>>` | Left and Right shift | Left |
| 9 | `<` `>` `<=` `>=` `~=` | Relational operators | Left |
| 10 | `==` `!=` `===` `!==` <br> <code>---&#124;></code> <br> `->` | Relational operators<br>Inheritance test<br>Object binder | Left |
| 11 | `=>` | Parameter binder | Left |
| 12 | `&` | Bitwise and | Left |
| 13 | `^` | Bitwise xor | Left |
| 14 | <code>&#124;</code> | Bitwise or | Left |
| 15 | `&&` | Logical and | Right |
| 16 | <code>&#124;&#124;</code> | Logical or | Right |
| 17 | `?:` | Ternary operator `a?b:c` | Right |
| 18 | `=` | Assignment | Right |
| 19 | `:=` | Attribute declaration | Right |
| 20 | `::=`<br><code>*= /= %= += -= &= ^= &#124;=</code> | Type attribute declaration<br>Compound assignments | Right |
| 21 | `...` | Varargs | Left |
| 22 | `,` | Comma | Left |

### Operator Overloading
In EScript it is also possible to overload several operators. This happens on a 'per instance' level. This means that an overloaded operator is a function that is called on the object. For unary operators this means that the operator function doesn't have a parameter and the operand is the `this` object. For binary operators, the function has a single argument, which is the operand to the right of the operator. The left operand is the `this` object. The following code shows a simple example class, which overrides the `+` operator:
```javascript
static T = new Type;
T.value := 0;
T._constructor ::= fn(value) {
  this.value = value;
};
T."+" ::= fn(other) {
  return new T(this.value + other.value);
};
```

One special thing in EScript is that you can overload most operators as unary and binary operators. If it is the binary version, you just write the corresponding operator in quotes, like in the example above. If you want to define the operator as an unary operator in front of the operand, you append `_pre` to it, like `"+_pre"`. If you want to define an unary operator that comes after the operand you append `_post`, like `"+_post"`. One special thing here is the unary minus, which is defined by `"_-_pre"`.
The following operators exist and can be overloaded with the pattern described earlier. Exceptions and additional notes are described afterwards.
```javascript
+ - * / %
& | ^
+= -= *= /= %= &= |= ^= ~=
<< >>
< > <= >= == != === !==
! ~
++ --
@ ...
=> ->
---|>
```
* The unary minus is not defined by `-_pre`, but instead by `_-_pre`.
* It is not possible to override `!_pre`
* Even if it is possible to override `===` and `!==`, it is **strongly** discouraged!
* It is advised to return the `this` object for the following binary operators: `+= -= *= /= %= &= |= ^= ~=`
* It is advised to return a boolean value for the following binary operators: `< > <= >= == != === !==`
* It is **strongly** discouraged to override `->` and `---|>`

Of course you could do many cool and strange things, but it is also advised to not abuse this cool feature. For example in most cases it doesn't make much sense to define a `+=_pre` operator. Just because you *can* define it, doesn't mean you *should* define it! Only use this feature where it is appropriate. For example it is a good idea override `+=` in order to add something to itself. For example the `Array` object uses this in order to append a new value.

#### Simple Example
This simple hand made point class shows you how you could use operator overloading.
```javascript
static Point = new Type;
Point.x := 0;
Point.y := 0;
Point._constructor ::= fn(Number x = 0, Number y = 0) {
	this.x = x;
	this.y = y;
};
Point."+" ::= fn([Point, Number] other) {
	if(other ---|> Point)
		return new Point(x + other.x, y + other.y);
	return new Point(x + other, y + other);
};
Point."+=" ::= fn([Point, Number] other) {
	if(other ---|> Point) {
		x += other.x;
		y += other.y;
	} else {
		x += other;
		y += other;
	}
	return this;
};
Point.toString ::= fn() {
	return "(" + x + ", " + y + ")";
};

var a = new Point(10,0);
var b = new Point(0,20);
outln( "a : ", a.toString() );
outln( "b : ", b.toString() );
outln( "a + b : ", (a + b).toString() );
outln( "a+=10 : ", (a+=10).toString() );
outln( "a : ", a.toString() );
```

You could also do funny things, like this:
```javascript
Number."%_post" ::= fn() { return this / 100; };
```
And now you can simply calculate with percentages:
```javascript
outln(420 * 10%); // Output: 42
```

You can even define a factorial function:
```javascript
Number."!_post" ::= fn() {
	var result = 1;
	for(var i=1; i <= this; i++)
    result *= i;
	return result;
};

outln(5!); // Output: 120
```

#### Indexing Operator
EScript does not only allow operator overloading for 'simple' operators, like + and -, but also for more complex ones, like the indexing operator: `[]`

EScript distinguishes between setting and getting a value via the index operator. In order to get a value via the index operator you define a function called `_get` with a single parameter, which is the given index. In order to set a value, you define a function called `_set` with two parameters, the key and the value.

The following example defines a new type, which can be used like an array, but which uses negative indices to access the content 'backwards', so -1 refers to the last item of the underlying array:
```javascript
var MyArray = new Type;
MyArray.array @(private) := void;
MyArray._constructor ::= fn([Array, void] content) {
	if(content) this.array = content;
	else this.array = new Array();
};
MyArray._get ::= fn(Number key) {
	if(key < 0) key = array.size() + key;
	return array[key];
};
MyArray._set ::= fn(Number key, value) {
	if(key < 0) key = array.size() + key;
	array[key] = value;
};

var arr = new MyArray([1,2,3]);
outln(arr[0]); // first item
outln(arr[-1]); // last item
```

#### Call Operator
EScript also allows us to override the call operator. Therefore it is possible to use an object just like a function. This is done by defining a function called `_call`. This function must have at least one parameter, which is the `caller`. The rest of the parameters can be arbitrary. Example:
```javascript
static MyType = new Type;
MyType._call ::= fn(caller) {
	outln("caller = ", caller);
};

MyType(); // Output: caller = void
var t = new MyType();
t(); // Output: caller = void

var obj = new ExtObject();
obj.myType := new MyType();
obj.myType(); // Output: caller = #ExtObject:ExtObject:0x...
```
