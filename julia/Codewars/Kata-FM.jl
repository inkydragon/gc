module Kata
  export F, M
  
  function F(n)
    if n == 0
      1
    else
      (n-1) |> F |> M |> - + n
    end
  end
  function M(n)
    if n == 0
      0
    else
      (n-1) |> M |> F |> - + n
    end
  end
end

module Kata
  export F, M
  
  F(n) = n == 0 ? 1 : n - (n-1 |> F |> M)
  M(n) = n == 0 ? 0 : n - (n-1 |> M |> F)
end


using FactCheck
using .Kata

facts("Testing basics") do
  @fact F(0) --> 1
  @fact M(0) --> 0
  @fact F(1) --> 1
  @fact M(1) --> 0
end
