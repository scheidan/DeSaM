## =======================================================
## Project: DESAM 2.0
##
## Description: Little helper functions for convenience,
##              do not provide additional functionality
##
## File: helper.jl
## Path: c:/Users/scheidan/Dropbox/Eawag/DeSaM2/
##
## July 24, 2013 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================

    
## ---------------------------------
## Returns all costs of 'tank' and all its upstream tanks

function total_costs(tank::Tank)
    sum(get_field_of_upstream_tanks(tank, :costs)) + tank.costs
end




## ---------------------------------
## Produce a very simple plot of the structure
## of the upstreams tanks

function plot(tank::Tank, pre::String)

    ## construct string to print
    str_mid = "\u251C\u2500"
    str = string(pre, str_mid, " U")

    tank.has_upstream_tanks ? println(str, " \u2510") : println(str)

    if tank.has_upstream_tanks
        n_upstream = size(tank.upstream_tanks, 1)
        for i in 1:n_upstream
            plot(tank.upstream_tanks[i], string(pre, "\u2502    "))
        end
    end

end


function plot(tank::Tank)
    println("")
    plot(tank::Tank, "  ")
    println("")
end
