#scope_file;

#import "Math";
#import,file "paddle.jai";
Simp :: #import "Simp";
Input :: #import "Input";

BALL_SIZE :: 20;

#scope_export;

Ball :: struct {
    using position: Vector2;
    size: u32;
    speed: float = 500;
    velocity: Vector2;
    pg_width: u32;
    pg_height: u32;
    is_attached: bool;
    paddle: *Paddle;
}

ball_init :: (paddle: *Paddle, pg_width: u32, pg_height: u32) -> Ball {
    return .{
        position = .{
            pg_width / 2 - cast(float) (BALL_SIZE / 2),
            paddle.position.y + BALL_SIZE,
        },
        size = BALL_SIZE,
        pg_width = pg_width,
        pg_height = pg_height,
        is_attached = true,
        paddle = paddle,
    };
}

ball_update :: (ball: *Ball, paddle: Paddle, dt: float) {
    for event: Input.events_this_frame {
        if event.type == .KEYBOARD {
            if event.key_pressed && event.key_code == .SPACEBAR {
                ball.is_attached = false;
                ball.velocity = .{ball.speed, ball.speed};
            }
        }
    }

    ball_move(ball, paddle, dt);
}

ball_draw :: (ball: Ball) {
    using ball;

    Simp.immediate_quad(
        position.x,
        position.y,
        position.x + size,
        position.y + size,
        .{0, 0, 1, 1}
    );
}

#scope_file;

ball_move :: (ball: *Ball, paddle: Paddle, dt: float) {
    if ball.is_attached {
        ball.position.x = paddle.position.x + paddle.size.x / 2 - ball.size / 2;

        return;
    }

    if ball.position.x <= 0 || ball.position.x >= xx ball.pg_width {
        ball.velocity.x *= -1;
    }
    if ball.position.y <= 0 || ball.position.y >= xx ball.pg_height {
        ball.velocity.y *= -1;
    }

    if (
        paddle.position.x < ball.position.x + ball.size
        && paddle.position.x + paddle.size.x > ball.position.x
        && paddle.position.y < ball.position.y + ball.size
        && paddle.position.y + paddle.size.y > ball.position.y
    ) {
        ball.velocity.y *= -1;
    }

    ball.position += ball.velocity * dt;
}
