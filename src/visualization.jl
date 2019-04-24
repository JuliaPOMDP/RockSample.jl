
function POMDPModelTools.render(pomdp::RockSamplePOMDP, step::Union{NamedTuple, Dict})
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
    for (rx,ry) in pomdp.rocks_positions
        ctx = cell_ctx((rx,ry), (nx,ny))
        rock = compose(ctx, ngon(0.5, 0.5, 0.3, 6), stroke("black"), fill("gray"))
        push!(rocks, rock)
    end
    rocks = compose(context(), rocks...)
    exit_area = render_exit((nx,ny))

    if haskey(step, :s)
        agent_ctx = cell_ctx(step[:s], (nx,ny))
        agent = render_agent(agent_ctx)
    else
        agent = nothing
    end
    
    sz = min(w,h)
    return compose(context((w-sz)/2, (h-sz)/2, sz, sz), agent, exit_area, rocks, grid, outline)
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
    center = compose(context(), circle(0.5, 0.5, 0.3), fill("orange"))
    lwheel = compose(context(), ellipse(0.2,0.5,0.1,0.3), fill("orange"))
    rwheel = compose(context(), ellipse(0.8,0.5,0.1,0.3), fill("orange"))
    return compose(ctx, center, lwheel, rwheel)
end