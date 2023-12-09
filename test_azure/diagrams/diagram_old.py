from diagrams import Cluster,Diagram,Edge,Node
from diagrams.azure.network import Subnets
from diagrams.azure.network import VirtualNetworks
from diagrams.azure.compute import VM
from diagrams.custom import Custom
from diagrams.onprem.network import Internet
from diagrams.onprem.client import Client
from diagrams.onprem.compute import Server
from diagrams.onprem.client import User
from diagrams.onprem.compute import Nomad

edge_attr = {
    "bgcolor": "transparent",
    "pencolor":"transparent",
}

logical_attr = {
    "bgcolor": "transparent",
    "pencolor":"transparent",
}

graph_attr = {
    "splines":"spline",
    "layout":"neato",
}

graph_attr_LR = {
    "layout":"dot",
    "compound":"true",
}


with Diagram("Azure", show=False, filename="my_diagram",outformat="jpg"):
    user = User("ユーザー")
    local = Client("ローカル端末")

    with Cluster('VNET',graph_attr={"labelloc":"b","labeljust":"c","rankdir":"RL","margin":"20"}):

        with Cluster("AzureBastionSubnet",graph_attr={"labelloc":"b","labeljust":"c"}):
            sn_bas = Subnets(height="0.5", width="0.5", imagescale="false")
            bastion = Custom("Bastion", "./bastion-icon.png")
            bastion >> Edge(constraint="false",penwidth="0",arrowsize="0") >> sn_bas

        with Cluster("sn-private",graph_attr={"labelloc":"b","labeljust":"c"}):
            sn_pvt = Subnets(height="0.5", width="0.5", imagescale="false")
            vm = VM("ubuntu")
            vm >> Edge(constraint="false",penwidth="0",arrowsize="0") >> sn_pvt

        #with Cluster("",graph_attr=logical_attr):
        with Cluster("",graph_attr={"margin":"20"}):
            vnet = VirtualNetworks(height="0.5", width="0.5", imagescale="false")
            
    user >> local >> bastion >> vm
    #sn_bas >> Edge(constraint="false") >> dummy2 >> Edge(constraint="false") >> sn_pvt


    #user >> local >> Edge(arrowsize="0") >> bas_l >>  bastion >> Edge(arrowsize="0") >> bas_r >> Edge(arrowsize="0") >> vm_l >> vm >> Edge(penwidth="0",arrowsize="0") >> vm_r

#dummy=Node("", shape="plaintext",height="0", width="0",)
#with Cluster("",graph_attr=logical_attr):
#Edge(penwidth="0",arrowsize="0")
#Edge(constraint="false")
#Cluster0 -> Cluster1 [style=inviz]
#rankdir=LR;
#Edge(minlen="0", penwidth="0.5", ltail="cluster_A", lhead="cluster_B")
#az1aNG - Edge(minlen="2", penwidth="0") - nlbig >> Edge(minlen="0") >> nlb
            #sn_bas >> Edge(arrowsize="0") >> dummy >> Edge(arrowsize="0") >> sn_pvt
#graph_attr={"labelloc":"b","labeljust":"c","rankdir":"RL","margin":"20"}
#    [sn_bas, sn_pvt] >> Edge(constraint="false",arrowsize="0") >> vnet
#Edge(style="invis")

