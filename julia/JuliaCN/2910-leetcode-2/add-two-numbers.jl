using Test
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

# function addDigit!(ln::Node, val::UInt8)
#     while ln.next!=null
#         ln = ln.next
#     end
#     ln.next = Node(val, null)
#     ln
# end
# addDigit!(ln::Node, val::Int) = addDigit!(ln, UInt8(val))
# addDigit!(::Null, val::UInt8) = Node(val, null)
# addDigit!(::Null, val::Int)   = addDigit!(null, UInt8(val))

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

    ## 2-string 法
    # s = string(n)
    # a = []
    # for c in s
    #     push!(a, parse(UInt8, c))
    # end
    # a
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

# 单元测试
@testset "Node" begin
    # not equal
    @test Node()  != Node(1)
    @test Node(1) != Node()
    @test Node(1) != Node(2)
    @test Node(2) != Node(1)
    @test Node(10) != Node(0)
    @test Node(123456) != Node(123455)
    @test BigInt(123456789) |> Node != null

    # null
    @test Node() == Null()
    @test Node() == null

    # Int64
    @test Node(0) == Node(0x00, Null())
    @test Node(1) == Node(0x01, Null())
    @test 1234 |> Node ==
        Node(0x04, Node(0x03, Node(0x02, Node(0x01, Null()))))

    # Unsigned
    @test 0xFF |> Node == 
        Node(0x05, Node(0x05, Node(0x02, Null())))
    @test 0xFFFF |> Node == 
        Node(0x05, Node(0x03, Node(0x05, Node(0x05, Node(0x06, Null())))))

    # BigInt
    @test BigInt(123456789) |> Node == 
        Node(0x09, Node(0x08, Node(0x07, Node(0x06, Node(0x05, Node(0x04, Node(0x03, Node(0x02, Node(0x01, Null())))))))))
end

@testset "addNodesVal" begin
    for i in 0:9 # 0 + 0~9, 无进位
        @test addNodesVal(Node(i),Node(0)) == (i,false)
        @test addNodesVal(Node(0),Node(i)) == (i,false)
    end
    for i in 0:8 # 0 + 0~9 + 1, 无进位
        @test addNodesVal(Node(i),Node(0),true) == (i+1,false)
        @test addNodesVal(Node(0),Node(i),true) == (i+1,false)
    end

    for i in 1:9 # 9 + 1~9, 有进位
        @test addNodesVal(Node(i),Node(9)) == (i-1,true)
        @test addNodesVal(Node(9),Node(i)) == (i-1,true)
    end
    for i in 1:9 # 9 + 1~9 + 1, 有进位
        @test addNodesVal(Node(i),Node(9),true) == (i,true)
        @test addNodesVal(Node(9),Node(i),true) == (i,true)
    end
end

# @testset "addDigit!" begin
#     for i=1:9, j=0:9
#         @test addDigit!(Node(j),i) == Node(i*10+j)
#     end
# end

@testset "addTwoNumbers" begin
    @test Node(0) + Node(0) == Node(0)
    @test Node(1) + Node(9) == Node(10)

    @test Node(10) + Node(0) == Node(10)
    @test Node(123) + Node(0) == Node(123)
    @test Node(511) + Node(513) == Node(1024)
    
    @test Node(9) + Node(9) == Node(2*9)

    i=2^4
    @test Node(i) + Node(i) == Node(2*i)

    for i=1:2^8+1
        @test Node(i) + Node(0) == Node(i)
        @test Node(0) + Node(i) == Node(i)
        @test Node(i) + Node(i) == Node(2*i)
        @test Node(i+1) + Node(i-1) == Node(2*i)
    end
end
