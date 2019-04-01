#!/bin/sh
ROOT=$(dirname $(readlink -f $0))
# get args
ACTION="$1"
TEMPLATE="$2"
ENV="$3"
STACK="$4"

if [ -z "$ACTION" ] || [ -z "$TEMPLATE" ] || [ -z "$ENV" ] || [ -z "$STACK" ]; then
	# missing args
	echo "Usage: stack.sh <ACTION> <TEMPLATE> <ENV> <STACK>"
	echo "actions: validate, create, update, show, list, delete"
else
	# decide on action
	case "$ACTION" in
	"validate")
		openstack stack create --insecure --dry-run --environment "${ROOT}/env/${ENV}.env" --template "${ROOT}/template/${TEMPLATE}.hot" "${STACK}"
		;;
	"create")
		openstack stack create --insecure --environment "${ROOT}/env/${ENV}.env" --template "${ROOT}/template/${TEMPLATE}.hot" "$STACK"
		;;
	"update")
		openstack stack update --insecure --environment "${ROOT}/env/${ENV}.env" --template "${ROOT}/template/${TEMPLATE}.hot" "$STACK"
		;;
	"show")
		openstack stack output show "${STACK}" salt_master_ip --insecure
		;;
	"list")
		openstack stack list --insecure
		;;
	"delete")
		openstack stack delete "${STACK}" --insecure
		;;
	*) 
		echo "Action \"$ACTION\" is now known. Aborting!"
		;;
	esac
fi
