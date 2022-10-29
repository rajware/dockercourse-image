#!/bin/sh -e

echo "Adding hyper-v services to start..."
rc-update add hv_fcopy_daemon
rc-update add hv_kvp_daemon
rc-update add hv_vss_daemon
