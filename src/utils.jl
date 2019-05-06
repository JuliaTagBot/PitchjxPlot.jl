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
