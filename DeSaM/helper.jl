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
