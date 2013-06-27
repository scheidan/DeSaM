##
## Type definition of 'Tank'
##
## June 27, 2013 -- Andreas Scheidegger
## -------------------------------------------------------

## ---------------------------------
## define type Tank

type Tank

    ## tank properties
    V_max::Float64

    ## State variables
    V::Float64
    V_overflow::Float64
    time

    ## function for sources
    source::Function

    ## function for collection, takes 'parent tanks' and 'time' as argment
    collection::Function

    ## a vector of elements of type 'tank'
    has_parents::Bool 
    parents::Vector{Tank}


    ## construct incomplete Tank object WITHOUT parents
    function Tank(V_max::Float64)
        ## default values
        V=0
        time=0
        V_overflow=0
        source(time) = 0
        collection(tanks::Vector{Tank}, time) = 0
        time = 0
        has_parents = false
        ## create instance
        new(V_max, V, V_overflow, time, source, collection, has_parents)
    end


end


## outer constructor for Tank if collection and parents exist
function Tank(V_max::Float64, 
              parents::Vector{Tank},
              collection::Function
              )
    tank = Tank(V_max)
    tank.has_parents = true
    tank.parents = Tank[deepcopy(parents[i]) for i=1:size(parents,1)] # deepcopy() makes independet objects
    tank.collection = collection
    return(tank)
end

## outer constructor for Tank if collection, source and parents exist
function Tank(V_max::Float64,
              parents::Vector{Tank},
              collection::Function,
              source::Function
              )
    tank = Tank(V_max)
    tank.has_parents = true
    tank.parents = Tank[deepcopy(parents[i]) for i=1:size(parents,1)]
    tank.source = source
    tank.collection = collection
    return(tank)
end


## outer constructor for Tank if only source exist
function Tank(V_max::Float64, source::Function)
    tank = Tank(V_max)
    tank.source = source
    return(tank)
end



## ---------------------------------
## function to update tanks

function update(tank::Tank)

    tank.time += 1

    V_in_coll = 0
    
    ## update all parent tanks and then collect
    if(tank.has_parents)
        for k in 1:size(tank.parents,1)
            update(tank.parents[k])
        end

        ## call collection function
        V_in_coll = tank.collection(tank.parents, tank.time)
    end

    ## call source function
    V_in_source = tank.source(tank.time)

    ## total volume that arrives at the tank
    V_in_tot = V_in_source + V_in_coll
    
    ## update volume
    tank.V = tank.V + V_in_tot
    tank.V_overflow = max(tank.V-tank.V_max, 0.0)
    tank.V = min(tank.V, tank.V_max)

end

## ---------------------------------
## function to show() a Tank object

function show(tank::Tank)
    println("---")
    println("V_max: ", tank.V_max)
    if(tank.has_parents)
        println("parent tanks: ", size(tank.parents,1))
        println("Collection function: ", tank.collection, "()")
    else
       println("no parent tank")
    end
    println("Source function: ", tank.source, "()")
    println("\n")
end


    
## ---------------------------------
