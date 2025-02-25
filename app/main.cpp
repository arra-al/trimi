#include <raylib.h>
#include "trimi/game.hpp"

int main() {
  const int screenWidth{1200};
  const int screenHeight{720};
  const char* title = "Raylib first example";

  arra::Game game {screenWidth, screenHeight, title};

  game.Init();

  game.Play();
  return 0;

}
