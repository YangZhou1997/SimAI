# !/bin/bash

# sudo mkdir -p /etc/astra-sim/simulation/
# sudo chown -R yangzhou:lambda-mpi-PG0 /etc/astra-sim/simulation/

# num_gpus=(16 32 64 128 256 512 1024)
num_gpus=(512 1024)
net_bw=(50Gbps 100Gbps 200Gbps 400Gbps)

cnt=0
for g in ${num_gpus[@]}; do
    for bw in ${net_bw[@]}; do
        # topo_file=`python3 ./astra-sim-alibabacloud/inputs/topo/gen_HPN_7.0_topo_mulgpus_one_link.py -g ${g} -gt A100 -bw ${bw} -nvbw 2400Gbps`
        topo_file=`python3 ./astra-sim-alibabacloud/inputs/topo/gen_HPN_7.0_topo_mulgpus_one_link.py -g ${g} -gt A100 -bw ${bw} -nvbw 2400Gbps -asn $((g/128)) --st`
        echo "topo_file: ${topo_file}"
        
        result_path=${g}_gpus_${bw}_A100_
        (AS_SEND_LAT=2 ./bin/SimAI_simulator -t 16 -w ./example/microAllReduce_netOnly_${g}gpus.txt -n ${topo_file} -c astra-sim-alibabacloud/inputs/config/SimAI.conf -r ${result_path}; rm ${result_path}detailed_*.csv; rm ${result_path}test1_*.csv) &
        
        cnt=$((cnt+1))
        if [ $cnt -eq 4 ]; then
            wait
            cnt=0
        fi
    done
done

# python3 ./astra-sim-alibabacloud/inputs/topo/gen_HPN_7.0_topo_mulgpus_one_link.py -g 4096 -gt A100 -bw 400Gbps -nvbw 2400Gbps -asn 32
