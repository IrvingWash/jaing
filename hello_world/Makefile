.PHONY: build

output_path = ./.build

build:
	@mkdir -p $(output_path)
	jai-linux ./main.jai -output_path $(output_path)

start: build
	./$(output_path)/main

clean:
	@rm -rf ./build
