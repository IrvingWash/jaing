Pallet :: struct {
    size: Vector2 = .{15, 80};
    position: Vector2;
    speed: float = 200;
    velocity: Vector2;
    score: u64;
}

move_pallets :: (delta_time: float64) {
    for * pallet: state.pallets {
        if pallet.velocity.y > 0 && pallet.position.y <= WINDOW_HEIGHT - pallet.size.y {
            pallet.position += pallet.velocity * cast(float) delta_time;
        }

        if pallet.velocity.y < 0 && pallet.position.y >= 0 {
            pallet.position += pallet.velocity * cast(float) delta_time;
        }
    }
}
