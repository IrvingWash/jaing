Basic :: #import "Basic";
Random :: #import "Random";
Posix :: #import "POSIX";

State :: struct {
    target: u8;
    attempt: u8 = 1;
}

main :: () {
    Basic.print("Guessing Game\n");

    run();
}

run :: () {
    state := state_init();

    while true {
        Basic.print("Your guess: [Attempt: %]\n", state.attempt);

        guess: u8 = xx Basic.to_integer(read_line());

        if guess == state.target {
            Basic.print("You won in % attempts!\n", state.attempt);

            break;
        }

        defer state.attempt += 1;

        if guess < state.target {
            Basic.print("Too low\n");

            continue;
        }

        if guess > state.target {
            Basic.print("Too high\n");

            continue;
        }
    }
}

state_init :: () -> State {
    Random.random_seed(cast,force(Random.Some_Big_Time_Value) Basic.current_time_monotonic());

    return .{
        target = xx Random.random_get_within_range(1, 100),
    };
}

read_line :: () -> string {
    buffer: [4096]u8;

    bytes := Posix.read(Posix.STDIN_FILENO, buffer.data, buffer.count - 1);

    return Basic.sprint("%", Basic.to_string(buffer.data, bytes));
}
