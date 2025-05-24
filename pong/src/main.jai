#import "Basic"()(MEMORY_DEBUGGER = true);
#import "Math";
Simp :: #import "Simp";
#import "Window_Creation";
Input :: #import "Input";

// Colors
WHITE :: Vector4.{1, 1, 1, 1};
BLUE :: Vector4.{0, 0, 1, 1};
RED :: Vector4.{1, 0, 0, 1};

// Window
WINDOW_WIDTH :: 800;
WINDOW_HEIGHT :: 600;

// Entities
Ball :: struct {
    size: float = 15;
    position: Vector2;
    velocity: Vector2 = .{5, 5};
    launched: bool;
}

Pallet :: struct {
    size: Vector2 = .{10, 100};
    position: Vector2;
    velocity: Vector2 = .{0, 3000};
}

// State
State :: struct {
    window: Window_Type;
    ball: Ball;
    pallets: [2]Pallet;
    should_quit: bool;
}

state: State;
DELTA_TIME :: 1.0 / 60.0;

// Controls
Direction :: enum {
    Up;
    Down;
}

Key :: enum {
    S :: 83;
    W :: 87;
}

main :: () {
    init();
    run();
}

init :: () {
    state.window = create_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Pong");

    Simp.set_render_target(state.window);
    Simp.set_shader_for_color(true);

    // Ball
    state.ball.position = .{
        WINDOW_WIDTH / 2 - state.ball.size / 2,
        WINDOW_HEIGHT / 2 - state.ball.size / 2,
    };

    // First pallet
    state.pallets[0].position = .{
        0,
        WINDOW_HEIGHT / 2 - state.pallets[0].size.y / 2
    };

    // Second pallet
    state.pallets[1].position = .{
        WINDOW_WIDTH - state.pallets[1].size.x,
        WINDOW_HEIGHT / 2 - state.pallets[1].size.y / 2,
    };
}

run :: () {
    while !state.should_quit {
        get_input();
        simulate();
        render();
    }
}

get_input :: () {
    Input.update_window_events();

    for event: Input.events_this_frame {
        if event.type == {
            case .QUIT;
                state.should_quit = true;
            case .KEYBOARD; if event.key_pressed {
                if event.key_code == {
                    case .ARROW_UP;
                        move_pallet(*state.pallets[0], .Up);
                    case .ARROW_DOWN;
                        move_pallet(*state.pallets[0], .Down);
                    case xx Key.W;
                        move_pallet(*state.pallets[1], .Up);
                    case xx Key.S;
                        move_pallet(*state.pallets[1], .Down);
                    case .SPACEBAR;
                        state.ball.launched = true;
                }
            }

        }
    }
}

simulate :: () {
    move_ball();
}

render :: () {
    Simp.clear_render_target(WHITE.x, WHITE.y, WHITE.z, WHITE.w);

    Simp.immediate_begin();

    // Ball
    Simp.immediate_quad(
        state.ball.position.x,
        state.ball.position.y,
        state.ball.position.x + state.ball.size,
        state.ball.position.y + state.ball.size,
        RED,
    );

    // Pallets
    for pallet, i: state.pallets {
        Simp.immediate_quad(
            pallet.position.x,
            pallet.position.y,
            pallet.position.x + pallet.size.x,
            pallet.position.y + pallet.size.y,
            BLUE,
        );
    }

    // Net
    Simp.immediate_quad(
        WINDOW_WIDTH / 2 - 1,
        0,
        WINDOW_WIDTH / 2 + 1,
        WINDOW_HEIGHT,
        BLUE,
    );

    Simp.immediate_flush();

    Simp.swap_buffers(state.window);
}

move_pallet :: (pallet: *Pallet, direction: Direction) {
    if direction == .Up && pallet.position.y <= WINDOW_HEIGHT - pallet.size.y {
        pallet.position += pallet.velocity * DELTA_TIME;
    }

    if direction == .Down && pallet.position.y >= 0 {
        pallet.position -= pallet.velocity * DELTA_TIME;
    }
}

move_ball :: () {
    if !state.ball.launched {
        return;
    }

    // Collide with walls
    if (
        state.ball.position.y >= WINDOW_HEIGHT
        || state.ball.position.y <= 0
    ) {
        state.ball.velocity.y *= -1;
    }
    if (
        state.ball.position.x <= 0
        || state.ball.position.x >= WINDOW_WIDTH
    ) {
        state.ball.velocity.x *= -1;
    }

    state.ball.position += state.ball.velocity * DELTA_TIME;
}
