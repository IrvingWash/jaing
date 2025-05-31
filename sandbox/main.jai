#import "Basic";

main :: () {
    print("%\n", square(3.5));
    print("%\n", square(3.5));
    print("%\n", square(2));
    print("%\n", square(3.5));
}

square :: ($$number: $T) -> T
#modify {
    ti := cast(*Type_Info) T;

    return ifx ti.type != .INTEGER || ti.type != .FLOAT;
}
{
    do_square :: x => x * x;

    #if is_constant(number) {
        result := #run -> T {
            print("running `square` for %\n", number);

            return do_square(number);
        }

        return result;
    }

    return do_square(number);
}
