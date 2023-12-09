from diagrams import Diagram, Cluster, Edge, Node
graph_attr = {
    "spline":"splines",
    "label":"Clusters with Diagrams"
}
co1graph_attr = {
    "label":"rank=same with 'constraint' Edge parameter",
}
co2graph_attr = {
    "label":"rank=same with 'minlen' Edge parameter",
}
dir2graph_attr = {
    "label":"cluster with ranking",
}
with Diagram("edge labels", show=False, graph_attr=graph_attr) as diag:
    with Cluster("co1graph", graph_attr=co1graph_attr):
            co1node1 = Node(style="filled", label="CO1-1")
            co1node2 = Node(style="filled", label="CO1-2")
            co1node3 = Node(style="filled", label="CO1-3")
            (
                co1node1 >> Edge(constraint="False") >>
                co1node2 >> Edge(constraint="False") >> 
                co1node3
            )
    with Cluster("co2graph", graph_attr=co2graph_attr):
            co2node1 = Node(style="filled", label="CO2-1")
            co2node2 = Node(style="filled", label="CO2-2")
            co2node3 = Node(style="filled", label="CO2-3")
            (
                co2node1 >> Edge(minlen="0") >>
                co2node2 >> Edge(minlen="0") >> 
                co2node3
            )
    co1node1 - Edge(penwidth="1.0") - co2node3

    with Cluster("dir2graph", graph_attr=dir2graph_attr):
            dir2node1 = Node(style="filled", label="Dir2")
            dir2node2 = Node(style="filled", label="Dir2")
            #dir2node3 = Node(style="filled", label="Dir2")
            (
                dir2node1 >>
                dir2node2 
            )
diag
