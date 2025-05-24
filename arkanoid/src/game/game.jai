#import "Basic";
Window_Creation :: #import "Window_Creation";
Simp :: #import "Simp";
Input :: #import "Input";

#load "player.jai";

#scope_module;

Game :: struct {
    window: Window_Creation.Window_Type;
    should_quit: bool;
    player: Player;
    bullets: [..]Bullet;
}

#scope_file;
game: Game;

WINDOW_WIDTH :: 800;
WINDOW_HEIGHT :: 600;
DELTA_TIME :: 0.016;

#scope_module;
init :: () {
    game.window = Window_Creation.create_window(window_name = "Arkanoid", width = 800, height = 600);
    game.player.position = .{
        x = WINDOW_WIDTH / 2 - game.player.size.x / 2,
        y = WINDOW_HEIGHT / 2 - game.player.size.y / 2,
    };
    Simp.set_render_target(game.window);
}

run :: () {
    while !game.should_quit {
        get_input();

        update();

        render();
    }
}

destroy :: () {
    free(game.bullets.data);
}

#scope_file;
get_input :: () {
    Input.update_window_events();

    for event: Input.events_this_frame {
        if event.type == .QUIT {
            game.should_quit = true;
        }
    }
}

update :: () {
    player_update(*game.player, DELTA_TIME, *game.bullets);

    for game.bullets {
        bullet_update(*it, DELTA_TIME);
    }
}

render :: () {
    Simp.clear_render_target(0, 0, 0, 255);

    Simp.set_shader_for_color();

    Simp.immediate_begin();
    Simp.immediate_quad(
        game.player.position.x,
        game.player.position.y,
        game.player.position.x + game.player.size.x,
        game.player.position.y + game.player.size.y,
        game.player.color
    );

    for game.bullets {
        Simp.immediate_quad(
            it.position.x,
            it.position.y,
            it.position.x + it.size.x,
            it.position.y + it.size.y,
            it.color
        );
    }
    Simp.immediate_flush();

    Simp.swap_buffers(game.window);
}
