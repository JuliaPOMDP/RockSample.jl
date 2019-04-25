using Revise
using Random
using POMDPs
using POMDPSimulators
using POMDPGifs
using RockSample
using Cairo
using SARSOP

rng = MersenneTwister(1)
pomdp = RockSamplePOMDP{3}(rocks_positions=[(2,3), (4,4), (4,2)], 
                           sensor_efficiency=20.0,
                           discount_factor=0.95, 
                           good_rock_reward = 20.0)

solver = SARSOPSolver(precision=1e-3)

policy = solve(solver, pomdp)

sim = GifSimulator(filename="test.gif", max_steps=30)
simulate(sim, pomdp, policy)

hr = HistoryRecorder(max_steps=50)
hist = simulate(hr, pomdp, policy, up)

makegif(pomdp, hist, filename="test.gif", spec="(s,a)")



