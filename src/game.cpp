#include "trimi/component/gravity.hpp"
#include "trimi/component/rigid_body.hpp"
#include "trimi/component/circle.hpp"
#include "trimi/core.hpp"
#include "trimi/system/physic_system.hpp"
#include "trimi/system/renderer_system.hpp"
#include "trimi/game.hpp"
#include "trimi/coordinator.hpp"
#include <random>
#include <raylib.h>

using namespace arra;

arra::Coordinator coordinator = Coordinator();

Game::Game(const int screenWidth, const int screenHeight, const char* title) {
  this->m_screenWidth = screenWidth;
  this->m_screenHeight = screenHeight;
  this->m_title = title;
  
};

Game::~Game() {
  CloseWindow();
}

void Game::Init() {
  InitWindow(m_screenWidth, m_screenHeight, m_title);
  coordinator.Init();
  coordinator.RegisterComponent<Gravity>();
	coordinator.RegisterComponent<RigidBody>();
  coordinator.RegisterComponent<CircleComponent>();

  
};


void Game::Play() {
  auto physicsSystem = coordinator.RegisterSystem<PhysicsSystem>();
  {
		Signature signature;
		signature.set(coordinator.GetComponentType<Gravity>());
		signature.set(coordinator.GetComponentType<RigidBody>());
    coordinator.SetSystemSignature<PhysicsSystem>(signature);
    
	}
  auto rendererSystem = coordinator.RegisterSystem<RendererSystem>();
  {
    Signature signature;
    signature.set(coordinator.GetComponentType<CircleComponent>());
    coordinator.SetSystemSignature<RendererSystem>(signature);
  }

  std::vector<Entity> entities(MAX_ENTITIES);
  std::default_random_engine generator;
  std::uniform_real_distribution<float> randXPosition(
      0.f,
      static_cast<float>(m_screenWidth));

  std::uniform_real_distribution<float> randYPosition(
      0.0f,
      static_cast<float>(m_screenHeight));

  std::uniform_real_distribution<float> randGravity(1.f, 10.0f);

  for (auto& entity : entities) {
    entity = coordinator.CreateEntity();
    int centerX = static_cast<int>(randXPosition(generator));
    int centerY = static_cast<int>(randYPosition(generator));
    coordinator.AddComponent(entity, CircleComponent{.centerX = centerX,
                                                     .centerY = centerY,
                                                     .radius = 16,
                                                     .color = RED});
    coordinator.AddComponent(
        entity, RigidBody{.velocity = Vector3{0.0f, 0.0f, 0.0f},
                          .acceleration = Vector3{0.0f, 0.0f, 0.0f}});

    coordinator.AddComponent(
        entity, Gravity{.gforce = Vector3{0.0f, randGravity(generator), 0.0f}});
    
    
      };
  
  while (!WindowShouldClose()) {
    this->Update();
    physicsSystem->Update(0.016f);

    BeginDrawing();
    ClearBackground(SKYBLUE);

    rendererSystem->Render();

    EndDrawing();
  }

  CloseWindow();
};

void Game::Update() {
  const float deltaTime = 0.016f;
  
  // update game logic/ physics
  if (IsKeyDown(KEY_A)) {
    //move left
  }
  if (IsKeyDown(KEY_W)) {
    //move up
  }
  if (IsKeyDown(KEY_D)) {
    //move right
  }
  if (IsKeyDown(KEY_S)) {
    //move down
  }
};

void Game::Render() {

}



