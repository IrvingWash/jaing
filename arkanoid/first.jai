BUILD_DIR :: "build";
DEBUG_BUILD_DIR :: "build/debug";
RELEASE_BUILD_DIR :: "build/release";

EXECUTABLE_NAME :: "Arkanoid";

Args :: struct {
    should_clean: bool;
    should_build: bool;
    should_run: bool;
    is_debug: bool;
    is_release: bool;
}

#run {
    Compiler.set_build_options_dc(.{ do_output = false });

    args := args_init();

    if args.should_clean {
        clean();
    }

    if args.should_build {
        build(args);
    }

    if args.should_run {
        run(args);
    }

    reset_temporary_storage();
};

args_init :: () -> Args {
    args := Compiler.get_build_options().compile_time_command_line;

    is_release := array_find(args, "release");
    is_debug := array_find(args, "debug");

    if is_release && is_debug {
        compiler_report("Attempt to use release and a debug modes simultaneously");
    }

    if !is_release && !is_debug {
        compiler_report("Neither debug nor release mods were specified. Using debug mode", mode = .WARNING);

        is_debug = true;
    }

    return .{
        should_clean = array_find(args, "clean"),
        should_build = array_find(args, "build"),
        should_run = array_find(args, "run"),
        is_release = is_release,
        is_debug = is_debug,
    };
}

clean :: () {
    File.delete_directory(BUILD_DIR);
}

build :: (args: Args) {
    w := compiler_create_workspace("Executable");

    options := Compiler.get_build_options(w);

    if args.is_debug {
        File.make_directory_if_it_does_not_exist(DEBUG_BUILD_DIR, recursive = true);

        options.output_executable_name = EXECUTABLE_NAME;
        options.output_path = DEBUG_BUILD_DIR;
        options.intermediate_path = DEBUG_BUILD_DIR;

        Compiler.set_optimization(*options, .DEBUG);
    } else if args.is_release {
        File.make_directory_if_it_does_not_exist(RELEASE_BUILD_DIR, recursive = true);

        options.output_executable_name = EXECUTABLE_NAME;
        options.output_path = RELEASE_BUILD_DIR;
        options.intermediate_path = RELEASE_BUILD_DIR;

        Compiler.set_optimization(*options, .VERY_OPTIMIZED);
    }

    Compiler.set_build_options(options, w);

    Compiler.add_build_file("src/main.jai", w);
}

run :: (args: Args) {
    if args.is_debug {
        Process.run_command(tprint("./%/%", DEBUG_BUILD_DIR, EXECUTABLE_NAME));
        return;
    }

    if args.is_release {
        Process.run_command(tprint("./%/%", RELEASE_BUILD_DIR, EXECUTABLE_NAME));
        return;
    }
}

using,only(compiler_report, compiler_create_workspace) Compiler :: #import "Compiler";
#import "Basic";
File :: #import "File";
Process :: #import "Process";
