##
## Run DESAM 2.0
##
## July 12, 2013 -- Andreas Scheidegger
## -------------------------------------------------------


## ---------------------------------
## TODO
##
## - source function are relatively slow
## - definition of level in "get_field_of_parent_tanks" is suboptimal
##     replace with get_field() function?
## - pack everything in a module?
##
## ---------------------------------


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

## tank initial costs 999.0
toilet_tanks_A = [Tank(11.0, source_house, 999.0) for i=1:100] # uses the *identical* source function each tim
show(toilet_tanks_A[1])


## --- toilet tanks B ---

## create each time a NEW source function
toilet_tanks_B = [Tank(5.0, def_household_source(10, 1.5), 222.0) for i=1:100]
show(toilet_tanks_B[1])


## --- collection tanks A, B ---

## define function for tank collection
## random collection tour of max 25 tanks or max 200L, every 2nd day
collection_toilets = def_random_collection(25, 200.0, 2)

tank_coll_A = Tank(300.0, toilet_tanks_A, collection_toilets, 1111.0)
tank_coll_B = Tank(300.0, toilet_tanks_B, collection_toilets, 1111.0)
show(tank_coll_A)
show(tank_coll_B)


## --- finale tank ---

## ordered collection tour of max 25 tanks or max 100L, every 3th day
collection_coll_tank = def_ordered_collection(25, 100.0, 3)

tank_final = Tank(5000.0, [tank_coll_A, tank_coll_B], collection_coll_tank, 3333.0)
## tank_final = Tank(5000.0, [[tank_coll_A for i=1:50], [tank_coll_B for i=1:50]], collection_coll_tank, 3333.0)
show(tank_final)



## -------------------------------------------------------
## 2) run simulation
## -------------------------------------------------------

## --- define simulation function ---

function simulate(t_sim_max)    ## simulation time

    ## define empty vectors to save results
    Volumes_tank_final = Float64[]
    Volumes_overflow_households = Float64[]

    warm_up = min(100, t_sim_max/2)

    for t in 1:t_sim_max

        ## update final tank
        update(tank_final)              # update only the last tank!!!

        if t > warm_up
            ## write results
            push!(Volumes_tank_final, tank_final.V) # Volume of in final tank
            ## sum of all household overflows
            V_overflow = sum(get_field_of_parent_tanks(tank_final, 1, :V_overflow))

            push!(Volumes_overflow_households, V_overflow) # sum of overflow of household tanks

        end
    end

    println(" -- Done! -- ")
    return(Volumes_tank_final, Volumes_overflow_households)
end


## run simuation for two years
@time results = simulate(365*10);


## print stored results
println(mean(results[1]))
println(mean(results[2]))



## ## --- write results to file ---
## ## writecsv("output.csv", [[1:t_sim_max] Volumes_tank_houshold_A1 Volumes_tank_coll_1 Volumes_tank_final])

## ## -------------------------------------------------------


