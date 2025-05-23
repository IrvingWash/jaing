#import "Basic";

Person :: struct (custom_age: u64) {
    age := custom_age;
    name: string;
}

main :: () {
    man := Person(31).{name = "Man"};

    person_age_up(*man);

    print("%\n", man.age);

    print("%\n", add(5.23, 3.32));
}

person_age_up :: (person: *Person) {
    person.age += 1;
}

add :: (a: $T, b: T) -> T {
    return a + b;
}
