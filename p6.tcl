#to execute it's "ns p6.tcl"

#Setting the default parameters

set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(x) 400
set val(y) 400
set val(ifqlen) 50
set val(nn) 2
set val(stop) 20.0
set val(rp) DSDV

set ns [new Simulator]
set tf [open p6.tr w]
$ns trace-all $tf
set nf [open p6.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

set prop [new $val(prop)]
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

#Node Configuration
$ns node-config -adhocRouting $val(rp)\
					-llType $val(ll)\
					-macType $val(mac)\
					-ifqType $val(ifq)\
					-ifqLen $val(ifqlen)\
					-antType $val(ant)\
					-propType $val(prop)\
					-phyType $val(netif)\
					-channelType $val(chan)\
					-topoInstance $topo\
					-agentTrace ON\
					-routerTrace ON\
					-macTrace ON
					
#Creating Nodes
for {set i 0} {$i < $val(nn)} {incr i} {
	set node_($i) [$ns node]
	$node_($i) random-motion 0
}
					
#Initial Positions of Nodes Spread
for {set i 0} {$i < $val(nn)} {incr i} {
	$ns initial_node_pos $node_($i) 40
}

$node_(0) set x 10.0
$node_(0) set y 10.0

$node_(1) set x 200.0
$node_(1) set y 200.0

#Topology Design
$ns at 1.1 "$node_(0) setdest 300.0 300.0 40.0"

#Generating Taffic
set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp0
$ns attach-agent $node_(1) $sink0
$ns connect $tcp0 $sink0

set ftp0 [new  Application/FTP]
$ftp0 attach-agent $tcp0

$ns at $val(stop) "finish"
$ns at 1.0 "$ftp0 start"
$ns at 18.0 "$ftp0 stop"

proc finish {} {
	global ns tf nf
	close $nf
	close $tf
	puts "Simulator Starting..."
	exec nam p6.nam &
	exit 0
}

#Simulation Termination
for {set i 0} {$i < $val(nn)} {incr i} {
	$ns at $val(stop) "$node_($i) reset";
}
$ns at $val(stop) "puts\"NS EXITING...\"; $ns halt"

puts "Starting Simulation"
$ns run









