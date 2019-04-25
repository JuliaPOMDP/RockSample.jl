function POMDPModelTools.render(pomdp::RockSamplePOMDP, step;
                                viz_rock_state=true)
    nx, ny = pomdp.map_size[1] + 1, pomdp.map_size[2] 
    cells = []
    for x in 1:nx-1, y in 1:ny
        ctx = cell_ctx((x,y), (nx,ny))
        cell = compose(ctx, rectangle(), fill("white"))
        push!(cells, cell)
    end
    grid = compose(context(), linewidth(0.5mm), stroke("gray"), cells...)
    outline = compose(context(), linewidth(1mm), rectangle())

    rocks = []
    for (i,(rx,ry)) in enumerate(pomdp.rocks_positions)
        ctx = cell_ctx((rx,ry), (nx,ny))
        clr = "black"
        if viz_rock_state && get(step, :s, nothing) != nothing
            clr = step[:s].rocks[i] ? "green" : "red"
        end
        rock = compose(ctx, ngon(0.5, 0.5, 0.3, 6), stroke(clr), fill("gray"))
        push!(rocks, rock)
    end
    rocks = compose(context(), rocks...)
    exit_area = render_exit((nx,ny))

    if get(step, :s, nothing) != nothing
        agent_ctx = cell_ctx(step[:s].pos, (nx,ny))
        agent = render_agent(agent_ctx)       
        if get(step, :a, nothing) != nothing 
            action = render_action(pomdp, step)
        end
    else
        agent = nothing
        action = nothing
    end

    sz = min(w,h)
    if action != nothing && step.a == BASIC_ACTIONS_DICT[:sample]
        return compose(context((w-sz)/2, (h-sz)/2, sz, sz), action, agent, exit_area, rocks, grid, outline)
    end
    return compose(context((w-sz)/2, (h-sz)/2, sz, sz), agent, exit_area, rocks, action, grid, outline)
end

function cell_ctx(xy, size)
    nx, ny = size
    x, y = xy
    return context((x-1)/nx, (ny-y)/ny, 1/nx, 1/ny)
end

function render_exit(size)
    nx, ny = size
    x = nx 
    y = ny
    ctx = context((x-1)/nx, (ny - y)/ny, 1/nx, 1) 
    rot = Rotation(pi/2, 0.5, 0.5)
    txt = compose(ctx, text(0.5,0.5, "EXIT AREA", hcenter, vtop, rot), 
                       stroke("black"),
                       fill("black"),
                       fontsize(20pt))   
    return compose(ctx, txt, rectangle(), fill("red"))
end

function render_agent(ctx)
    center = compose(context(), circle(0.5, 0.5, 0.3), fill("orange"), stroke("black"))
    lwheel = compose(context(), ellipse(0.2,0.5,0.1,0.3), fill("orange"), stroke("black"))
    rwheel = compose(context(), ellipse(0.8,0.5,0.1,0.3), fill("orange"), stroke("black"))
    return compose(ctx, center, lwheel, rwheel)
end

function render_action(pomdp::RockSamplePOMDP, step)
    if step.a == BASIC_ACTIONS_DICT[:sample]
        ctx = cell_ctx(step.s.pos, pomdp.map_size)
        if in(step.s.pos, pomdp.rocks_positions)
            rock_ind = findfirst(isequal(step.s.pos), pomdp.rocks_positions)
            clr = step.s.rocks[rock_ind] ? "green" : "red"
        else
            clr = "black"
        end
        return compose(ctx, ngon(0.44, 0.5, 0.1, 6), stroke("gray"), fill(clr))
    elseif step.a > N_BASIC_ACTIONS
        rock_ind = step.a - N_BASIC_ACTIONS
        rock_pos = pomdp.rocks_positions[rock_ind]
        nx, ny = pomdp.map_size
        rock_pos = ((rock_pos[1] - 1)/nx, (ny - rock_pos[2])/ny + 0.5/ny)
        rob_pos = ((step.s.pos[1] - 1)/nx, (ny - step.s.pos[2])/ny + 0.5/ny)
        sz = min(w,h)
        return compose(context((w-sz)/2, (h-sz)/2, sz, sz), line([rob_pos, rock_pos]), stroke("orange"), linewidth(0.01w))
    end
    return nothing
end