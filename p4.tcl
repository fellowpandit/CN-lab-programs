set ns [new Simulator]
set tracefile [open ex4.tr w]
$ns trace-all $tracefile
set namfile [open ex4.nam w]
$ns namtrace-all $namfile

set s [$ns node]
set c [$ns node]

$ns color 1 Blue

$s label "Server"
$c label "Client"

$ns duplex-link $s $c 10Mb 22ms DropTail
$ns duplex-link-op $s $c orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $s $tcp0

$tcp0 set packetSize_ 1500

set sink0 [new Agent/TCPSink]
$ns attach-agent $c $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$tcp0 set fid_ 1

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam ex4.nam &
	exec awk -f ex4transfer.awk ex4.tr &
	exec awk -f ex4convert.awk ex4.tr > convert.tr &
	exec xgraph convert.tr -geometry 800*400 -t "bytes_received_at_client" -x "time_in_secs" -y "bytes-in-bps" &
}

$ns at 0.01 "$ftp0 start"
$ns at 15.0 "$ftp0 stop"
$ns at 15.1 "finish"
$ns run
