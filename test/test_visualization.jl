pomdp = RockSamplePOMDP{3}()
function test_initial_state()
	rng = MersenneTwister(2)
	s0 = rand(rng, initialstate(pomdp))
	
	c = render(pomdp, (s=s0, a=6))
    c = render(pomdp, (s=s0, a=6, b=Deterministic(s0)))
    c = render(pomdp, (s=s0, a=6, b=initialstate(pomdp)))
	c |> SVG("rocksample.svg")
end

function test_particle_collection()
    b0 = ParticleCollection{RSState{3}}(
            RSState{3}[
                RSState{3}([1, 1], Bool[1, 0, 0]), RSState{3}([1, 1], Bool[1, 1, 1]), 
                RSState{3}([1, 1], Bool[0, 0, 1]), RSState{3}([1, 1], Bool[1, 0, 1]), 
                RSState{3}([1, 1], Bool[1, 0, 0]), RSState{3}([1, 1], Bool[1, 1, 0]), 
                RSState{3}([1, 1], Bool[0, 1, 0]), RSState{3}([1, 1], Bool[1, 1, 0]), 
                RSState{3}([1, 1], Bool[1, 0, 1]), RSState{3}([1, 1], Bool[0, 1, 1]),
                RSState{3}([1, 1], Bool[0, 0, 1]), RSState{3}([1, 1], Bool[1, 0, 0]), 
                RSState{3}([1, 1], Bool[1, 0, 1]), RSState{3}([1, 1], Bool[0, 1, 1]), 
                RSState{3}([1, 1], Bool[0, 1, 1]), RSState{3}([1, 1], Bool[1, 1, 0]), 
                RSState{3}([1, 1], Bool[1, 1, 1]), RSState{3}([1, 1], Bool[0, 0, 1]), 
                RSState{3}([1, 1], Bool[1, 1, 1]), RSState{3}([1, 1], Bool[1, 0, 1])
            ], 
            nothing
        )
    s0 = rand(b0)
    c = render(pomdp, (s=s0, a=6, b=b0))
    c |> SVG("rocksample2.svg")
end
