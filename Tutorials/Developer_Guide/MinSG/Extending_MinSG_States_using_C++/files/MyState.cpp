/*
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Stanislaw Eppinger (eppinger@mail.uni-paderborn.de)
 PADrend Version 1.0.0
*/
#include "MyState.h"

#include <MinSG/Core/FrameContext.h>
#include <MinSG/Core/Nodes/CameraNode.h>

namespace MyProject {

using namespace MinSG;
  
State::stateResult_t MyState::doEnableState(FrameContext & context, Node * node, const RenderParam & rp){
  auto camPos = context.getCamera()->getWorldOrigin();
  auto nodePos = node->getWorldOrigin();
  auto diff = (camPos - nodePos).length();
  if (diff > 20) return State::stateResult_t::STATE_SKIP_RENDERING;
  return State::stateResult_t::STATE_OK;
}

void MyState::doDisableState(FrameContext & context, Node * node, const RenderParam & rp) {
  //Clean up everything you have done in doEnableState, e.g. popping shaders from the rendering context
}

MyState * MyState::clone() const {
  return new MyState(*this);
}

}
