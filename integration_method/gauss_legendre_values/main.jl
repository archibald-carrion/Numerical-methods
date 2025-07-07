import Pkg; Pkg.add("FastGaussQuadrature")

using Printf
using FastGaussQuadrature

function print_gauss_legendre_nodes_weights(max_n)
    println("n\ti\tx_i\tw_i")
    for n in 1:max_n
        x, w = gausslegendre(n)
        for i in 1:n
            @printf("%d\t%d\t%.10f\t%.10f\n", n, i, x[i], w[i])
        end
    end
end

print_gauss_legendre_nodes_weights(4)