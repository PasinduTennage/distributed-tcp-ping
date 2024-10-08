pwd=$(pwd)
. "${pwd}"/setup/ip.sh

rm nohup.out

dummy_path="/dummy/dummy"
stat_path="/dummy/stats"

config="/home/${username}/dummy/dedis-config.yaml"

local_output_path="logs/dummy/"
rm -r "${local_output_path}"; mkdir -p "${local_output_path}"

for index in "${!replicas[@]}";
do
  sshpass ssh "${replicas[${index}]}"  -i ${cert}  "pkill -f dummy; pkill -f stats"
done

echo "Killed previously running instances"

echo "starting dummy replicas"

nohup ssh ${replica1}  -i ${cert}   ".${dummy_path} --config ${config} --name 1 --debugOn --debugLevel 0">"${local_output_path}"1.log &
nohup ssh ${replica2}  -i ${cert}   ".${dummy_path} --config ${config} --name 2 --debugOn --debugLevel 0">"${local_output_path}"2.log &
nohup ssh ${replica3}  -i ${cert}   ".${dummy_path} --config ${config} --name 3 --debugOn --debugLevel 0">"${local_output_path}"3.log &
nohup ssh ${replica4}  -i ${cert}   ".${dummy_path} --config ${config} --name 4 --debugOn --debugLevel 0">"${local_output_path}"4.log &
nohup ssh ${replica5}  -i ${cert}   ".${dummy_path} --config ${config} --name 5 --debugOn --debugLevel 0">"${local_output_path}"5.log &

echo "Started dummy replicas"

sleep 10

nohup ssh ${replica6}  -i ${cert}   ".${stat_path} --config ${config}">"${local_output_path}"stats.log &

sleep  120

for index in "${!replicas[@]}";
do
  sshpass ssh "${replicas[${index}]}"  -i ${cert}  "pkill -f dummy; pkill -f stats"
done

echo "Killed dummy replicas"