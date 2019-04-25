using Revise
using POMDPs
using POMDPModelTools
using RockSample
using Random
using Compose

pomdp = RockSamplePOMDP{3}()

rng = MersenneTwister(2)
s0 = initialstate(pomdp, rng)

render(pomdp, (s=s0, a=6))

c = render(pomdp, Dict(:s=>(2,2)))


c |> SVG("rocksample.svg")