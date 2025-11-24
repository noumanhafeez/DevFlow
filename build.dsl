pipeline {
    stage "Build" {
        steps {
            run "echo Building app"
            make "all"
        }
    }

    stage "Test" {
        steps {
            test "echo test OK"
            test "exit 1"
        }
    }
}
