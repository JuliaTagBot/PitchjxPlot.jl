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
function veloplot_by_pitch(data; per="player", firstname=nothing, lastname=nothing, teamname=nothing, isbypitchtype=false)
    # parameter check
    checkparam(per, firstname, lastname, teamname)
    # execute
    if per == "player"
        return veloplot_by_pitch_by_player(data, firstname, lastname, isbypitchtype)
    else
        return veloplot_by_pitch_by_team(data, teamname, isbypitchtype)
    end
end

function veloplot_by_pitch_by_player(data, firstname, lastname, isbypitchtype)
    target = data[(data.pitcher_firstname .== firstname) .& (data.pitcher_lastname .== lastname), :]
    # convert velocity to Float64
    target[:startspeed] = parse.(Float64, target[:startspeed])
    # init
    p = plot(title="$firstname $lastname", xlabel="Number of Pitches", ylabel="miles per hour")
    plotvelo(target, isbypitchtype)
    return p
end

function veloplot_by_pitch_by_team(data, teamname, isbypitchtype)
    target = data[data.pitcher_teamname .== teamname, :]
    # convert velocity to Float64
    target[:startspeed] = parse.(Float64, target[:startspeed])
    # init
    p = plot(title="$teamname", xlabel="Number of Pitches", ylabel="MPH")
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
