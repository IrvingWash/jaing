#import "Math";
#load "bullet.jai";

#scope_module;

Player :: struct {
    position: Vector2;
    speed: float = 1000;
    color: Vector4 = .{0, 0, 255, 255};
    size: Vector2 = .{60, 100};
}

player_update :: (player: *Player, dt: float, bullet_container: *[..]Bullet) {
    for event: Input.events_this_frame {
        if event.type == .KEYBOARD {
            disposition := player.speed * dt;

            if event.key_code == .ARROW_UP {
                player.position.y += disposition;
            }
            if event.key_code == .ARROW_DOWN {
                player.position.y -= disposition;
            }
            if event.key_code == .ARROW_LEFT {
                player.position.x -= disposition;
            }
            if event.key_code == .ARROW_RIGHT {
                player.position.x += disposition;
            }
            print("%\n", Input.input_button_states[13]);
            if event.key_code == .ENTER && Input.input_button_states[13] == .END {
                array_add(bullet_container, bullet_spawn(player));
            }
        }
    }
}
