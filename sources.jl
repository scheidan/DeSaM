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

## should not be necessary if packages are installed properly:
include(joinpath("Distributions", "Distributions.jl"))

using Distributions

## ---------------------------------
## Function to create a source function
## based on package "Distributions"

function def_household_source(n_pers_max::Int, median_V_per_person)

    ## sample number of persons
    n_person = rand(1:n_pers_max)

    ## sample global f_to_toilet  for this household from beta dist
    f_to_toilet = rand(Beta(15, 10))

    ## define lognormal dist. for Volume/day/person
    meanlog = log(median_V_per_person)
    sdlog = 1.5
    d_logNorm = logNormal(meanlog, sdlog)

    function houdehold_source(time)
        ## produced volume of all household members
        V_tot = sum( rand(d_logNorm, n_person) ) # lognormal

        ## daily f_to_toilet changes between +-20%
        f_to_toilet_day = f_to_toilet * (rand()/2.5+0.8)

        ## Volume in tank
        V_in_tank = V_tot * f_to_toilet_day

        ## costs
        costs = 1.0

        return(V_in_tank, costs)
    end

    return(houdehold_source)
end


## ---------------------------------
## Function to create a source function
##
## uses only Base functions

## function def_household_source(n_pers_max::Int, median_V_per_person)

##     ## sample number of persons
##     n_person = rand(1:n_pers_max)

##     ## sample global f_to_toilet
##     f_to_toilet = rand()

##     function houdehold_source(time)
##         V_tot = sum(median_V_per_person*exp(randn(n_person))) # lognormal
##         V_in_tank = V_tot * f_to_toilet * (rand()/2.5+0.8) # f_to_toilet changes between [0.8, 1.2]
##         costs = 0.0
##         return(V_in_tank, costs)
##     end

##
##     return(houdehold_source)
## end
