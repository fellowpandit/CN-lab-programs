set ns [new Simulator]

set tf [open p4.tr w]
$ns trace-all $tf
set nf [open p4.nam w]
$ns namtrace-all $nf

set s [$ns node]
set c [$ns node]

$ns color1 Blue
$s label "Server"
$c label "Client"

$ns duplex-link $s $c 10mb 22ms DropTail
$ns duplex-link-op $s $c orient right

set tcp [new Agent/TCP]
$ns attach-agent $s $tcp
$tcp set packetSize_ 1500

set sink [new Agent/TCPSink]
$ns attach-agent $c $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$tcp set fid 1

proc finish {} {
  global ns tf nf
  $ns flush-trace
  close $tf
  close $nf
  exec nam p4.nam &
  exec awk -f ex5transfer.awk ex5.tr &
  exec awk -f ex5convert.awk ex5.tr > convert.tr &
  exec xgraph convert.tr
  exit 0
}

$ns at 0.01 "$ftp0 start"
$ns at 15.0 "$ftp0 stop"
$ns at 15.1 "finish"
$ns run
