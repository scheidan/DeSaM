## =======================================================
## Project: DESAM 2.0
##
## Description: function to generate collection function
##
## File: collections.jl
## Path: c:/Users/scheidan/Dropbox/Eawag/JuliaTest/
##
## June 27, 2013 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================




## ---------------------------------
## Function to create a collection function for tank collection
## - tanks are emptied in random order -

function def_random_collection(V_coll_max::Float64)

    function random_collection(tanks::Vector{Tank}, time)

        ## maximal collected volume
        V_coll_max = V_coll_max

        V_coll = 0.0
        ## tanks are emptied at the end of the day!
        for i in randperm(size(tanks,1))
            V_tank_out = min(tanks[i].V, V_coll_max - V_coll)
            tanks[i].V -= V_tank_out
            V_coll += V_tank_out
        end

        return(V_coll)
    end

    return(random_collection)
end


## ---------------------------------
## Function to create a collection function for tank collection
## - tanks are emptied in same order -

function def_ordered_collection(V_coll_max::Float64)

    function ordered_collection(tanks::Vector{Tank}, time)

        ## maximal collected volume
        V_coll_max = V_coll_max

        V_coll = 0.0
        ## tanks are emptied at the end of the day!
        for i in 1:size(tanks,1)
            V_tank_out = min(tanks[i].V, V_coll_max - V_coll)
            tanks[i].V -= V_tank_out
            V_coll += V_tank_out
        end

        return(V_coll)
    end

    return(ordered_collection)
end

