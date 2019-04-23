const N_OBSERVATIONS = 5
const OBSERVATION_NAME = SVector(:good, :bad, :none)

POMDPs.n_observations(pomdp::RockSameplPOMDP) = 3
POMDPs.observations(pomdp::RockSameplPOMDP) = 1:3