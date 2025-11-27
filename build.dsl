pipeline {
    stage "Setup" {
        env "REGION=us-east-1"
        env "VERSION=1.4.2"

        steps {
            run "echo setting up environment vars..."
        }
    }

    stage "Quality Checks" {
        job "lint" {
            steps {
                run "echo running linter..."
                run "eslint ."
            }
        }

        job "security_scan" {
            steps {
                run "echo scanning for vulnerabilities..."
                run "snyk test"
            }
        }

        on_fail {
            run "echo SECURITY OR LINT FAILED — stopping pipeline."
        }
    }

    stage "Build" {
        steps {
            make "build"
        }
    }

    stage "Release" {
        steps {
            deploy "sh deploy_prod.sh"
        }
    }
}
