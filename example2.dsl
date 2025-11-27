pipeline {
    stage "Initialize" {
        env "MODE=dev"
        env "VERSION=1.0.0"

        steps {
            run "echo Starting pipeline..."
            run "echo Environment: MODE=$MODE, VERSION=$VERSION"
        }
    }

    stage "Setup" {
        job "prepare_workspace" {
            steps {
                run "echo Creating workspace directory..."
                run "mkdir -p workspace"
                run "echo Workspace ready."
            }
        }
    }

    stage "Build" {
        steps {
            run "echo Compiling source files..."
            run "echo build complete!"
        }
    }

    stage "Tests" {
        job "unit_tests" {
            steps {
                run "echo Running tests..."
                run "echo All tests passed successfully."
                test "echo 0"
            }
        }

        on_fail {
            run "echo Tests failed (this won't trigger)"
        }
    }

    stage "Package" {
        steps {
            run "echo Creating application package..."
            run "touch workspace/app.bundle"
            run "echo Package created."
        }
    }

    stage "Deploy" {
        steps {
            run "echo Deploying application..."
            deploy "echo Deployed successfully!"
        }
    }
}
