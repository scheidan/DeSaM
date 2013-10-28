## =======================================================
## Project: DESAM 2.0
##
## Description: Functions to generate "source" functions
##
## File: sources.jl
## Path: /Users/ich/Dropbox/Eawag/Desam2/
##
## July 24, 2013 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================


using Distributions


## ---------------------------------
## Function to create a source function
## based on package "Distributions"

function def_simple_source(V_max::Real)

    function simple_source(time)
        ## produced volume of all  members
        V = rand()*V_max # U(0, 10)
        ## costs
        costs = 0.1*V
        
        return(V, costs)
    end

    return(simple_source)
end

