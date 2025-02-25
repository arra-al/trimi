#include "trimi/system/renderer_system.hpp"
#include "trimi/component/circle.hpp"
#include "trimi/coordinator.hpp"
#include <raylib.h>

extern arra::Coordinator coordinator;

void arra::RendererSystem::Render() {
  for (auto const &entity : mEntities) {
    auto &circleComponent = coordinator.GetComponent<CircleComponent>(entity);

    DrawCircle(circleComponent.centerX, circleComponent.centerY, circleComponent.radius, circleComponent.color);
    
  }
};
