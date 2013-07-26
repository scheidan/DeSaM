## =======================================================
## Project: DESAM 2.0
##
## Description: function to generate collection function
##
## File: collections.jl
## Path: c:/Users/scheidan/Dropbox/Eawag/JuliaTest/
##
## July 24, 2013 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## ======================================================= 


## ---------------------------------
## Function to create a simple collection function
## - tanks are emptied in random order -

function def_simple_collection(n_tanks_max::Integer, # max. number of tanks per day
                               V_coll_max::Real)     # max. volume that can be collected per day 
                               
    
    function simple_collection(tanks::Vector{Tank}, time)
        
        n_tanks = size(tanks,1)

        ## tanks are emptied the same order
        V_coll = 0.0
        for i in 1:min(n_tanks, n_tanks_max)
            V_tank_out = min(tanks[i].V, V_coll_max - V_coll)
            tanks[i].V -= V_tank_out   # !!! change volume of parent tank !!!
            V_coll += V_tank_out     
        end

        ## costs
        costs = 10.0 + 0.2*V_coll

        return(V_coll, costs)
    end

    return(simple_collection)
end
