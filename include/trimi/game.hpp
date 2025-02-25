#pragma once

#include "trimi/coordinator.hpp"
#include <string>
namespace arra {
class Game {
public:
  Game() = delete;
  Game(const int t_screenWidth, const int t_screenHeight, const char *title);
  ~Game();
  //: m_screenWidth{t_screenWidth}, m_screenHeight{t_screenHeight} {}
  constexpr int getScreenWidth() { return m_screenWidth; };
  constexpr int getScreenHeight() { return m_screenHeight; };
  // constexpr Coordinator& getCoordinator() {return m_coordinator;};
  void Init();
  void Play();

private:
  int m_screenWidth{0}, m_screenHeight{0};
  const char *m_title{nullptr};
  void Update();
  void Render();  
};
} // namespace arra
