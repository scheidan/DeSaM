##
## Run DESAM 2.0
##
## June 27, 2013 -- Andreas Scheidegger
## -------------------------------------------------------


include("tank.jl")


## -------------------------------------------------------
## Define tanks, collection and source function
## -------------------------------------------------------


## ---------------------------------
## function for tank collection

function collection_toilets(tanks::Vector{Tank}, time)

    ## maximal collected volume
    V_coll_max= 250
    
    V_coll = 0.0
    ## tanks are emptied at the end of the day!
    ## empties tank alway in the same order
    for i in 1:size(tanks,1)
        V_tank_out = min(tanks[i].V, V_coll_max - V_coll)
        tanks[i].V -= V_tank_out
        V_coll += V_tank_out
    end
    
    return(V_coll)
end


function collection_coll_tank(tanks::Vector{Tank}, time)

    ## maximal collected volume
    V_coll_max = 100
    
    V_coll = 0.0
    ## tanks are emptied at the end of the day!
    ## empties tank alway in the same order
    for i in 1:size(tanks,1)
        V_tank_out = min(tanks[i].V, V_coll_max - V_coll)
        tanks[i].V -= V_tank_out
        V_coll += V_tank_out
    end
    
    return(V_coll)
end


## ---------------------------------
## function for sources

function source_A(time)
    V_in = rand()*10
    return(V_in)
end



## ---------------------------------

## define toilet tanks
tank_toilet_A = Tank(10.0, source_A)

tank_toilet_B = Tank(5.0, source_A)
show(tank_toilet_A)


## define collection tanks
tank_coll_1 = Tank(3000.0, Tank[tank_toilet_A for i=1:50], collection_toilets)
tank_coll_2 = Tank(3000.0, Tank[tank_toilet_B for i=1:100], collection_toilets)
show(tank_coll_1)


## define finale tank
tank_final = Tank(500.0, [tank_coll_1, tank_coll_2], collection_coll_tank)
show(tank_final)



## -------------------------------------------------------
## run simulation
## -------------------------------------------------------

## simulation time
t_sim_max = 104

## define empty vectors to save results
Volumes_tank_houshold_A1 = Float64[]
Volumes_tank_coll_1 = Float64[]

for x in 1:t_sim_max

    ## update final tank
    update(tank_final)

    ## write results
    push!(Volumes_tank_houshold_A1, tank_final.parents[1].parents[1].V)
    push!(Volumes_tank_coll_1, tank_final.parents[1].V)
        
    ## if x>100
    ##     println("--- ", x, " updates")
    ##     println("V householdtank[1]: ", round(tank_final.parents[1].parents[1].V,2))
    ##     println("overflow of householdtank[1]: ", round(tank_final.parents[1].parents[1].V_overflow,2))
    ##     println("V householdtank[2]: ", round(tank_final.parents[1].parents[2].V,2))
    ##     println("overflow of householdtank[2]: ", round(tank_final.parents[1].parents[2].V_overflow,2))
        
    ##     println("V of tank_final: ", round(tank_final.V,2))
    ##     println("overflow of tank_final: ", round(tank_final.V_overflow,2))

        
    ## end
end

## print stored results
println(Volumes_tank_houshold_A1)
println(Volumes_tank_coll_1)

