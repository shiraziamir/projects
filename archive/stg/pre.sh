sysctl -w  vm.overcommit_memory=1
echo never > /sys/kernel/mm/transparent_hugepage/enabled

