set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../helper/helper.bash"

env=`cat "${1}/env"`

host=`must_env_val "${env}" 'mysql.host'`
port=`must_env_val "${env}" 'mysql.port'`
user=`must_env_val "${env}" 'mysql.user'`

db="test"
tables=(
	'customer'
	'district'
	'history'
	'item'
	'new_order'
	'orders'
	'order_line'
	'stock'
	'warehouse'
)
for table in ${tables[@]}; do
	query="SELECT count(*) FROM ${db}.${table}"
	echo "[${table}]"
	mysql -h "${host}" -P "${port}" -u "${user}" "${db}" -e "${query}" --batch | grep -v 'count' | awk '{print "    "$0}'
done
