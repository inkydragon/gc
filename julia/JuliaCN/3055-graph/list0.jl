module LinkedList

abstract type SingleList{T} end
#----------------#
#    ListElmt    #
#----------------#
mutable struct ListElmt{T}
    value::T
    next::Union{Nothing,ListElmt{T}}
end

ListElmt{T}(data::T) where T = ListElmt{T}(data,nothing)

#----------------#
#    DListElmt   #
#----------------#
mutable struct DListElmt{T}
    value::T
    prev::Union{Nothing,DListElmt{T}}
    next::Union{Nothing,DListElmt{T}}
end

DListElmt{T}(data::T) where T = DListElmt{T}(data,nothing,nothing)


#----------------#
#     mode       #
#----------------#
struct Mode
    push_fn::Int
    pop_fn::Int
end

const Push_Front=0
const Push_Back=1
const Pop_Front=2
const Pop_Back=3
#-------------------#
#      List         #
#-------------------#
mutable struct List{T} <: SingleList{T}
    size::Int
    head::Union{Nothing,ListElmt{T}}
    tail::Union{Nothing,ListElmt{T}}
    mode::Mode
end

List{T}() where T = List{T}(0,nothing,nothing,Mode(Push_Back,Pop_Back))


#------------------#
#     DList        #
#------------------#
mutable struct DList{T}
    size::Int
    head::Union{Nothing,DListElmt{T}}
    tail::Union{Nothing,DListElmt{T}}
    mode::Mode
end

DList{T}() where T = DList{T}(0,nothing,nothing,Mode(Push_Back,Pop_Back))

#------------------#
#      Queue       #
#------------------#
mutable struct Queue{T} <: SingleList{T}
    size::Int
    head::Union{Nothing,ListElmt{T}}
    tail::Union{Nothing,ListElmt{T}}
    mode::Mode
end

Queue{T}() where T = Queue{T}(0,nothing,nothing,Mode(Push_Back,Pop_Front))

#------------------#
#     Stack        #
#------------------#
mutable struct Stack{T} <: SingleList{T}
    size::Int
    head::Union{Nothing,ListElmt{T}}
    tail::Union{Nothing,ListElmt{T}}
    mode::Mode
end

Stack{T}() where T = Stack{T}(0,nothing,nothing,Mode(Push_Front,Pop_Front))

#----------------#
#      macro     #
#----------------#

# Q? is need for esc ??
macro lengthof(list)
    quote
        $list.size
    end |> esc
end

macro valueof(elmt)
    quote
        $elmt.value
    end |> esc
end

macro nextof(elmt)
    quote
        $elmt.next
    end |> esc
end



#-----------------#
#    push fn      #
#-----------------#
function push_back(list::SingleList{T},data::T) where T
    new_elmt=ListElmt{T}(data)
    
    if 0 == @lengthof list
        list.head=list.tail=new_elmt
    else
        list.tail=list.tail.next=new_elmt
    end
    list.size+=1
end

function push_back(list::DList{T},data::T) where T
    new_elmt=DListElmt{T}(data)

    if 0 == @lengthof list
        list.head=list.tail=new_elmt
    else
        new_elmt.prev=list.tail
        list.tail.next=new_elmt
        list.tail=new_elmt
    end
    list.size+=1
end

function push_front(list::SingleList{T},data::T) where T
    new_elmt=ListElmt{T}(data)

    if 0 == @lengthof list
        list.head=list.tail=new_elmt
    else
        new_elmt.next=list.head
        list.head=new_elmt
    end
    list.size+=1
end

function push_front(list::DList{T},data::T) where T
    new_elmt=DListElmt{T}(data)

    if 0 == @lengthof list
        list.head=list.tail=new_elmt
    else
        new_elmt.next=list.head
        list.head.prev=new_elmt
        list.head=new_elmt
    end

    list.size+=1
end

#--------------#
#    pop fn    #
#--------------#
function pop_back(list::SingleList{T}) where T
    if list.size==0
        return nothing
    end

    if list.size==1
        res=list.head.value
        list.head=list.tail=nothing
        list.size-=1
        return res
    end
    
    current=list.head    
    for i in 1:list.size-2
        current=current.next
    end

    res=list.tail.value
    list.tail=current
    list.size-=1
    res
end

function pop_back(list::DList{T}) where T
    if list.size==0
        return nothing
    end

    if list.size==1
        res=list.head.value
        list.head=list.tail=nothing
        list.size-=1
        return res
    end
    
    res=list.tail.value
    list.tail=list.tail.prev
    list.tail.next=nothing

    list.size-=1
    return res
end

function pop_front(list::SingleList{T}) where T
    if list.size==0
        return nothing
    else

        res=list.head.value
        list.head=list.head.next
        list.size-=1
        return res
    end
end

function pop_front(list::DList{T}) where T
    if list.size==0
        return nothing
    else

        res=list.head.value
        list.head=list.head.next
        list.head.prev=nothing
        list.size-=1
        return res
    end

end

#---------------#
#  interface    #
#---------------#
function push(list::SingleList{T},data::T) where T
    if list.mode.push_fn == Push_Front
        push_front(list,data)
    else
        push_back(list,data)
    end
end

function push(list::DList{T},data::T) where T
    if list.mode.push_fn == Push_Front
        push_front(list,data)
    else
        push_back(list,data)
    end
end

function remove(list::SingleList{T}) where T
    if list.mode.pop_fn == Pop_Back
        return pop_back(list)
    else
        return pop_front(list)
    end
end

function remove(list::DList{T}) where T
    if list.mode.pop_fn == Pop_Back
        return pop_back(list)
    else
        return pop_front(list)
    end
end


#-----------------#
#    iterate      #
#-----------------#
Base.iterate(list::Union{SingleList{T},DList{T}}) where T = list.size==0 ? nothing : ( list.head, list.head)
Base.iterate(list::Union{SingleList{T},DList{T}},state::Union{ListElmt{T},DListElmt{T}}) where T = state.next==nothing ? nothing : ( state.next, state.next)

#--------------#
#   appendix   #
#--------------#

#--------------#
#    contain   #
#--------------#
function contain(list::Union{SingleList{T},DList{T}},data::T) where T
    for current in list
        if @valueof(current) == data
            return true
        end
    end
    
    return false
end

#--------------#
#    print     #
#--------------#

function Base.print(list::Union{SingleList{T},DList{T}}) where T
    for current in list
        print(@valueof(current),'\t')
    end
    println()
end


# export List
# export DList
# export Queue
# export Stack
# export contain
# export push
# export remove
# export print

end