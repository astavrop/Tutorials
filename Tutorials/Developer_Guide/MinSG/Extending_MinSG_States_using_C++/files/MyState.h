/*
This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
 Author: Stanislaw Eppinger (eppinger@mail.uni-paderborn.de)
 PADrend Version 1.0.0
*/
#ifndef MYPROJECT_MYSTATE_H
#define MYPROJECT_MYSTATE_H

#include <MinSG/Core/States/State.h>

namespace MyProject {

class MyState : public MinSG::State {
  PROVIDES_TYPE_NAME(MyState)
public:
  State::stateResult_t doEnableState(MinSG::FrameContext & context, MinSG::Node * node, const MinSG::RenderParam & rp) override;
  void doDisableState(MinSG::FrameContext & context,MinSG::Node *, const MinSG::RenderParam & rp) override;
  MyState * clone() const override;
};

}

#endif /* MYPROJECT_MYSTATE_H */
