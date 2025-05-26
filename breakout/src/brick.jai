#scope_file;

#import "Math";
Simp :: #import "Simp";
#import,file "ball.jai";

#scope_export;

Brick :: struct {
    position: Vector2;
    size: Vector2;
    is_destroyed: bool;
}

brick_init :: (position: Vector2, size: Vector2) -> Brick {
    return .{
        position = position,
        size = size,
    };
}

brick_update :: (brick: *Brick, ball: *Ball) {
    using brick;

    if is_destroyed return;

    if (
        position.x < ball.position.x + ball.size
        && position.x + size.x > ball.position.x
        && position.y < ball.position.y + ball.size
        && position.y + size.y > ball.position.y
    ) {
        is_destroyed = true;
        ball.velocity.y *= -1;
    }
}

brick_draw :: (brick: Brick) {
    using brick;

    if is_destroyed return;

    Simp.immediate_quad(
        position.x,
        position.y,
        position.x + size.x,
        position.y + size.y,
        .{0, 0, 0, 1}
    );
    Simp.immediate_quad(
        position.x + 1,
        position.y + 1,
        position.x + (size.x - 1),
        position.y + (size.y - 1),
        .{0, 1, 0, 1}
    );
}
