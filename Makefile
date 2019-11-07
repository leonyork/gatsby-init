# Build the dev container
.dev-build:
	docker-compose -f docker-compose-dev.yml build

# Command used to create the project initially. Creates a new project and moves it into the current directory
# You should update the project name and the starter
.init: .dev-build
	docker-compose -f docker-compose-dev.yml run dev /bin/sh -c "gatsby new leonyork-com https://github.com/tinacms/gatsby-starter-tinacms && cp -rdf leonyork-com . && rm -rdf leonyork-com"

# Run the project in development mode - i.e. hot reloading as you change the code.
.dev: .dev-build
	docker-compose -f docker-compose-dev.yml up

# sh into the dev container - useful for debugging
.dev-sh: .dev-build
	docker-compose -f docker-compose-dev.yml run dev /bin/sh

# Run the full build
build:
	docker-compose build

# Run the application as it would run in prod
.prod: build
	docker-compose up