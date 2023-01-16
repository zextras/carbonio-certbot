#!/bin/bash
export PYTHONPATH="/opt/zextras/common/lib/python3.8/site-packages/:/opt/zextras/common/lib64/python3.8/site-packages/${PYTHONPATH}"
/opt/zextras/common/bin/carbonio-certbot "${@}"