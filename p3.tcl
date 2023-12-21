set ns [new Simulator]

set tf [open p3.tr w]
$ns trace-all $tf
set nf [open p3.nam w]
$ns namtrace-all $nf
set cwnd [open win3.tr w]

$ns color1 Blue
$ns color2 Red

$ns rtproto DV

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 0.3mb 10ms DropTail
$ns duplex-link $n1 $n2 0.3mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3mb 10ms DropTail
$ns duplex-link $n3 $n4 0.3mb 10ms DropTail
$ns duplex-link $n4 $n5 0.3mb 10ms DropTail
$ns duplex-link $n5 $n0 0.3mb 10ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink
$ns connect $tcp $sink
$tcp set fid 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns rtmodel-at 1.0 down $n1 $n4
$ns rtmodel-at 3.0 up $n1 $n4

$ns at 0.1 "$ftp start"
$ns at 12.0 "finish"

proc plotWindow {tcpSource file}{
  global ns
  set time 0.01
  set now [$ns now]
  set cwnd [$tcpSource set cwnd_}
  puts $file "$now $cwnd"
  $ns at [expr $now + $time] "plotWindow $tcpSource $file"
}

proc finish {} {
  global ns tf nf cwnd
  $ns flush-trace
  close $nf
  close $tf
  exec nam p3.nam &
  exec xgraph win3.tr %
  exit 0
}

$ns run

