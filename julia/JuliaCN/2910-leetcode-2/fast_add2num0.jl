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
function addVal(val1::UInt8, val2::UInt8, carry::UInt8)
    val_sum = val1 + val2 + carry
    new_val = val_sum % 10 # 只保留 1 位数
    carry   = val_sum ÷ 10  # 是否有进位

    new_val, carry
end
addNodesVal(ln1::Node, ln2::Node, carry=false) =
    addVal(ln1.val, ln2.val, UInt8(carry))
addNodesVal(ln::Node, ::Null, c::Bool) =
    addVal(ln.val, UInt8(0), UInt8(c))
addNodesVal(::Null, ln::Node, c::Bool) =
    addVal(ln.val, UInt8(0), UInt8(c))
addNodesVal(::Null,   ::Null, c::Bool) = (UInt8(c), 1)

function addTwoNumbers_wo2(ln1::ListNode, ln2::ListNode)
    val, carry = addNodesVal(ln1, ln2)
    ln3 = Node(val, null)
    next_node = ln3

    while carry==1 || ln1.next!=null || ln2.next!=null
        _val, carry = addNodesVal(ln1.next, ln2.next, carry)
        next_node.next = Node(_val, null)

        # 下一圈初始化
        ln1.next!=null && (ln1 = ln1.next)
        ln2.next!=null && (ln2 = ln2.next)
        next_node = next_node.next
    end

    ln3
end

# [两数相加 - 两数相加 - 力扣（LeetCode）](https://leetcode-cn.com/problems/add-two-numbers/solution/liang-shu-xiang-jia-by-leetcode/)
function addTwoNumbers_leetcode(ln1::ListNode, ln2::ListNode)
    root_node = Node(0xff, null)
    cur_node = root_node
    carry = 0
    
    while ln1!=null || ln2!=null
        v1 = ln1!=null ? ln1.val : 0
        v2 = ln2!=null ? ln2.val : 0
        
        temp = v1 + v2 + carry
        carry = temp ÷ 10 # 整除
        
        cur_node.next = Node(temp%10, null)
        cur_node = cur_node.next
        
        ln1!=null && (ln1 = ln1.next)
        ln2!=null && (ln2 = ln2.next)
    end
    if carry > 0
        cur_node.next = Node(a, null)
    end
    root_node.next
end

# [LeetCode: Add Two Numbers » CodersCat](https://coderscat.com/leetcode-add-two-numbers)
function addTwoNumbers_coderscat(ln1::ListNode, ln2::ListNode)
    root_node = Node(0xff, null)
    cur_node = root_node
    carry = 0
    sum = 0
    
    while ln1!=null || ln2!=null
        sum = carry
        ln1!=null && (sum += ln1.val)
        ln2!=null && (sum += ln2.val)
        
        if sum >= 10
            carry = sum ÷ 10
            sum %= 10
        else 
            carry = 0
        end
        
        cur_node.next = Node(sum, null)
        cur_node = cur_node.next
        
        ln1!=null && (ln1 = ln1.next)
        ln2!=null && (ln2 = ln2.next)
    end
    if carry > 0
        cur_node.next = Node(a, null)
    end
    root_node.next
end

# - [使用伪头节点，对应位依次相加，记录进位 - 两数相加 - 力扣（LeetCode）](https://leetcode-cn.com/problems/add-two-numbers/solution/shi-yong-wei-tou-jie-dian-dui-ying-wei-yi-ci-xiang/ )
function addTwoNumbers_brooot(ln1::ListNode, ln2::ListNode)
    root_node = Node(0xff, null)
    cur_node = root_node
    carry = 0
    sum = 0
    
    while ln1!=null || ln2!=null || carry>0
        sum = carry
        ln1!=null && (sum += ln1.val)
        ln2!=null && (sum += ln2.val)
        carry = sum ÷ 10
        
        cur_node.next = Node(sum%10, null)
        cur_node = cur_node.next
        
        ln1!=null && (ln1 = ln1.next)
        ln2!=null && (ln2 = ln2.next)
    end
    if carry > 0
        cur_node.next = Node(a, null)
    end
    root_node.next
end

# [最简写法 - 两数相加 - 力扣（LeetCode）](https://leetcode-cn.com/problems/add-two-numbers/solution/zui-jian-xie-fa-by-baal-3/)
function addTwoNumbers_Baal(ln1::ListNode, ln2::ListNode)
    root_node = Node(0xff, null)
    cur_node = root_node
    carry = 0
    
    while ln1!=null || ln2!=null || carry>0
        cur_node.next = Node(0, null)
        cur_node = cur_node.next

        ln1 = ln1!=null ? (carry+=ln1.val; ln1.next) : ln1
        ln2 = ln2!=null ? (carry+=ln2.val; ln2.next) : ln2
        
        cur_node.val = carry % 10
        carry = carry ÷ 10
    end
    root_node.next
end

function addTwoNumbers_Baal2(ln1::ListNode, ln2::ListNode)
    ln3, _ = addTwoNumbers_Baal2_rec(ln1, ln2)
    ln3
end
function addTwoNumbers_Baal2_rec(ln1::ListNode, ln2::ListNode, carry=0)
    if ln1==null && ln2==null && carry==0
        return null, 0
    end
    
    ln1 = ln1!=null ? (carry+=ln1.val; ln1.next) : ln1
    ln2 = ln2!=null ? (carry+=ln2.val; ln2.next) : ln2
    
    cur_node = Node(carry%10, null)
    carry = carry ÷ 10
    
    next, carry = addTwoNumbers_Baal2_rec(ln1, ln2, carry)
    cur_node.next = next
    
    cur_node, carry
end


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

# @btime $big_num + $big_num
@show  addTwoNumbers_wo2(big_node, big_node)==result_node
@btime addTwoNumbers_wo2($big_node, $big_node)

@show  addTwoNumbers_leetcode(big_node, big_node)==result_node
@btime addTwoNumbers_leetcode($big_node, $big_node)

@show  addTwoNumbers_coderscat(big_node, big_node)==result_node
@btime addTwoNumbers_coderscat($big_node, $big_node)

@show  addTwoNumbers_brooot(big_node, big_node)==result_node
@btime addTwoNumbers_brooot($big_node, $big_node)

@show  addTwoNumbers_Baal(big_node, big_node)==result_node
@btime addTwoNumbers_Baal($big_node, $big_node)
@show  addTwoNumbers_Baal2(big_node, big_node)==result_node
@btime addTwoNumbers_Baal2($big_node, $big_node)

