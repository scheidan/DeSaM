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
##
## !!! use package "Distributions" for more options !!!

function def_household_source(n_pers_max::Int, median_V_per_person)

    ## sample number of persons
    n_person = rand(1:n_pers_max)

    ## sample global f_to_toilet
    f_to_toilet = rand()

    function houdehold_source(time)
        V_tot = sum(median_V_per_person*exp(randn(n_person))) # lognormal
        V_in_tank = V_tot * f_to_toilet * (rand()/2.5+0.8) # f_to_toilet changes between [0.8, 1.2]
        return(V_in_tank)
    end

    return(houdehold_source)
end
