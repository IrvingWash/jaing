.PHONY: build

output_path = .build

####################################################################
# hello_world
####################################################################
hello_world_path = hello_world
hello_world_build_path = $(hello_world_path)/$(output_path)
build_hello_world:
	@jai $(hello_world_path)/main.jai -output_path $(output_path)
start_hello_world: build_hello_world
	@./$(hello_world_build_path)/main
clean_hello_world:
	@rm -rf $(hello_world_build_path)

####################################################################
# guessing_game
####################################################################
guessing_game_path = guessing_game
guessing_game_build_path = $(guessing_game_path)/$(output_path)
build_guessing_game:
	@jai $(guessing_game_path)/main.jai -output_path $(output_path)
start_guessing_game: build_guessing_game
	@./$(guessing_game_build_path)/main
clean_guessing_game:
	@rm -rf $(guessing_game_build_path)

####################################################################
# misc
####################################################################
misc_path = misc
misc_build_path = $(misc_path)/$(output_path)
build_misc:
	@jai $(misc_path)/main.jai -output_path $(output_path)
start_misc: build_misc
	@./$(misc_build_path)/main
clean_misc:
	@rm -rf $(misc_build_path)
