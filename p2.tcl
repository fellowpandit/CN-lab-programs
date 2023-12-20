set ns [new Simulator]

set tf [open p2.tr w]
$ns trace-all $tf
set nf [open p2.nam w]
$ns namtrace-all $nf
set cwnd [open win2.tr w]

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 2mb 2ms DropTail
$ns duplex-link $n2 $n3 2mb 2ms DropTail
$ns duplex-link $n3 $n4 2mb 2ms DropTail
$ns duplex-link $n4 $n5 2mb 2ms DropTail
$ns duplex-link $n4 $n6 2mb 2ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n6 $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.1 "ftp0 start"

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1

set tel1 [new Application/Telnet]
$tel1 attach-agent $tcp1
$ns at 1.1 "$tel1 start"
$ns at 10.0 "finish"

proc plotWindow {tcpSource file} {
  global ns
  set time 0.01
  set now [$ns now]
  set cwnd0 [$tcp source set cwnd]
  puts $file "$now $cwnd"
  $ns at [expr $now + $time] "plotWindow $tcpSource $file"
}

$ns at 2.0 "plotWindow $tcp0 $cwnd"
$ns at 5.0 "plotWindow $tcp1 $cwnd"

proc finish {} {
  global ns tf nf cwnd
  $ns flush-trace
  close $tf
  close $nf
  puts "running nam..."
  exec nam program2.nam &
  exec xgraph win2.tr &
  exit 0
}

$ns run
