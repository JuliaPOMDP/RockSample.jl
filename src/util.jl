function rs_util(m::RockSamplePOMDP)
    util = zeros(length(states(m)))
    K = length(m.rocks_positions)
    discounts = discount(m) .^ (0:(m.map_size[1]+m.map_size[2]-2))

    rocks = falses(K)
    for x in 1:m.map_size[1]
        exit_return = discounts[m.map_size[1] - x + 1] * m.exit_reward
        for y in 1:m.map_size[2]
            util[stateindex(m, RSState(RSPos(x,y), SVector{K,Bool}(rocks)))] = exit_return
        end
    end

    for good_rock_num in 1:K
        for good_rocks in combinations(1:K, good_rock_num)
            rocks = falses(K)
            for good_rock in good_rocks
                rocks[good_rock] = true
            end
            for x in 1:m.map_size[1]
                exit_return = discounts[m.map_size[1] - x + 1] * m.exit_reward
                for y in 1:m.map_size[2]
                    best_return = exit_return
                    for good_rock in good_rocks
                        dist_to_good_rock = abs(x - m.rocks_positions[good_rock][1]) + abs(y - m.rocks_positions[good_rock][2])
                        rocks[good_rock] = false
                        sample_return = discounts[dist_to_good_rock+1] * (m.good_rock_reward + discounts[2] * util[stateindex(m, RSState(m.rocks_positions[good_rock], SVector{K,Bool}(rocks)))])
                        rocks[good_rock] = true
                        if sample_return > best_return
                            best_return = sample_return
                        end
                    end
                    util[stateindex(m, RSState(RSPos(x,y), SVector{K,Bool}(rocks)))] = best_return
                end
            end
        end
    end

    return util
end