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

function addTwoNumbers(ln1::ListNode, ln2::ListNode)
    # 在此作答
end
# 重载 +, 便于使用
# 可以直接写 `Node(0) + Node(1)`
# 而不是每次都要调用函数
+(ln1::ListNode, ln2::ListNode) = addTwoNumbers(ln1, ln2)

#= 辅助函数（答题非必须）
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