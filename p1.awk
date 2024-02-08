BEGIN {
	tcp_count =0;
	tcp_count1 = 0;
	udp_count = 0;
	udp_count1 = 0;
}
{
if($1 == "d" && $5 == "tcp")
	tcp_count++;
if($1 == "r" && $5 == "tcp")
	tcp_count1++;
if($1 == "d" && $5 == "cbr")
	udp_count++;
if($1 == "r" && $5 == "cbr")
	udp_count1++;
}
END{
	printf("\nNo. of packets received & dropped in TCP = %d & %d", tcp_count1, tcp_count);
	printf("\nNo. of packets received & dropped in UDP = %d & %d\n", udp_count1, udp_count);
}
