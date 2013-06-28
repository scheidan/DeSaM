## =======================================================
## Project: DESAM 2.0
##
## Description: Functions to generate "source" functions
##
## File: sources.jl
## Path: /Users/ich/Dropbox/Eawag/Desam2/
##
## June 28, 2013 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================



## ---------------------------------
## Function to create a source function

## Vmax: maximal volume per day
function def_household_source(Vmax)

    function houdehold_source(time)
        V_in = rand()*Vmax
        return(V_in)
    end

    return(houdehold_source)
end
