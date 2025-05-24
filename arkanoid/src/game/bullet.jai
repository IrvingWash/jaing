Bullet :: struct {
    position: Vector2;
    size: Vector2 = .{30, 30};
    speed: float = 10;
    color: Vector4 = .{255, 0, 0, 255};
}

bullet_spawn :: (player: Player) -> Bullet {
    bullet: Bullet;

    bullet.position = .{
        x = player.position.x + player.size.x / 2 - bullet.size.x / 2,
        y = player.position.y,
    };

    return bullet;
}

bullet_update :: (bullet: *Bullet, dt: float) {
    bullet.position.y += bullet.speed * dt;
}
