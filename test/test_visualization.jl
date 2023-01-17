pomdp = RockSamplePOMDP{3}()

rng = MersenneTwister(2)
b0 = initialstate(pomdp)
s0 = rand(b0)

c = render(pomdp, (s=s0, a=6, b=b0))

c |> SVG("rocksample.svg")
