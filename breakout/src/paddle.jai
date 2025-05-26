#scope_file;

#import "Math";
Simp :: #import "Simp";
Input :: #import "Input";


PADDLE_SIZE :: Vector2.{100, 20};

#scope_export;

Paddle :: struct {
    using position: Vector2;
    size: Vector2;
    speed: float = 700;
    velocity: Vector2;
    pg_width: u32;
}

paddle_init :: (pg_width: u32) -> Paddle {
    return .{
        position = .{
            pg_width / 2 - PADDLE_SIZE.x / 2,
            PADDLE_SIZE.y * 2,
        },
        size = PADDLE_SIZE,
        pg_width = pg_width,
    };
}

paddle_update :: (paddle: *Paddle, dt: float) {
    using paddle;

    for event: Input.events_this_frame {
        if event.type == .KEYBOARD {
            if event.key_pressed {
                if event.key_code == {
                    case .ARROW_LEFT;
                        velocity.x = -speed;
                    case .ARROW_RIGHT;
                        velocity.x = speed;
                }
            } else {
                velocity.x = 0;
            }
        }
    }

    paddle_move(paddle, dt);
}

paddle_draw :: (paddle: Paddle) {
    using paddle;

    Simp.immediate_quad(
        position.x,
        position.y,
        position.x + size.x,
        position.y + size.y,
        .{1, 0, 0, 1}
    );
}

#scope_file

paddle_move :: (paddle: *Paddle, dt: float) {
    using paddle;

    if (
        position.x <= 0 && velocity.x < 0
        || position.x + size.x >= xx pg_width && velocity.x > 0
    )
        return;

    position += velocity * dt;
}
