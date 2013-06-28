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

function def_random_collection(n_tanks_max::Int, # max number of tanks per day
                               V_coll_max::Float64, # max. volume per day
                               work_days::Int)      # tour is every 'work_days'-th days


    function random_collection(tanks::Vector{Tank}, time)

        V_coll = 0.0
        if mod(time, work_days)==0
            ## tanks are emptied in random order
            for i in randperm(size(tanks,1))[1:n_tanks_max]
                V_tank_out = min(tanks[i].V, V_coll_max - V_coll)
                tanks[i].V -= V_tank_out
                V_coll += V_tank_out
            end
        end

        return(V_coll)
    end

    return(random_collection)
end


## ---------------------------------
## Function to create a collection function for tank collection
## - tanks are emptied in same order -

function def_ordered_collection(n_tanks_max::Int, # max number of tanks per day
                                V_coll_max::Float64, # max. volume per day
                                work_days::Int)      # tour is every 'work_days'-th days

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

        return(V_coll)
    end

    return(ordered_collection)
end


## ---------------------------------
## Function to create a collection function for tank collection

## !!! BASTEL, muss eleganter moeglich sein !!!

## function def_team_collection(tanks_team_max::Int, # numbeer of tanks a team can empty
##                              V_coll_team_max::Float64, # max. Volume per team
##                              n_team::Int)              # number of teams

##     function team_collection(tanks::Vector{Tank}, time)

##         ## number of tanks to empty
##         n_tanks = size(tanks,1)

##         ## max number of tanks a tea, can empty
##         tanks_team = min(ifloor(n_tanks/n_team), tanks_team_max)

##         V_coll_all = 0

##         index = [1:ifloor(n_tanks/n_team):n_tanks, n_tanks] # distribute the tanks to teams
##         for i in 1:n_team
##             V_coll_team = 0.0
##             ## select randomly from the assigned tanks
##             for i in shuffle!([index[i]:index[i+1]-1])[1:tanks_team]
##                 V_tank_out = min(tanks[i].V, V_coll_team_max - V_coll_team)
##                 tanks[i].V -= V_tank_out
##                 V_coll_team += V_tank_out
##             end
##             V_coll_all =+ V_coll_team

##         end

##         #return(V_coll_all)
##         return(V_coll_team_max, tanks_team_max)
##     end

##     return(team_collection)
## end



