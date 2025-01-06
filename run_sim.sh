# !/bin/bash

sudo mkdir -p /etc/astra-sim/simulation/
sudo chown -R yangzhou:lambda-mpi-PG0 /etc/astra-sim/simulation/

python3 ./astra-sim-alibabacloud/inputs/topo/gen_HPN_7.0_topo_mulgpus_one_link.py -g 8 -gt A100 -bw 400Gbps -nvbw 2400Gbps -psn 1 
AS_SEND_LAT=3 AS_NVLS_ENABLE=1 AS_LOG_LEVEL=DEBUG ./bin/SimAI_simulator -t 16 -w ./example/microAllReduce.txt -n  ./HPN_7_0_8_gpus_8_in_one_server_with_single_plane_400Gbps_A100  -c astra-sim-alibabacloud/inputs/config/SimAI.conf
