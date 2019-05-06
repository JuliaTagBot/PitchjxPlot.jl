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
function heatmapplot(start, fin=start; per="player", firstname=nothing, lastname=nothing, teamname=nothing, isbypitchtype=false)
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

function heatmapplot_by_player(data, start, fin, firstname, lastname, isbypitchtype)
    target = data[(data.pitcher_firstname .== firstname) .& (data.pitcher_lastname .== lastname), :]
    title = "$start to $fin: $firstname $lastname"
    return plotheatmap(target, title, isbypitchtype)
end

function heatmapplot_by_team(data, start, fin, teamname, isbypitchtype)
    target = data[data.pitcher_teamname .== teamname, :]
    title = "$start to $fin: $teamname"
    return plotheatmap(target, title, isbypitchtype)
end

function plotheatmap(target, title, isbypitchtype)
    if isbypitchtype
        pitchtypes = unique(target.pitchtype)
        p = plot(aspect_ratio=1, layout=(length(pitchtypes), 1))
        for (index, pitchtype) in enumerate(pitchtypes)
            pitches = target[target.pitchtype .== pitchtype, :]
            rarray = createheatmap(pitches)
            plot!(p[index], title="$title: $pitchtype", rarray, seriestype=:heatmap)
        end
    else
        p = plot(title="$title", aspect_ratio=1)
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
