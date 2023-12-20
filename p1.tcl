set ns [new Simulator]

set tf [open p1.tr w]
$ns trace-all $tf
set nf [open p1.nam w]
$ns namtrace-all $nf

set n0 [new node]
set n1 [new node]
set n2 [new node]
set n3 [new node]

$ns duplex-link $n0 $n2 2mb 2ms DropTail
$ns duplex-link $n1 $n2 2mb 2ms DropTail
$ns duplex-link $n2 $n3 2mb 2ms DropTail
$ns queue-limit $n0 $n2 5

set upd1 [new Agent/UPD]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n3 $null1
$ns connect $udp1 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

$ns at 1.1 "$cbr1 start"

set tcp1 [new Agent/TCP]
$ns attach-agent $ns0 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1
$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

$ns at 0.1 "$ftp1 start"
$ns at 10.0 "finish"

proc finish {} {
  global ns tf nf
  $ns finish-trace
  close $tf
  close $nf
  puts "running nam..."
  exec nam ex1.nam &
  exit 0
}

$ns run
