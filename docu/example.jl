## =======================================================
## Project: DESAM 2.0
##
## Description: Example used on the documantation
##
## File: example.jl
## Path: c:/Users/scheidan/Dropbox/Eawag/DeSaM2/docu/
##
## July 24, 2013 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================

cd("c:/Users/scheidan/Dropbox/Eawag/DeSaM2")
require("DeSaM/tank.jl")
require("DeSaM/collections.jl")
require("DeSaM/sources.jl")
require("DeSaM/helper.jl")

## seed for RNG
srand(111)



## -------------------------------------------------------
## 1) Define tanks
## -------------------------------------------------------


## --- tanks A ---

## Volume:         10 liters
## upstream_tanks: -
## collection:     -
## source:         household_source; 10 people, 1.5 liter/day/person median
## initial costs:  100.00 

tanks_A = [Tank(10, def_household_source(10, 1.5), 100.00) for i=1:6]
## creats a vector of 6 similar tanks


## --- tank B ---

## Volume:         50 liters
## upstream_tanks: tanks_A
## collection:     random collection;  max 5 tanks or max 20L, every 2nd day
## source:         household_source; 10 people, 1.5 liter/day/person median
## initial costs:  250.00 (tank) + 100.00 (collection)

tank_B = Tank(50,
              tanks_A,
              def_random_collection(5, 20, 2),
              def_household_source(10, 1.5),
              250.00+100.00)
show(tank_B)


## --- tanks C ---

## Volume:         20 liters
## upstream_tanks: -
## collection:     -
## source:         household_source; 15 people, 1.5 liter/day/person median
## initial costs:  150.00 each

tanks_C = [Tank(20, def_household_source(15, 1.5), 150.00) for i=1:4]
## creats a vector of 4 similar tanks


## --- tank D ---

## Volume:         150 liters,
## upstream_tanks: [tank_B, tanks_C]
## collection:     random collection;  max 5 tanks or max 200L, every 3nd day
## source:         -
## initial costs:  500.00 (tank) + 200.00 (collection)

tank_D = Tank(150,
              [tank_B, tanks_C],
              def_random_collection(5, 200, 3),
              500.00 + 200.00)
show(tank_D)

## plot the structure of the tanks
plot(tank_D)



## -------------------------------------------------------
## 2) run simulation
## -------------------------------------------------------

println("setup costs: ", total_costs(tank_D))

## define empty vectors to save results
costs_tank_D = Float64[]
V_tanks_A = Float64[]

t_sim_max = 10*365                      # simulate 10 years
for t in 1:t_sim_max

    ## update last tank only
    update(tank_D)          

    ## -- three ways to obtain sum of all overflows of tanks A
    Vol = sum(get_field_of_tanks(tanks_A, :V)) # directly from tanks_A
    Vol = sum(get_field_of_upstream_tanks(tank_B, 0, :V)) # tanks_A are the upstream tanks of tank B
    Vol = sum(get_field_of_upstream_tanks(tank_D, 1, :V)) # tanks_A are the upstream tanks of tank D at level 1

        ## write results in a vector
    push!(V_tanks_A, Vol)
    push!(costs_tank_D, tank_D.costs) # costs, only of tank D (no costs of parent tanks)

end


## print results
println("Total costs after 10 years: ", total_costs(tank_D))
println("Average costs of tank D: ", mean(costs_tank_D))
println("Average volume off all tanks A: ", mean(V_tanks_A))


## --- write results to file ---
writecsv("output/output.csv", [V_tanks_A costs_tank_D])

## -------------------------------------------------------
