/*
	This file is part of the Util library.
	Copyright (C) 2007-2012 Benjamin Eikel <benjamin@eikel.org>
	Copyright (C) 2007-2012 Claudius Jähn <claudius@uni-paderborn.de>
	Copyright (C) 2007-2012 Ralf Petring <ralf@petring.net>
	
	This library is subject to the terms of the Mozilla Public License, v. 2.0.
	You should have received a copy of the MPL along with this library; see the 
	file LICENSE. If not, you can obtain one at http://mozilla.org/MPL/2.0/.
*/
#include "PixelAccessor.h"
#include "../Macros.h"
#include <algorithm>

namespace Util {

bool PixelAccessor::crop(uint32_t & x,uint32_t & y,uint32_t & width,uint32_t & height)const{
	if(x>=getWidth() || y>=getHeight())
		return false;
	if(x+width>=getWidth())
		width -= (x+width)-getWidth();
	if(y+height>=getHeight())
		height -= (y+height)-getHeight();
	return true;
}

//! ---o
void PixelAccessor::doFill(uint32_t x,uint32_t y,uint32_t width,uint32_t height,const Color4f & c){
	const uint32_t maxX = x+width;
	const uint32_t maxY = y+height;
	for(uint32_t cy=y ; cy<maxY; ++cy)
		for(uint32_t cx=x ; cx<maxX ; ++cx)
			doWriteColor(cx,cy,c);
}


// ------------------------------------


//! PixelAccessorUb ---|> PixelAccessor
class PixelAccessorUb : public PixelAccessor{
	public:
		PixelAccessorUb(Reference<Bitmap> bitmap) : 
			PixelAccessor(std::move(bitmap)) {
		}
		virtual ~PixelAccessorUb(){}

	private:
		//! ---|> PixelAccessor
		Color4f doReadColor4f(uint32_t x,uint32_t y)const override{
			return Color4f(doReadColor4ub( x,y ));
		}

		//! ---|> PixelAccessor
		Color4ub doReadColor4ub(uint32_t x,uint32_t y)const override{
			const uint8_t * const p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();
			return Color4ub(
						f.getByteOffset_r()==PixelFormat::NONE ? 0 : *( p + f.getByteOffset_r() ),
						f.getByteOffset_g()==PixelFormat::NONE ? 0 : *( p + f.getByteOffset_g() ),
						f.getByteOffset_b()==PixelFormat::NONE ? 0 : *( p + f.getByteOffset_b() ),
						f.getByteOffset_a()==PixelFormat::NONE ? 255 : *( p + f.getByteOffset_a() ));
		}

		//! ---|> PixelAccessor
		float doReadSingleValueFloat(uint32_t x, uint32_t y) const override {
			return doReadSingleValueByte(x, y) / 255.0f;
		}

		//! ---|> PixelAccessor
		uint8_t doReadSingleValueByte(uint32_t x, uint32_t y) const override {
			const uint8_t * const ptr = _ptr<uint8_t>(x, y);
			const PixelFormat & format = getPixelFormat();
			return format.getByteOffset_r() == PixelFormat::NONE ? 0 : *(ptr + format.getByteOffset_r());
		}

		//! ---|> PixelAccessor
		void doWriteColor(uint32_t x,uint32_t y,const Color4f & c) override{
			doWriteColor(x,y,Color4ub(c));
		}

		//! ---|> PixelAccessor
		void doWriteColor(uint32_t x,uint32_t y,const Color4ub & c) override{
			uint8_t * p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();

			if(f.getByteOffset_r()!=PixelFormat::NONE )
				*( p + f.getByteOffset_r() ) = c.getR();
			if(f.getByteOffset_g()!=PixelFormat::NONE )
				*( p + f.getByteOffset_g() ) = c.getG();
			if(f.getByteOffset_b()!=PixelFormat::NONE )
				*( p + f.getByteOffset_b() ) = c.getB();
			if(f.getByteOffset_a()!=PixelFormat::NONE )
				*( p + f.getByteOffset_a() ) = c.getA();
		}

		//! ---|> PixelAccessor
		void doWriteSingleValueFloat(uint32_t x, uint32_t y, float value) override {
			const uint_fast16_t tmpR = static_cast<uint_fast16_t>(256 * value);
			doWriteColor(x, y, Color4ub(static_cast<uint8_t>(tmpR > 255 ? 255 : tmpR),0,0,0) );
		}
};

//! PixelAccessor4ub ---|> PixelAccessor
class PixelAccessor4ub : public PixelAccessor{
	public:
		PixelAccessor4ub(Reference<Bitmap> bitmap) : 
			PixelAccessor(std::move(bitmap)) {
		}
		virtual ~PixelAccessor4ub(){}

	private:
		//! ---|> PixelAccessor
		Color4f doReadColor4f(uint32_t x,uint32_t y)const override{
			const uint8_t * const p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();
			return Color4f(Color4ub( p[f.getByteOffset_r()], p[f.getByteOffset_g()], p[f.getByteOffset_b()], p[f.getByteOffset_a()] ));
		}

		//! ---|> PixelAccessor
		Color4ub doReadColor4ub(uint32_t x,uint32_t y)const override{
			const uint8_t * const p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();
			return Color4ub( p[f.getByteOffset_r()], p[f.getByteOffset_g()], p[f.getByteOffset_b()], p[f.getByteOffset_a()] );
		}

		//! ---|> PixelAccessor
		float doReadSingleValueFloat(uint32_t x, uint32_t y) const override {
			return doReadSingleValueByte(x, y) / 255.0f;
		}

		//! ---|> PixelAccessor
		uint8_t doReadSingleValueByte(uint32_t x, uint32_t y) const override {
			const uint8_t * const ptr = _ptr<uint8_t>(x, y);
			const PixelFormat & format = getPixelFormat();
			return ptr[format.getByteOffset_r()];
		}

		//! ---|> PixelAccessor
		void doWriteColor(uint32_t x,uint32_t y,const Color4f & c) override{
			doWriteColor(x,y,Color4ub(c));
		}

		//! ---|> PixelAccessor
		void doWriteColor(uint32_t x,uint32_t y,const Color4ub & c) override{
			uint8_t * p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();
			p[f.getByteOffset_r()] = c.getR();
			p[f.getByteOffset_g()] = c.getG();
			p[f.getByteOffset_b()] = c.getB();
			p[f.getByteOffset_a()] = c.getA();
		}

		//! ---|> PixelAccessor
		void doWriteSingleValueFloat(uint32_t x, uint32_t y, float value) override {
			const uint_fast16_t tmpR = static_cast<uint_fast16_t>(256 * value);
			doWriteColor(x, y, Color4ub(static_cast<uint8_t>(tmpR > 255 ? 255 : tmpR),0,0,0));
		}

		//! ---|> PixelAccessor
		void doFill(uint32_t x,uint32_t y,uint32_t width,uint32_t height,const Color4f & c) override{
			const PixelFormat & f=getPixelFormat();
			uint32_t i=0;
			const Color4ub cub(c);
			reinterpret_cast<uint8_t *>(&i)[f.getByteOffset_r()] = cub.getR();
			reinterpret_cast<uint8_t *>(&i)[f.getByteOffset_g()] = cub.getG();
			reinterpret_cast<uint8_t *>(&i)[f.getByteOffset_b()] = cub.getB();
			reinterpret_cast<uint8_t *>(&i)[f.getByteOffset_a()] = cub.getA();

			uint32_t * rowCursor = _ptr<uint32_t>(x,y);

			for(uint32_t cy=0 ; cy<height ; ++cy){
				uint32_t * columnCursor=rowCursor;
				for(uint32_t cx=0 ; cx<width; ++cx){
					*(columnCursor++) = i;
				}
				rowCursor+=getWidth();
			}
		}
};

//! PixelAccessorf ---|> PixelAccessor
class PixelAccessorF : public PixelAccessor{

	public:
		PixelAccessorF(Reference<Bitmap> bitmap) : 
			PixelAccessor(std::move(bitmap)) {
		}
		virtual ~PixelAccessorF(){}

	private:
		//! ---|> PixelAccessor
		Color4f doReadColor4f(uint32_t x,uint32_t y)const override{
			const uint8_t * const p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();

			return Color4f(
						f.getByteOffset_r()==PixelFormat::NONE ? 0.0f : *reinterpret_cast<const float*>( p + f.getByteOffset_r() ),
						f.getByteOffset_g()==PixelFormat::NONE ? 0.0f : *reinterpret_cast<const float*>( p + f.getByteOffset_g() ),
						f.getByteOffset_b()==PixelFormat::NONE ? 0.0f : *reinterpret_cast<const float*>( p + f.getByteOffset_b() ),
						f.getByteOffset_a()==PixelFormat::NONE ? 1.0f : *reinterpret_cast<const float*>( p + f.getByteOffset_a() ));
		}

		//! ---|> PixelAccessor
		Color4ub doReadColor4ub(uint32_t x,uint32_t y)const override{
			return Color4ub(doReadColor4f(x,y));
		}

		//! ---|> PixelAccessor
		float doReadSingleValueFloat(uint32_t x, uint32_t y) const override {
			const uint8_t * const ptr = _ptr<uint8_t>(x, y);
			const PixelFormat & format = getPixelFormat();
			return format.getByteOffset_r() == PixelFormat::NONE ? 0.0f : *reinterpret_cast<const float *>(ptr + format.getByteOffset_r());
		}

		//! ---|> PixelAccessor
		uint8_t doReadSingleValueByte(uint32_t x, uint32_t y) const override {
			return static_cast<uint8_t>(255.0f * doReadSingleValueFloat(x, y));
		}

		//! ---|> PixelAccessor
		void doWriteColor(uint32_t x,uint32_t y,const Color4f & c) override{
			uint8_t * p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();
			if(f.getByteOffset_r()!=PixelFormat::NONE )
				*reinterpret_cast<float*>( p + f.getByteOffset_r() ) = c.getR();
			if(f.getByteOffset_g()!=PixelFormat::NONE )
				*reinterpret_cast<float*>( p + f.getByteOffset_g() ) = c.getG();
			if(f.getByteOffset_b()!=PixelFormat::NONE )
				*reinterpret_cast<float*>( p + f.getByteOffset_b() ) = c.getB();
			if(f.getByteOffset_a()!=PixelFormat::NONE )
				*reinterpret_cast<float*>( p + f.getByteOffset_a() ) = c.getA();
		}

		//! ---|> PixelAccessor
		void doWriteColor(uint32_t x,uint32_t y,const Color4ub & c) override{
			doWriteColor(x,y,Color4f(c));
		}
		
		//! ---|> PixelAccessor
		void doWriteSingleValueFloat(uint32_t x, uint32_t y, float value) override {
			uint8_t * const ptr = _ptr<uint8_t>(x, y);
			const PixelFormat & format = getPixelFormat();
			if(format.getByteOffset_r() != PixelFormat::NONE)
				*reinterpret_cast<float *>(ptr + format.getByteOffset_r()) = value;
		}
};


/*! PixelAccessorI32 ---|> PixelAccessor
	\note No conversions are performed.
*/
class PixelAccessorI32 : public PixelAccessor{
	public:
		PixelAccessorI32(Reference<Bitmap> bitmap) : PixelAccessor(std::move(bitmap)) {}
		virtual ~PixelAccessorI32(){}

	private:
		Color4f doReadColor4f(uint32_t x,uint32_t y)const override{
			const uint8_t * const p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();

			return Color4f(
						f.getByteOffset_r()==PixelFormat::NONE ? 0.0f : static_cast<float>( *reinterpret_cast<const int32_t*>( p + f.getByteOffset_r() )),
						f.getByteOffset_g()==PixelFormat::NONE ? 0.0f : static_cast<float>( *reinterpret_cast<const int32_t*>( p + f.getByteOffset_g() )),
						f.getByteOffset_b()==PixelFormat::NONE ? 0.0f : static_cast<float>( *reinterpret_cast<const int32_t*>( p + f.getByteOffset_b() )),
						f.getByteOffset_a()==PixelFormat::NONE ? 1.0f : static_cast<float>( *reinterpret_cast<const int32_t*>( p + f.getByteOffset_a() )));
		}

		Color4ub doReadColor4ub(uint32_t x,uint32_t y)const override			{	return Color4ub(doReadColor4f(x,y));	}

		float doReadSingleValueFloat(uint32_t x, uint32_t y) const override {
			const uint8_t * const ptr = _ptr<uint8_t>(x, y);
			const PixelFormat & format = getPixelFormat();
			return format.getByteOffset_r() == PixelFormat::NONE ? 0.0f : static_cast<float>( *reinterpret_cast<const int32_t*>( ptr + format.getByteOffset_r() ));
		}

		uint8_t doReadSingleValueByte(uint32_t x, uint32_t y) const override	{	return static_cast<uint8_t>(doReadSingleValueFloat(x, y));	}
		void doWriteColor(uint32_t x,uint32_t y,const Color4f & c) override{
			uint8_t * p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();

			if(f.getByteOffset_r()!=PixelFormat::NONE )
				*reinterpret_cast<int32_t*>( p + f.getByteOffset_r() ) = static_cast<int32_t>( c.getR() );
			if(f.getByteOffset_g()!=PixelFormat::NONE )
				*reinterpret_cast<int32_t*>( p + f.getByteOffset_g() ) = static_cast<int32_t>( c.getG() );
			if(f.getByteOffset_b()!=PixelFormat::NONE )
				*reinterpret_cast<int32_t*>( p + f.getByteOffset_b() ) = static_cast<int32_t>( c.getB() );
			if(f.getByteOffset_a()!=PixelFormat::NONE )
				*reinterpret_cast<int32_t*>( p + f.getByteOffset_a() ) = static_cast<int32_t>( c.getA() );
		}
		void doWriteColor(uint32_t x,uint32_t y,const Color4ub & c) override	{	doWriteColor(x,y,Color4f(c.r(),c.g(),c.b(),c.a()));	}
		void doWriteSingleValueFloat(uint32_t x, uint32_t y, float value) override {
			uint8_t * const ptr = _ptr<uint8_t>(x, y);
			const PixelFormat & format = getPixelFormat();
			if(format.getByteOffset_r() != PixelFormat::NONE)
				*reinterpret_cast<float*>( ptr + format.getByteOffset_r() ) = value;
		}
};


/*! PixelAccessorU32 ---|> PixelAccessor
	\note No conversions are performed.
*/
class PixelAccessorU32 : public PixelAccessor{
	public:
		PixelAccessorU32(Reference<Bitmap> bitmap) : PixelAccessor(std::move(bitmap)) {}
		virtual ~PixelAccessorU32(){}

	private:
		Color4f doReadColor4f(uint32_t x,uint32_t y)const override{
			const uint8_t * const p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();

			return Color4f(
						f.getByteOffset_r()==PixelFormat::NONE ? 0.0f : static_cast<float>( *reinterpret_cast<const uint32_t*>( p + f.getByteOffset_r() )),
						f.getByteOffset_g()==PixelFormat::NONE ? 0.0f : static_cast<float>( *reinterpret_cast<const uint32_t*>( p + f.getByteOffset_g() )),
						f.getByteOffset_b()==PixelFormat::NONE ? 0.0f : static_cast<float>( *reinterpret_cast<const uint32_t*>( p + f.getByteOffset_b() )),
						f.getByteOffset_a()==PixelFormat::NONE ? 1.0f : static_cast<float>( *reinterpret_cast<const uint32_t*>( p + f.getByteOffset_a() )));
		}

		Color4ub doReadColor4ub(uint32_t x,uint32_t y)const override			{	return Color4ub(doReadColor4f(x,y));	}

		float doReadSingleValueFloat(uint32_t x, uint32_t y) const override {
			const uint8_t * const ptr = _ptr<uint8_t>(x, y);
			const PixelFormat & format = getPixelFormat();
			return format.getByteOffset_r() == PixelFormat::NONE ? 0.0f : static_cast<float>( *reinterpret_cast<const uint32_t*>( ptr + format.getByteOffset_r() ));
		}

		uint8_t doReadSingleValueByte(uint32_t x, uint32_t y) const override	{	return static_cast<uint8_t>(doReadSingleValueFloat(x, y));	}
		void doWriteColor(uint32_t x,uint32_t y,const Color4f & c) override{
			uint8_t * p = _ptr<uint8_t>(x,y);
			const PixelFormat & f=getPixelFormat();

			if(f.getByteOffset_r()!=PixelFormat::NONE )
				*reinterpret_cast<uint32_t*>( p + f.getByteOffset_r() ) = static_cast<uint32_t>( c.getR() );
			if(f.getByteOffset_g()!=PixelFormat::NONE )
				*reinterpret_cast<uint32_t*>( p + f.getByteOffset_g() ) = static_cast<uint32_t>( c.getG() );
			if(f.getByteOffset_b()!=PixelFormat::NONE )
				*reinterpret_cast<uint32_t*>( p + f.getByteOffset_b() ) = static_cast<uint32_t>( c.getB() );
			if(f.getByteOffset_a()!=PixelFormat::NONE )
				*reinterpret_cast<uint32_t*>( p + f.getByteOffset_a() ) = static_cast<uint32_t>( c.getA() );
		}
		void doWriteColor(uint32_t x,uint32_t y,const Color4ub & c) override	{	doWriteColor(x,y,Color4f(c.r(),c.g(),c.b(),c.a()));	}
		void doWriteSingleValueFloat(uint32_t x, uint32_t y, float value) override {
			uint8_t * const ptr = _ptr<uint8_t>(x, y);
			const PixelFormat & format = getPixelFormat();
			if(format.getByteOffset_r() != PixelFormat::NONE)
				*reinterpret_cast<uint32_t*>( ptr + format.getByteOffset_r() ) = static_cast<uint32_t>( value );
		}
};

// -----------------------------------------------------------------------------------

//! (static)
Reference<PixelAccessor> PixelAccessor::create(Reference<Bitmap> bitmap) {
	if(bitmap.isNull()) {
		return nullptr;
	} else if(bitmap->getPixelFormat().getValueType()==Util::TypeConstant::UINT8 && bitmap->getPixelFormat().getNumComponents()==4){ // 4 bytes
		return new PixelAccessor4ub(std::move(bitmap));
	} else if(bitmap->getPixelFormat().getValueType()==Util::TypeConstant::UINT8 ){ // x bytes
		return new PixelAccessorUb(std::move(bitmap));
	} else if(bitmap->getPixelFormat().getValueType()==Util::TypeConstant::FLOAT){ // floats
		return new PixelAccessorF(std::move(bitmap));
	} else if(bitmap->getPixelFormat().getValueType()==Util::TypeConstant::UINT32){
		return new PixelAccessorU32(std::move(bitmap));
	} else if(bitmap->getPixelFormat().getValueType()==Util::TypeConstant::INT32){
		return new PixelAccessorI32(std::move(bitmap));
	} else{
		WARN("PixelAccessor::create: There is no implemented PixelAccessor available for this bitmap format.");
		return nullptr;
	}
}

void PixelAccessor::copy(PixelAccessor * source, PixelAccessor * dest){
	for(uint32_t x = 0; x< std::min(source->getWidth(), dest->getWidth()); ++x)
		for(uint32_t y = 0; y< std::min(source->getHeight(), dest->getHeight()); ++y)
			dest->doWriteColor(x,y,source->doReadColor4f(x,y));
}


}
