#!/bin/bash
echo "shutdown.sh"
bash ./shutdown.sh
echo "cd .."
cd ..
echo "rm -rf postgres*"
sudo rm -rf postgres*
