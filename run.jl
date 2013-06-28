##
## Run DESAM 2.0
##
## June 28, 2013 -- Andreas Scheidegger
## -------------------------------------------------------

include("tank.jl")
include("collections.jl")
include("sources.jl")

## -------------------------------------------------------
## 1) Define tanks, collection and source function
## -------------------------------------------------------

## ---------------------------------
## define function for tank collection

collection_toilets = def_random_collection(200.0) # random collection tour with max 200L per tour day
collection_coll_tank = def_ordered_collection(100.0) # ordered collection tour with max 100L per tour day

## ---------------------------------
## define function for sources generation

## max 10 people, 1.5 liter/day/person median
source_house = def_household_source(10, 1.5) # use the same function repeatedly

## ---------------------------------
## define tanks

## toilet tanks
toilet_tanks_A = [Tank(10.0, source_house) for i=1:50] # use the same source function each time
show(toilet_tanks_A[1])

toilet_tanks_B = [Tank(5.0, def_household_source(10, 1.5)) for i=1:100] # create each time a NEW source function
show(toilet_tanks_B[1])


## collection tanks
tank_coll_1 = Tank(300.0, toilet_tanks_A, collection_toilets)
tank_coll_2 = Tank(300.0, toilet_tanks_B, collection_toilets)
show(tank_coll_1)
show(tank_coll_2)


## finale tank
tank_final = Tank(5000.0, [tank_coll_1, tank_coll_2], collection_coll_tank)
show(tank_final)



## -------------------------------------------------------
## 2) run simulation
## -------------------------------------------------------

## define empty vectors to save results
Volumes_tank_houshold_A1 = Float64[]
Volumes_tank_coll_1 = Float64[]
Volumes_tank_final = Float64[]

## simulation time
t_sim_max = 365*1

for t in 1:t_sim_max

    ## update final tank
    update(tank_final)

    ## write results
    push!(Volumes_tank_houshold_A1, tank_final.parents[1].parents[1].V)
    push!(Volumes_tank_coll_1, tank_final.parents[1].V)
    push!(Volumes_tank_final, tank_final.V)
end


## print stored results

println(toilet_tanks_B[1].source(10))
println(toilet_tanks_B[2].source(10))
println(toilet_tanks_B[3].source(10))
println(toilet_tanks_B[4].source(10))

println(toilet_tanks_A[1].source(10))
println(toilet_tanks_A[2].source(10))
println(toilet_tanks_A[3].source(10))
println(toilet_tanks_A[4].source(10))

## println(mean(Volumes_tank_houshold_A1))
## println(mean(Volumes_tank_coll_1))
## println(mean(Volumes_tank_final))


## writecsv("output.csv", [[1:t_sim_max] Volumes_tank_houshold_A1 Volumes_tank_coll_1 Volumes_tank_final])
println(" -- Done! -- ")




