![pitchjxplot](./pitchjxplot.png)

PITCHf/x plot tools by Julia.

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
- pitch-by-pitch location heatmap (Coming soon..)

## Usages

### pitch-by-pitch velocity line

```julia
using PitchjxPlot

player = veloline_by_pitch("2018-10-20", firstname="Clayton", lastname="Kershaw")
player_by_pitchtype = veloline_by_pitch("2018-10-20", firstname="Clayton", lastname="Kershaw", isbypitchtype=true)
team = veloline_by_pitch("2018-10-20", teamname="LAD")
team_by_pitchtype = veloline_by_pitch("2018-10-20", teamname="LAD", isbypitchtype=true)
```

### pitch-by-pitch location heatmap

Coming soon..
