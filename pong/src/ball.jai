Ball :: struct {
    size: float = 15;
    position: Vector2;
    velocity: Vector2;
    speed: float = 300;
}

launch_ball :: () {
    random_seed(cast,force(Some_Big_Time_Value) current_time_monotonic());

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

move_ball :: (delta_time: float64) {
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

    state.ball.position += state.ball.velocity * cast(float) delta_time;
}
