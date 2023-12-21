BEGIN{
  count = 0;
  time = 0;
}
{
  if ($1 == "r" && $4 == "1" && $5 == "tcp")
  {
    count += $6;
    time = $2;
    printf("\n%f\t%f", time, count/1000000);
  }
}
END{
  if (count > 0) {
    printf("\n\nTotal Bytes Received: %f MB\n", count/1000000);
    printf("Simulation Duration: %f seconds\n", time);
    printf("Average Throughput: %f Mbps\n", count / (time * 1000000));
  } else {
    print "No data received.";
  }
}
