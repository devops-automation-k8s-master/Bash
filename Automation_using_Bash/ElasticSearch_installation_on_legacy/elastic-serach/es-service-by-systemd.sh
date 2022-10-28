#!/bin/bash -x

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

