
too_big(alpha)      = alpha >= 100
too_small(alpha)    = alpha <= 0
not_in_range(alpha) = too_big(alpha) || too_small(alpha)

# 左侧逻辑
function gen_alpha(alpha=10)
    while not_in_range(alpha)
        if too_big(alpha)
            alpha = alpha / 2 # 缩小 α
            continue
        elseif too_small(alpha)
            alpha = alpha + 1 # 增加 α
            continue
        else
            break # 满足要求
        end
    end
    alpha
end

# 右侧逻辑
function gen_alpha2(alpha=10)
    while not_in_range(alpha)
        if too_big(alpha)
            alpha = alpha / 2 # 缩小 α
        end
        if too_small(alpha)
            alpha = alpha + 1 # 增加 α
            continue
        else
            break
        end
    end
    alpha
end