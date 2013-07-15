## =======================================================
## Project: DESAM 2.0
##
## Description: type definition methods of 'Tank'
##
## File: tank.jl
## Path: c:/Users/scheidan/Dropbox/Eawag/JuliaTest/
##
## July 15, 2013 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================


## ---------------------------------
## define type Tank

type Tank

    ## tank properties
    V_max::Float64

    ## State variables
    V::Float64
    V_overflow::Float64
    costs::Float64
    time::Int

    ## function for sources, takes 'time' as agrument
    ## and returns (volume, costs)
    source::Function

    ## function for collection, takes 'parent tanks' and 'time' as argments
    ## and returns (volume, costs)
    collection::Function

    ## a vector of elements of type 'tank'
    has_parents::Bool
    parents::Vector{Tank}


    ## construct incomplete Tank object WITHOUT parents
    function Tank(V_max::Real)
        ## default values
        V = 0.0
        V_overflow = 0.0
        costs = 0.0
        time = 0
        no_sources(time) = (0.0, 0.0)
        no_collection(tanks::Vector{Tank}, time) = (0.0, 0.0)
        has_parents = false
        ## create instance
        new(V_max, V, V_overflow, costs, time, no_sources, no_collection, has_parents)
    end

end


## outer constructor for Tank if collection and parents exist
function Tank(V_max::Real,
              parents::Vector,
              collection::Function,
              costs::Real             # initial costs
              )
    tank = Tank(V_max)
    tank.has_parents = true
    tank.parents = Tank[deepcopy(parents[i]) for i=1:size(parents,1)] # deepcopy() makes independet objects
    tank.collection = collection
    tank.costs = costs
    return(tank)
end

## outer constructor for Tank if collection, source and parents exist
function Tank(V_max::Real,
              parents::Vector,
              collection::Function,
              source::Function,
              costs::Real             # initial costs
              )
    tank = Tank(V_max)
    tank.has_parents = true
    tank.parents = Tank[deepcopy(parents[i]) for i=1:size(parents,1)] # deepcopy() makes independet objects
    tank.source = source
    tank.collection = collection
    tank.costs = costs
    return(tank)
end


## outer constructor for Tank if only source exist
function Tank(V_max::Real,
              source::Function,
              costs::Real)            # initial costs
    tank = Tank(V_max)
    tank.source = source
    tank.costs = costs
    return(tank)
end



## ---------------------------------
## function to update tanks

function update(tank::Tank)

    tank.time += 1

    V_in_coll = 0.0
    costs_coll = 0.0
    ## update all parent tanks and then collect
    if tank.has_parents
        for k in 1:size(tank.parents,1)
            update(tank.parents[k])
        end

        ## call collection function
        V_in_coll, costs_coll = tank.collection(tank.parents, tank.time)

    end

    ## call source function
    V_in_source, costs_source = tank.source(tank.time)

    ## total volume that arrives at the tank
    V_in_tot = V_in_source + V_in_coll

    ## update volume
    tank.V = tank.V + V_in_tot
    tank.V_overflow = max(tank.V-tank.V_max, 0.0)
    tank.V = min(tank.V, tank.V_max)

    ## update costs
    tank.costs = tank.costs + costs_coll + costs_source


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
    println("Simulation time [days]: ", tank.time)
    println("Total costs: ", tank.costs)
    println("\n")
end


## ---------------------------------
## return an array of all parent tanks at the same 'level'

function get_parent_tanks(tank::Tank, level::Integer)

    level>=0 ? 0 : error("A negative 'level' is not allowed!")

    tanks_return = Tank[]
    for i in 1:size(tank.parents,1)
        if level==0
            push!(tanks_return, tank.parents[i])
        else
            if tank.parents[i].has_parents
                append!(tanks_return, get_parent_tanks(tank.parents[i], level-1))
            end
        end
    end

    return(tanks_return)
end

## ---------------------------------
## return an array of parent tanks of all levels

function get_parent_tanks(tank::Tank)

    tanks_return = Tank[]
    for i in 1:size(tank.parents,1)
        push!(tanks_return, tank.parents[i])
        if tank.parents[i].has_parents
            append!(tanks_return, get_parent_tanks(tank.parents[i]))
        end
    end

    return(tanks_return)
end



## ---------------------------------
## return all 'field's of an array of Tank objects
## !! argument 'field' must be type 'Symbol', i.e. get_field_of_tanks(tanks, :V_max)

function get_field_of_tanks(tanks::Vector{Tank}, field::Symbol)

    ## find type of field and initialize an empty array
    type_of_field = typeof(getfield(tanks[1], field))
    fields_return = type_of_field[]

    for i in 1:size(tanks,1)
        push!(fields_return, getfield(tanks[i], field))
    end

    return(fields_return)
end

## ---------------------------------
## Returns all 'field's of the 'level' parents of 'tank'
## !! argument 'field' must be type 'Symbol', i.e. get_field_of_tanks(tanks, :V_max)
## Just a wrapper for get_field_of_tanks(get_parent_tanks(tanks, level), :field)

function get_field_of_parent_tanks(tank::Tank, level::Integer, field::Symbol)

    level>=0 ? nothing : error("A negative 'level' is not allowed!")

    get_field_of_tanks(get_parent_tanks(tank, level), field)

end


## ---------------------------------
## Returns all 'field's of all(grand)parents of 'tank'
## !! argument 'field' must be type 'Symbol', i.e. get_field_of_tanks(tanks, :V_max)
## Just a wrapper for get_field_of_tanks(get_parent_tanks(tanks), :field)

function get_field_of_parent_tanks(tank::Tank, field::Symbol)

    get_field_of_tanks(get_parent_tanks(tank), field)

end



## ---------------------------------