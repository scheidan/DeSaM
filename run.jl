##
## Run DESAM 2.0
##
## June 28, 2013 -- Andreas Scheidegger
## -------------------------------------------------------

include("tank.jl")
include("collections.jl")
include("sources.jl")

## seed for RNG
srand(111)

## -------------------------------------------------------
## 1) Define tanks, collection and source function
## -------------------------------------------------------


## --- toilet tanks A ---

## define function for sources generation:
source_house = def_household_source(10, 1.5) ## max 10 people, 1.5 liter/day/person median

toilet_tanks_A = [Tank(10.0, source_house) for i=1:50] # uses the *identical* source function each time
show(toilet_tanks_A[1])


## --- toilet tanks B ---

## create each time a NEW source function
toilet_tanks_B = [Tank(5.0, def_household_source(10, 1.5)) for i=1:100]
show(toilet_tanks_B[1])


## --- collection tanks A, B ---

## define function for tank collection
## random collection tour of max 25 tanks or max 200L, every 2nd day
collection_toilets = def_random_collection(25, 200.0, 2)

tank_coll_A = Tank(300.0, toilet_tanks_A, collection_toilets)
tank_coll_B = Tank(300.0, toilet_tanks_B, collection_toilets)
show(tank_coll_A)
show(tank_coll_B)


## --- finale tank ---

## ordered collection tour of max 25 tanks or max 100L, every 3th day
collection_coll_tank = def_ordered_collection(25, 100.0, 3)

tank_final = Tank(5000.0, [tank_coll_A, tank_coll_B], collection_coll_tank)
show(tank_final)



## -------------------------------------------------------
## 2) run simulation
## -------------------------------------------------------

## define empty vectors to save results
Volumes_tank_houshold_A1 = Float64[]
Volumes_tank_coll_1 = Float64[]
Volumes_tank_final = Float64[]

function simulate(t_sim_max)    ## simulation time

    for t in 1:t_sim_max

        ## update final tank
        update(tank_final)

        ## write results
        push!(Volumes_tank_houshold_A1, tank_final.parents[1].parents[1].V)
        push!(Volumes_tank_coll_1, tank_final.parents[1].V)
        push!(Volumes_tank_final, tank_final.V)
    end

    println(" -- Done! -- ")
end

## run simuation for two years
@time simulate(365*2)


## print stored results
println(mean(Volumes_tank_houshold_A1))
println(mean(Volumes_tank_coll_1))
println(mean(Volumes_tank_final))

## writecsv("output.csv", [[1:t_sim_max] Volumes_tank_houshold_A1 Volumes_tank_coll_1 Volumes_tank_final])




