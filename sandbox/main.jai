#import "Basic";

#no_reset some_glob := 0;

main :: () {
    print("%\n", square(3.5));
    print("%\n", square(3.5));
    print("%\n", square(2));
    print("%\n", square(3.5));
    #if false print("%\n", square("Sailor"));
}

square :: ($$number: $T) -> T
#modify {
    ti := cast(*Type_Info) T;

    return ti.type == .INTEGER || ti.type == .FLOAT, "T should be a number";
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

println :: (format_string: string, args: .. Any) {
    builder: String_Builder;
    print(*builder, format_string, ..args);
    s := builder_to_string(*builder);

    write_strings(s, "\n");
}
