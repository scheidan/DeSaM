## =======================================================
## Project: DESAM 2.0
##
## Description: function to generate collection function
##
## File: collections.jl
## Path: c:/Users/scheidan/Dropbox/Eawag/JuliaTest/
##
## July 15, 2013 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================


## ---------------------------------
## Function to create a collection function for tank collection
## - tanks are emptied in random order -

function def_random_collection(n_tanks_max::Integer, # max number of tanks per day
                               V_coll_max::Real, # max. volume per day
                               work_days::Integer)      # tour is every 'work_days'-th days


    function random_collection(tanks::Vector{Tank}, time)

        V_coll = 0.0
        if mod(time, work_days)==0
            n_tanks = size(tanks,1)
            ## tanks are emptied in random order
            for i in randperm(n_tanks)[1:min(n_tanks, n_tanks_max)]
                V_tank_out = min(tanks[i].V, V_coll_max - V_coll)
                tanks[i].V -= V_tank_out
                V_coll += V_tank_out
            end
        end

        ## costs
        costs = 10.0 + V_coll

        return(V_coll, costs)
    end

    return(random_collection)
end


## ---------------------------------
## Function to create a collection function for tank collection
## - tanks are emptied in same order -

function def_ordered_collection(n_tanks_max::Integer, # max number of tanks per day
                                V_coll_max::Real, # max. volume per day
                                work_days::Integer)      # tour is every 'work_days'-th days

    function ordered_collection(tanks::Vector{Tank}, time)

        V_coll = 0.0
        if mod(time, work_days)==0
            ## tanks are emptied in same order!
            for i in 1:min(size(tanks,1), n_tanks_max)
                V_tank_out = min(tanks[i].V, V_coll_max - V_coll)
                tanks[i].V -= V_tank_out
                V_coll += V_tank_out
            end
        end

        ## costs
        costs = 10.0 + V_coll

        return(V_coll, costs)
    end


    return(ordered_collection)
end

