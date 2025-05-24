Bullet :: struct {
    position: Vector2;
    size: Vector2 = .{10, 10};
    speed: float = 100;
    color: Vector4 = .{255, 0, 0, 255};
}

bullet_update :: (bullet: *Bullet, dt: float) {
    bullet.position.y += bullet.speed * dt;
}
