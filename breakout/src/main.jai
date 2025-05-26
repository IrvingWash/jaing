#import "Basic"()(MEMORY_DEBUGGER = true);
#import "Math";
#import "Window_Creation";
Simp :: #import "Simp";
Input :: #import "Input";

#import,file "paddle.jai";
#import,file "ball.jai";
#import,file "brick.jai";

WINDOW_WIDTH :: 800;
WINDOW_HEIGHT :: 600;
TARGET_FPS :: 60;
TARGET_DELTA_TIME: float : 1.0 / TARGET_FPS;
MAX_DELTA_TIME :: TARGET_DELTA_TIME * 2.0;
BRICK_COLUMNS :: 10;
BRICK_ROWS :: 5;
BRICK_WIDTH :: WINDOW_WIDTH / BRICK_COLUMNS;
BRICK_HEIGHT :: 100 / BRICK_ROWS;

State :: struct {
    is_running: bool;
    window: Window_Type;
    last_time: float64;
    paddle: *Paddle;
    ball: *Ball;
    bricks: [..]*Brick;
}

state: State = ---;

main :: () {
    setup();
    run();
    destroy();
}

setup :: () {
    window := create_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Breakout");
    Simp.set_render_target(window);
    Simp.set_shader_for_color();

    state = .{
        is_running = true,
        window = window,
        last_time = seconds_since_init(),
        paddle = New(Paddle),
        ball = New(Ball),
    };

    state.paddle.* = paddle_init(WINDOW_WIDTH);
    state.ball.* = ball_init(state.paddle, WINDOW_WIDTH, WINDOW_HEIGHT);

    for i: 0..BRICK_COLUMNS - 1 {
        for j: 0..BRICK_ROWS - 1 {
            brick := New(Brick);
            brick.* = brick_init(
                .{xx (i * BRICK_WIDTH), xx (WINDOW_HEIGHT - j * BRICK_HEIGHT - 30)},
                .{xx BRICK_WIDTH, xx BRICK_HEIGHT}
            );

            array_add(*state.bricks, brick);
        }
    }
}

run :: () {
    while state.is_running {
        dt := cap_frame_rate();

        get_input();
        update(dt);
        render();
    }
}

destroy :: () {
    array_free(state.bricks);
    free(state.ball);
    free(state.paddle);
}

cap_frame_rate :: () -> float {
    time_to_wait := TARGET_DELTA_TIME - (seconds_since_init() - state.last_time);
    if time_to_wait > 0 && time_to_wait <= TARGET_DELTA_TIME {
        sleep_milliseconds(cast(s32) (time_to_wait * 1000.0));
    }

    now := seconds_since_init();
    dt := now - state.last_time;
    if dt > MAX_DELTA_TIME {
        dt = MAX_DELTA_TIME;
    }

    state.last_time = now;

    return xx dt;
}

get_input :: () {
    Input.update_window_events();

    for event: Input.events_this_frame {
        if event.type == {
            case .QUIT;
                state.is_running = false;
        }
    }
}

update :: (dt: float) {
    paddle_update(state.paddle, dt);
    ball_update(state.ball, state.paddle, dt);
}

render :: () {
    Simp.clear_render_target(1, 1, 1, 1);
    Simp.immediate_begin();

    paddle_draw(state.paddle);
    ball_draw(state.ball);

    for brick: state.bricks {
        brick_draw(brick);
    }

    Simp.immediate_flush();
    Simp.swap_buffers(state.window);
}
