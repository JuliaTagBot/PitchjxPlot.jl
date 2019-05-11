"""
Generate movement scatter.

## Params

- start: start date to get data.
- fin: finish date to get data. Default is same of `start` value.
- per: unit to plot graph. player or team. Default is `player`.
- firstname: pitcher's firstname. It must be given if you choose `player` at `per` parameter.
- lastname: pitcher's lastname. It must be given if you choose `player` at `per` parameter.
- teamname: team name. It must be given if you choose `team` at `per` parameter.
- isbypitchtype: Boolean whether separate line by pitch type or not. Default is `false`.

## Return

- `Plots` object.

## Usages
"""
function movementplot(data; per="player", firstname=nothing, lastname=nothing, teamname=nothing)
    # parameter check
    checkparam(per, firstname, lastname, teamname)
    # execute
    if per == "player"
        return movementplot_by_player(data, start, fin, firstname, lastname)
    else
        return movementplot_by_team(data, start, fin, teamname)
    end
end

function movementplot_by_player(data, start, fin, firstname, lastname)
    target = data[(data.pitcher_firstname .== firstname) .& (data.pitcher_lastname .== lastname), :]
    # convert velocity to Float64
    target[:pfxx] = parse.(Float64, target[:pfxx])
    target[:pfxz] = parse.(Float64, target[:pfxz])
    p = plot(
        xlims=(-20,20), ylims=(-20,20), title="$start to $fin: $firstname $lastname",
        xlabel="Horizon Movement", ylabel="Vertical Movement"
    )
    plotmovement(target)
    return p
end

function movementplot_by_team(data, start, fin, teamname)
    target = data[data.pitcher_teamname .== teamname, :]
    # convert velocity to Float64
    target[:pfxx] = parse.(Float64, target[:pfxx])
    target[:pfxz] = parse.(Float64, target[:pfxz])
    p = plot(
        xlims=(-20,20), ylims=(-20,20), title="$start to $fin: $teamname",
        xlabel="Horizon Movement", ylabel="Vertical Movement"
    )
    plotmovement(target)
    return p
end

function plotmovement(target)
    pitchtypes = unique(target.pitchtype)
    for pitchtype in pitchtypes
        pitches = target[target.pitchtype .== pitchtype, :]
        plot!(pitches.pfxx, pitches.pfxz, seriestype=:scatter, marker=:circle, label="$pitchtype")
    end
end

"""
Generate velocity-vertical move scatter.

## Params

- start: start date to get data.
- fin: finish date to get data. Default is same of `start` value.
- per: unit to plot graph. player or team. Default is `player`.
- firstname: pitcher's firstname. It must be given if you choose `player` at `per` parameter.
- lastname: pitcher's lastname. It must be given if you choose `player` at `per` parameter.
- teamname: team name. It must be given if you choose `team` at `per` parameter.
- isbypitchtype: Boolean whether separate line by pitch type or not. Default is `false`.

## Return

- `Plots` object.

## Usages
"""
function vmove_velo_plot(data; per="player", firstname=nothing, lastname=nothing, teamname=nothing)
    # parameter check
    checkparam(per, firstname, lastname, teamname)
    # extract data
    data = pitchjx(start, fin)
    # execute
    if per == "player"
        return vmove_velo_by_player(data, start, fin, firstname, lastname)
    else
        return vmove_velo_by_team(data, start, fin, teamname)
    end
end

function vmove_velo_by_player(data, start, fin, firstname, lastname)
    target = data[(data.pitcher_firstname .== firstname) .& (data.pitcher_lastname .== lastname), :]
    # convert velocity to Float64
    target[:startspeed] = parse.(Float64, target[:startspeed])
    target[:pfxz] = parse.(Float64, target[:pfxz])
    p = plot(
        xlims=(60,100), ylims=(-20,20), title="$start to $fin: $firstname $lastname",
        xlabel="Start Speed", ylabel="Vertical Movement"
    )
    plot_vmove_velo(target)
    return p
end

function vmove_velo_by_team(data, start, fin, teamname)
    target = data[data.pitcher_teamname .== teamname, :]
    # convert velocity to Float64
    target[:startspeed] = parse.(Float64, target[:startspeed])
    target[:pfxz] = parse.(Float64, target[:pfxz])
    p = plot(
        xlims=(60,100), ylims=(-20,20), title="$start to $fin: $teamname",
        xlabel="Start Speed", ylabel="Vertical Movement"
    )
    plot_vmove_velo(target)
    return p
end

function plot_vmove_velo(target)
    pitchtypes = unique(target.pitchtype)
    for pitchtype in pitchtypes
        pitches = target[target.pitchtype .== pitchtype, :]
        plot!(pitches.startspeed, pitches.pfxz, seriestype=:scatter, marker=:circle, label="$pitchtype")
    end
end
