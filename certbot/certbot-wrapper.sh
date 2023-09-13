#!/bin/bash

# retrieve python3 version (major.minor)
py_ver=python$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')

# set proper modules path
PYTHONPATH="/opt/zextras/common/certbot/lib/${py_ver}/dist-packages:"
PYTHONPATH+="/opt/zextras/common/certbot/lib/${py_ver}/site-packages:"
PYTHONPATH+="/opt/zextras/common/certbot/lib64/${py_ver}/dist-packages:"
PYTHONPATH+="/opt/zextras/common/certbot/lib64/${py_ver}/site-packages:"
export PYTHONPATH

# main certbot entrypoint with args
/opt/zextras/common/certbot/bin/carbonio-certbot "${@}"
