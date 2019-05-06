module PitchjxPlot

export
    veloplot_by_pitch,
    heatmapplot,
    movementplot,
    vmove_velo_plot

using Pitchjx
using Plots

include(joinpath(dirname(@__FILE__), "utils.jl"))
include(joinpath(dirname(@__FILE__), "velo.jl"))
include(joinpath(dirname(@__FILE__), "heatmap.jl"))
include(joinpath(dirname(@__FILE__), "movement.jl"))

end # module
