pipeline {
    stage "Build Stage" {
        env "API_KEY=123456"

        job "compile" {
            steps {
                run "echo compiling..."
                make "all"
            }
        }

        steps {
            test "echo build tests OK"
        }

        on_fail {
            run "echo build failed!"
        }
    }

    stage "Deployment" {
        steps {
            deploy "sh deploy.sh"
        }
    }
}
