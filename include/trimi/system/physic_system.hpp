#pragma once

#include "trimi/system.hpp"

namespace arra {
class PhysicsSystem : public System
{
public:
  void Init();
  void Update(const float dt);
};
};
