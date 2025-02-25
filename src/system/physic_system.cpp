#include "trimi/system/physic_system.hpp"
#include "trimi/component/circle.hpp"
#include "trimi/component/gravity.hpp"
#include "trimi/component/rigid_body.hpp"
#include "trimi/coordinator.hpp"
#include <raylib.h>

extern arra::Coordinator coordinator;

void arra::PhysicsSystem::Init(){}

void arra::PhysicsSystem::Update(const float dt) {
  
  for (auto const &entity : mEntities) {
    auto &rigidBody = coordinator.GetComponent<RigidBody>(entity);

    // Forces
    auto const &gravity = coordinator.GetComponent<Gravity>(entity);
    auto &circleComponent = coordinator.GetComponent<CircleComponent>(entity);

    rigidBody.velocity.x += gravity.gforce.x * dt;
    rigidBody.velocity.y += gravity.gforce.y * dt;
    rigidBody.velocity.z += gravity.gforce.z * dt;

    // circleComponent.radius = 64;
    // circleComponent.color = RED;
    circleComponent.centerX += rigidBody.velocity.x;
    circleComponent.centerY += rigidBody.velocity.y;
    
  }
}
