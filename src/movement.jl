"""
Generate location heatmap.

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
function movementplot(start; fin=start, per="player", firstname=nothing, lastname=nothing, teamname=nothing)
    # parameter check
    checkparam(per, firstname, lastname, teamname)
    # extract data
    data = pitchjx(start, fin)
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
    p = plot(title="$start to $fin: $firstname $lastname", xlabel="Horizon Movement", ylabel="Vertical Movement")
    plotmovement(target)
    return p
end

function movementplot_by_team(data, start, fin, teamname)
    target = data[data.pitcher_teamname .== teamname, :]
    # convert velocity to Float64
    target[:pfxx] = parse.(Float64, target[:pfxx])
    target[:pfxz] = parse.(Float64, target[:pfxz])
    p = plot(title="$start to $fin: $teamname", xlabel="Horizon Movement", ylabel="Vertical Movement")
    plotmovement(target)
    return p
end

function plotmovement(target)
    pitchtypes = names(target.pitchtype)
    for pitchtype in pitchtypes
        pitches = target[target.pitchtype .== pitchtype, :]
        plot!(pitches.pfxx, pitches.pfxz, seriestype=:scatter, marker=:circle, label="$pitchtype")
    end
end
