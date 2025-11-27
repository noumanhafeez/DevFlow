pipeline {
    stage "Initialize" {
        env "ENV=staging"
        env "APP_NAME=WebPortal"

        steps {
            run "echo Initializing pipeline for $APP_NAME..."
            run "echo Environment set to $ENV"
        }
    }

    stage "Preparation" {
        job "clean_old_builds" {
            steps {
                run "echo Cleaning old build files..."
                run "rm -rf build_output"
                run "mkdir -p build_output"
                run "echo Clean workspace ready."
            }
        }
    }

    stage "Build" {
        steps {
            run "echo Starting mock build process..."
            run "echo creating build files..."
            run "touch build_output/index.html"
            run "touch build_output/main.css"
            run "touch build_output/app.js"
            run "echo Build artifacts created."
        }
    }

    stage "Tests" {
        job "sanity_tests" {
            steps {
                run "echo Running sanity checks..."
                run "echo All basic tests passed."
                test "echo 0"
            }
        }

        on_fail {
            run "echo TESTS FAILED — stopping!"
        }
    }

    stage "Deploy" {
        steps {
            run "echo Deploying build to staging server..."
            deploy "echo Deployment complete!"
        }
    }
}
