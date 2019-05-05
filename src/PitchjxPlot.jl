module PitchjxPlot

export
    veloplot_by_pitch,
    heatmapplot

using Pitchjx
using Plots

const zonedef = [
    ["11", "11", "11", "11", "12", "12", "12", "12"],
    ["11", "1", "1", "2", "2", "3", "3", "12"],
    ["11", "1", "1", "2", "2", "3", "3", "12"],
    ["11", "4", "4", "5", "5", "6", "6", "12"],
    ["13", "4", "4", "5", "5", "6", "6", "14"],
    ["13", "7", "7", "8", "8", "9", "9", "14"],
    ["13", "7", "7", "8", "8", "9", "9", "14"],
    ["13", "13", "13", "13", "14", "14", "14", "14"]
]

"""
Generate line graph of pitch-by-pitch velocity.

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

- per player / isbypitch = false
  - `veloline_by_pitch("2018-10-20", firstname="Clayton", lastname="Kershaw")`
- per player / isbypitch = true
  - `veloline_by_pitch("2018-10-20", firstname="Clayton", lastname="Kershaw", isbypitchtype=true)`
- per team / isbypitch = false
  - `veloline_by_pitch("2018-10-20", teamname="LAD")`
- per team / isbypitch = false
  - `veloline_by_pitch("2018-10-20", teamname="LAD", isbypitchtype=true)`
"""
function veloplot_by_pitch(start; fin=start, per="player", firstname=nothing, lastname=nothing, teamname=nothing, isbypitchtype=false)
    # parameter check
    checkparam(per, firstname, lastname, teamname)
    # extract data
    data = pitchjx(start, fin)
    # execute
    if per == "player"
        return veloplot_by_pitch_by_player(data, start, fin, firstname, lastname, isbypitchtype)
    else
        return veloplot_by_pitch_by_team(data, start, fin, teamname, isbypitchtype)
    end
end

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
function heatmapplot(start; fin=start, per="player", firstname=nothing, lastname=nothing, teamname=nothing, isbypitchtype=false)
    # parameter check
    checkparam(per, firstname, lastname, teamname)
    # extract data
    data = pitchjx(start, fin)
    # execute
    if per == "player"
        return heatmapplot_by_player(data, start, fin, firstname, lastname, isbypitchtype)
    else
        return heatmapplot_by_team(data, start, fin, teamname, isbypitchtype)
    end
end

function checkparam(per, firstname, lastname, teamname)
    # parameter check
    if per == "player"
        if firstname == nothing && lastname == nothing
            @error "You have to set parameters 'firstname' and 'lastname' to execute."
        end
    elseif per == "team"
        if teamname == nothing
            @error "You have to set parameter 'teamname' to execute."
        end
    else
        @error "You have to set 'player' or 'team' to a parameter 'per'."
    end
end

function veloplot_by_pitch_by_player(data, start, fin, firstname, lastname, isbypitchtype)
    target = data[(data.pitcher_firstname .== firstname) .& (data.pitcher_lastname .== lastname), :]
    # convert velocity to Float64
    target[:startspeed] = parse.(Float64, target[:startspeed])
    # init
    p = plot(title="$start to $fin: $firstname $lastname", xlabel="Number of Pitches", ylabel="miles per hour")
    plotvelo(target, isbypitchtype)
    return p
end

function veloplot_by_pitch_by_team(data, start, fin, teamname, isbypitchtype)
    target = data[data.pitcher_teamname .== teamname, :]
    # convert velocity to Float64
    target[:startspeed] = parse.(Float64, target[:startspeed])
    # init
    p = plot(title="$start to $fin: $teamname", xlabel="Number of Pitches", ylabel="MPH")
    plotvelo(target, isbypitchtype)
    return p
end

function plotvelo(target, isbypitchtype)
    if isbypitchtype
        pitchtypes = unique(target.pitchtype)
        for pitchtype in pitchtypes
            pitches = target[target.pitchtype .== pitchtype, :]
            plot!(pitches.startspeed, seriestype=:scatter, marker=:circle, label="$pitchtype: Start Speed")
        end
    else
        plot!(target.startspeed, marker=:circle, label="Start Speed")
    end
end

function heatmapplot_by_player(data, start, fin, firstname, lastname, isbypitchtype)
    target = data[(data.pitcher_firstname .== firstname) .& (data.pitcher_lastname .== lastname), :]
    p = plot(title="$start to $fin: $firstname $lastname", aspect_ratio=1)
    if isbypitchtype
        pitchtypes = unique(target.pitchtype)
        p = plot(aspect_ratio=1, layout=(length(pitchtypes), 1))
        for (index, pitchtype) in enumerate(pitchtypes)
            pitches = target[target.pitchtype .== pitchtype, :]
            rarray = createheatmap(pitches)
            plot!(p[index], title="$start to $fin: $firstname $lastname: $pitchtype", rarray, seriestype=:heatmap)
        end
    else
        p = plot(title="$start to $fin: $firstname $lastname", aspect_ratio=1)
        rarray = createheatmap(target)
        plot!(rarray, seriestype=:heatmap)
    end
    return p
end

function createheatmap(target)
    hmap = [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
    ]
    for zone in target.zone
        for vzone in 1 : length(hmap)
            for hzone in 1 : length(hmap[vzone])
                if zonedef[hzone][vzone] == zone
                    hmap[hzone][vzone] += 1
                end
            end
        end
    end
    return reshapeto64(hmap)
end

function reshapeto64(array)
    rarray = []
    for row in array
        if length(rarray) == 0
            rarray = row
        else
            rarray = hcat(rarray, row)
        end
    end
    return rarray
end

end # module
