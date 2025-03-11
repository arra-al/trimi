#pragma once

#include "trimi/core/system.hpp"

namespace arra {
class PhysicsSystem : public System
{
public:
  void Init();
  void Update(const float dt);
};
};
