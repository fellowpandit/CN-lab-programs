BEGIN{
	last = 0
	tcp_sz = 0
}
{
	awk_sz = 0
	total_sz = 0
}
{
	action = $1;
	time = $2;
	from = $3;
	to = $4;
  type = $5;
  pkt_sz = $6;
  flow_id = $7;
  src = $9;
  dst = $10;
  seq_no = $11;
  packet_id = $12;

  if (type == "tcp" && action == "r" && to == "3")
    tcp_sz += pkt_sz;
  total_sz += pkt_sz;
  if (type == "ack" && action == "r" && += "3")
    ack_sz += pkt_sz;
  total_sz += pkt_sz;
}
END{
  printf("Time = %f\n",time);
  printf("TCP size = %f\n",tcp_sz);
  printf("ACK Size = %f\n",ack_sz);
  printf("Total Size = %f\n",total_sz);
}
