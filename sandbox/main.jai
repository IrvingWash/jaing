#import "Basic";

main :: () {
    Foo :: struct {
        bar: u64;
        baz: string;
    }

    foo: Foo;

    // Не скопирутеся, но синтаксис как будто просто по значение передаём.
    // То же, что fn print_foo(foo: &Foo) в расте.
    print_foo(foo);

    // передаём поинтер чтобы иметь возможность мутировать
    mutate_foo(*foo);
}

print_foo :: (foo: Foo) {
    print("%", foo);
}

mutate_foo :: (foo: *Foo) {
    foo.bar += 1;
}
