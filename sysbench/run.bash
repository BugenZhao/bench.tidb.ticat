set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../helper/helper.bash"

session="${1}"
env=`cat "${session}/env"`

threads=`must_env_val "${env}" 'bench.sysbench.threads'`
duration=`must_env_val "${env}" 'bench.sysbench.duration'`
tables=`must_env_val "${env}" 'bench.sysbench.tables'`
table_size=`must_env_val "${env}" 'bench.sysbench.table-size'`
test_name=`must_env_val "${env}" 'bench.sysbench.test-name'`

host=`must_env_val "${env}" 'mysql.host'`
port=`must_env_val "${env}" 'mysql.port'`
user=`must_env_val "${env}" 'mysql.user'`
db='test'

log="${session}/sysbench.`date +%s`.log"
echo "bench.run.log=${log}" >> "${session}/env"

begin=`timestamp`

sysbench \
	--mysql-host="${host}" \
	--mysql-port="${port}" \
	--mysql-user="${user}" \
	--mysql-db="${db}" \
	--time="${duration}" \
	--threads="${threads}" \
	--report-interval=10 \
	--db-driver=mysql \
	--tables="${tables}" \
	--table-size="${table_size}" \
	"${test_name}" run | tee "${log}"

end=`timestamp`
score=`parse_sysbench_events "${log}"`

echo "bench.workload=sysbench" >> "${session}/env"
echo "bench.run.begin=${begin}" >> "${session}/env"
echo "bench.run.end=${end}" >> "${session}/env"
echo "bench.run.score=${score}" >> "${session}/env"
