using ITensors
using ITensorsVisualization
using GLMakie
using LightGraphs: Graph
using Random

using ITensors.ContractionSequenceOptimization: optimal_contraction_sequence

Random.seed!(1234)

N = 5
g = Graph(N, N)
A = itensornetwork(g; linkspaces=5)
sequence = optimal_contraction_sequence(A)
R = @visualize_sequence fig ITensors.contract(A; sequence=sequence) show=(tags=true,) backend="Makie"
fig
