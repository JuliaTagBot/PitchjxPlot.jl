![pitchjxplot](./pitchjxplot.png)

PITCHf/x plot tools by [Julia](https://julialang.org/).

## Install

Since this package have been not released to [General](https://github.com/JuliaRegistries/General) repository, please set GitHub URL as `Pkg.add()` parameter.

```bash
julia -e 'using Pkg; Pkg.add("https://github.com/prs-watch/PitchjxPlot.jl")'
```


## Features

`PitchjxPlot` provides some plots of PITCHf/x data.

- pitch-by-pitch velocity line (2019-05-05: Implemented!)
  - by player or team
  - You can choose whether separate graph by pitch type or not
- pitch-by-pitch location heatmap (2019-05-05: Implemented!)
- pitch-by-pitch movement scatter (2019-05-10: Implemented!)
- pitch-by-pitch velocity-movement scatter (2019-05-10: Implemented!)

## Usages

### pitch-by-pitch velocity line

```julia
using Pitchjx
using PitchjxPlot

data = pitchjx("2018-10-20")

player = veloplot_by_pitch(data, firstname="Clayton", lastname="Kershaw")
player_by_pitchtype = veloplot_by_pitch(data, firstname="Clayton", lastname="Kershaw", isbypitchtype=true)
team = veloplot_by_pitch(data, teamname="LAD")
team_by_pitchtype = veloplot_by_pitch(data, teamname="LAD", isbypitchtype=true)
```

### pitch-by-pitch location heatmap

```julia
player = heatmapplot(data, firstname="Clayton", lastname="Kershaw")
player_by_pitchtype = heatmapplot(data, firstname="Clayton", lastname="Kershaw", isbypitchtype=true)
team = heatmapplot(data, teamname="LAD")
team_by_pitchtype = heatmapplot(data, teamname="LAD", isbypitchtype=true)
```

### pitch-by-pitch movement scatter

```julia
player = movementplot(data, firstname="Clayton", lastname="Kershaw")
team = movementplot(data, teamname="LAD")
```

### pitch-by-pitch velocity-movement scatter

```julia
player = vmove_velo_plot(data, firstname="Clayton", lastname="Kershaw")
team = vmove_velo_plot(data, teamname="LAD")
```
