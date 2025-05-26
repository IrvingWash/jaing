#scope_file;

#import "Math";
Simp :: #import "Simp";

#scope_export;

Brick :: struct {
    position: Vector2;
    size: Vector2;
    is_destroyed: bool = true;
}

brick_init :: (position: Vector2, size: Vector2) -> Brick {
    return .{position = position, size = size};
}

brick_draw :: (brick: Brick) {
    using brick;

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
