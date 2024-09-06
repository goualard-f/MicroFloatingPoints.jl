using Test
using MicroFloatingPoints

MicroFloatingPoints.reset_inexact()
task_A = Threads.@spawn begin
    sleep(0.2)
    MicroFloatingPoints.set_inexact_or(true)
    sleep(0.3)
    MicroFloatingPoints.inexact()
end
task_B = Threads.@spawn begin
    inexact_seen = false
    for i in 0.1:0.1:0.5
        @info "Task B, $i sec:" MicroFloatingPoints.inexact()
        if MicroFloatingPoints.inexact()
            inexact_seen = true
            MicroFloatingPoints.reset_inexact()
        end
        sleep(0.1)
    end
    inexact_seen
end
wait(task_A)
wait(task_B)
@test fetch(task_A)
@test !fetch(task_B)
