#import "Basic"()(MEMORY_DEBUGGER = true);
using,except(distance) Math :: #import "Math";
Simp :: #import "Simp";
#import "Window_Creation";
Input :: #import "Input";
#import "Random";

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
    velocity: Vector2;
    speed: float = 7;
}

Pallet :: struct {
    size: Vector2 = .{15, 100};
    position: Vector2;
    speed: float = 7;
    velocity: Vector2;
    score: u64;
}

// State
State :: struct {
    window: Window_Type;
    ball: Ball;
    pallets: [2]Pallet;
    should_quit: bool;
}

// Assets
font: *Simp.Dynamic_Font;
FONT_SIZE :: WINDOW_HEIGHT / 24;

state: State;
DUMMY_DELTA_TIME :: 1.0 / 60.0;

// Controls
Key :: enum {
    S :: 83;
    W :: 87;
}

main :: () {
    init();
    run();
    destroy();
}

init :: () {
    state.window = create_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Pong");

    font = Simp.get_font_at_size("./assets", "OpenSans-BoldItalic.ttf", FONT_SIZE);
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

destroy :: () {
    Simp.release_font(font);
}

run :: () {
    while !state.should_quit {
        get_input();
        simulate();
        render();
        reset_temporary_storage();
    }
}

get_input :: () {
    Input.update_window_events();

    for event: Input.events_this_frame {
        if event.type == {
            case .QUIT;
                state.should_quit = true;
            case .KEYBOARD;
                if event.key_pressed {
                    if event.key_code == {
                        case .ARROW_UP;
                            state.pallets[0].velocity = .{0, state.pallets[0].speed};
                        case .ARROW_DOWN;
                            state.pallets[0].velocity = .{0, -state.pallets[0].speed};
                        case xx Key.W;
                            state.pallets[1].velocity = .{0, state.pallets[1].speed};
                        case xx Key.S;
                            state.pallets[1].velocity = .{0, -state.pallets[1].speed};
                        case .SPACEBAR;
                            launch_ball();
                    }
                } else {
                    if event.key_code == {
                        case .ARROW_UP; #through;
                        case .ARROW_DOWN;
                            state.pallets[0].velocity = .{};
                        case xx Key.W; #through;
                        case xx Key.S;
                            state.pallets[1].velocity = .{};
                    }
                }
        }
    }
}

simulate :: () {
    move_pallets();
    move_ball();
    update_score();
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
    for pallet: state.pallets {
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

    // Score
    for pallet: state.pallets {
        Simp.prepare_text(font, tprint("%", pallet.score));

        Simp.draw_prepared_text(
            font,
            ifx it_index == 0 then 10 else WINDOW_WIDTH - 10 - FONT_SIZE,
            10,
            .{0, 0, 0, 1}
        );
    }

    Simp.immediate_flush();

    Simp.swap_buffers(state.window);
}

move_pallets :: () {
    for * pallet: state.pallets {
        if pallet.velocity.y > 0 && pallet.position.y <= WINDOW_HEIGHT - pallet.size.y {
            pallet.position += pallet.velocity * DUMMY_DELTA_TIME;
        }

        if pallet.velocity.y < 0 && pallet.position.y >= 0 {
            pallet.position += pallet.velocity * DUMMY_DELTA_TIME;
        }
    }
}

move_ball :: () {
    // Collide with pallets
    for pallet: state.pallets {
        if (
            pallet.position.x < state.ball.position.x + state.ball.size
            && pallet.position.x + pallet.size.x > state.ball.position.x
            && pallet.position.y < state.ball.position.y + state.ball.size
            && pallet.position.y + pallet.size.y > state.ball.position.y
        ) {
            state.ball.position.x = ifx it_index == 0 {
                pallet.position.x + pallet.size.x + 1;
            } else {
                pallet.position.x - 1 - state.ball.size;
            }
            state.ball.velocity.x *= -1;
        }
    }

    // Collide with walls
    hit_top_wall := state.ball.position.y >= WINDOW_HEIGHT;
    hit_bottom_wall := state.ball.position.y <= 0;
    if (hit_top_wall || hit_bottom_wall) {
        state.ball.velocity.y *= -1;
    }
    if test_ball_against_left_wall() || test_ball_against_right_wall() {
        state.ball.velocity.x *= -1;
    }

    state.ball.position += state.ball.velocity * DUMMY_DELTA_TIME;
}

update_score :: () {
    if test_ball_against_left_wall() {
        state.pallets[1].score += 1;
    }

    if test_ball_against_right_wall() {
        state.pallets[0].score += 1;
    }
}

launch_ball :: () {
    random_seed(current_time_monotonic().low);

    state.ball.velocity = .{
        state.ball.speed * ifx random_get_zero_to_one() > 0.5 then -1 else 1,
        state.ball.speed * ifx random_get_zero_to_one() > 0.5 then -1 else 1,
    };
}

test_ball_against_left_wall :: () -> bool {
    return state.ball.position.x <= 0;
}

test_ball_against_right_wall :: () -> bool {
    return state.ball.position.x >= WINDOW_WIDTH;
}
