struct RSExitSolver <: Solver end
struct RSExit <: Policy
    exit_return::Vector{Float64}
end
POMDPs.solve(::RSExitSolver, m::RockSamplePOMDP) = RSExit([discount(m)^(m.map_size[1]-x) * m.exit_reward for x in 1:m.map_size[1]])
POMDPs.solve(solver::RSExitSolver, m::UnderlyingMDP{P}) where P <: RockSamplePOMDP = solve(solver, m.pomdp)
POMDPs.value(p::RSExit, s::RSState) = s.pos[1] == -1 ? 0.0 : p.exit_return[s.pos[1]]

function POMDPs.value(p::RSExit, b::AbstractParticleBelief)
    utility = 0.0
    for (i, s) in enumerate(particles(b))
        if s.pos[1] != -1
            utility += weight(b, i) * p.exit_return[s.pos[1]]
        end
    end
    return utility / weight_sum(b)
end
POMDPs.action(p::RSExit, b) = 2