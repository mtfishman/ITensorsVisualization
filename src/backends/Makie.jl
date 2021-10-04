using GraphMakie
using GraphMakie.Makie:
  Makie,
  hidedecorations!,
  hidespines!,
  deregister_interaction!,
  register_interaction! 

function nlabels_default(g::AbstractGraph; label_key=default_label_key())
  return [get_prop_default(g, v, label_key, string(v)) for v in vertices(g)]
end

function elabels_default(g::AbstractGraph; label_key=default_label_key())
  return [get_prop_default(g, e, label_key, string(e)) for e in edges(g)]
end

function edge_width_default(g::AbstractGraph; width_key=default_width_key(), default=5)
  return [get_prop_default(g, e, width_key, default) for e in edges(g)]
end

function visualize(backend::Backend"Makie", g::AbstractGraph; interactive=true)
  if ismissing(Makie.current_backend[])
    error("""
      You have not loaded a backend.  Please load one (`using GLMakie` or `using CairoMakie`)
      before trying to visualize a graph.
    """)
  end
  f, ax, p = graphplot(
    g;
    node_size=[50 for i in 1:nv(g)],
    edge_width=edge_width_default(g),
    edge_color=colorant"black",
    nlabels=nlabels_default(g),
    nlabels_color=colorant"black",
    nlabels_textsize=30,
    nlabels_align=(:center, :center),
    node_color=colorant"lightblue1",
    elabels=elabels_default(g),
    elabels_color=colorant"red",
    elabels_textsize=30,
    selfedge_width=0.001,
    arrow_show=false,
    node_marker='●', #'◼',
    node_attr=(; strokecolor=:black, strokewidth=3),
  )
  hidedecorations!(ax)
  hidespines!(ax)
  if interactive
    deregister_interaction!(ax, :rectanglezoom)
    register_interaction!(ax, :nhover, NodeHoverHighlight(p))
    register_interaction!(ax, :ehover, EdgeHoverHighlight(p))
    register_interaction!(ax, :ndrag, NodeDrag(p))
    register_interaction!(ax, :edrag, EdgeDrag(p))
  end
  return f
end