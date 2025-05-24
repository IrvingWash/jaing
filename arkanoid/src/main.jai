#import "Basic"()(MEMORY_DEBUGGER = true);
Game :: #import,dir "game";

main :: () {
    Game.init();

    Game.run();

    Game.destroy();
}
