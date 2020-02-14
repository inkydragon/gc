using BenchmarkTools
import Base: (+), (==)

abstract type ListNode end
mutable struct Node <: ListNode
    val::UInt8 #再小就要手动处理 bit 流
    next::ListNode
end

# List Node Null
struct Null <: ListNode end
# const null = LnNull()
null = Null()
==(::Null, ::Null) = true
==(::Null, ::Node) = false
==(::Node, ::Null) = false
# 可变数据结构不能使用 == 直接比较
function ==(ln1::Node, ln2::Node)
    ln1.val  != ln2.val  && return false
    ln1.next != ln2.next && return false
    true
end

# 节点相加，带进位，忽略 next
function addNodesVal(ln1::Node, ln2::Node, carry=false)
    carry_num = carry ? 1 : 0
    val_sum = ln1.val + ln2.val + carry_num
    @assert 0<= val_sum <= 19 # 9 + 9 + 1
    
    new_val = val_sum % 10 # 只保留 1 位数
    carry   = val_sum > 9  # 是否有进位

    new_val, carry
end
addNodesVal(ln::Node, ::Null, c::Bool) = addNodesVal(ln, Node(UInt8(c)))
addNodesVal(::Null, ln::Node, c::Bool) = addNodesVal(ln, Node(UInt8(c)))
addNodesVal(::Null,   ::Null, c::Bool) = (UInt8(c), false)

function addTwoNumbers(ln1::ListNode, ln2::ListNode)
    val, carry = addNodesVal(ln1, ln2)
    ln3 = Node(val, null)
    next_node = ln3
    
    while carry || ln1.next!=null || ln2.next!=null
        _val, carry = addNodesVal(ln1.next, ln2.next, carry)
        next_node.next = Node(_val, null)
        
        # 下一圈初始化
        ln1.next!=null && (ln1 = ln1.next)
        ln2.next!=null && (ln2 = ln2.next)
        next_node = next_node.next
    end
    
    ln3
end
Base.:+(ln1::ListNode, ln2::ListNode) = addTwoNumbers(ln1, ln2)

#= 辅助函数 
=#
"数字转数组"
function num2arr(n::Integer)
    ## 1- digits 法
    # digits 输出为倒序
    #   digits(123) == [3, 2, 1]
    n |> digits |> reverse
end
function num2ln(n::Integer)
    arr = num2arr(n)
    ln = null
    for i in arr
        ln = Node(UInt8(i), ln)
    end
    ln
end
Node(n::Integer) = num2ln(n)
Node() = null

# test 
big_num = big"1122334455667788990998877665544332211"
result_big_num = big_num*2
big_node = Node(big_num)
result_node = Node(result_big_num)

println("BigInt result: \n$(result_big_num)")
f_result = addTwoNumbers(big_node, big_node)
println("addTwoNumbers result: $(result_node==f_result)")

@btime $big_num + $big_num
@btime addTwoNumbers($big_node, $big_node)
