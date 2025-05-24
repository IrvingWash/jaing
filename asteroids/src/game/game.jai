#scope_file;

#import "Window_Creation";
#import "Math";
Simp :: #import "Simp";
Input :: #import "Input";

WINDOW_WIDTH :: 800;
WINDOW_HEIGHT :: 600;

CLEAR_COLOR :: float.[0, 0, 0, 1];

Game :: struct {
    window: Window_Type;
    state: Game_State;
    should_quit: bool;
}

Game_State :: enum {
    Greeter;
    Gameplay;
    Game_Over;
}

game: Game;

#scope_export

init :: () {
    game.window = create_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Asteroids");
    Simp.set_render_target(game.window);
}

run :: () {
    while !game.should_quit {
        get_input();
        update();
        render();
    }
}

destroy :: () {}

#scope_file

get_input :: () {
    Input.update_window_events();

    for event: Input.events_this_frame {
        if event.type == .QUIT {
            game.should_quit = true;
        }
    }
}

update :: () {}

render :: () {
    Simp.clear_render_target(CLEAR_COLOR[0], CLEAR_COLOR[1], CLEAR_COLOR[2], CLEAR_COLOR[3]);

    Simp.swap_buffers(game.window);
}
