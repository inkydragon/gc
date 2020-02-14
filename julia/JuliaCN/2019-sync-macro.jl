using Distributed


addprocs(4)
@sync begin
    @distributed for i = 1:0.001:10
          T = [i i + 1; i + 2 i + 3];
          V = LinearAlgebra.eigvals(T);
    end
end
