#!/bin/bash
export PYTHONPATH="/opt/zextras/common/certbot/lib/python3.8/site-packages/:/opt/zextras/common/certbot/lib64/python3.8/site-packages/${PYTHONPATH}"
/opt/zextras/common/certbot/bin/carbonio-certbot "${@}"