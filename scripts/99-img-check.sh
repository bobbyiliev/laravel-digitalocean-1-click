#!/bin/bash

# DigitalOcean Marketplace Image Validation Tool
# © 2021-2022 DigitalOcean LLC.
# This code is licensed under Apache 2.0 license (see LICENSE.md for details)

cd /tmp
wget https://raw.githubusercontent.com/digitalocean/marketplace-partners/master/scripts/99-img-check.sh
chmod +x 99-img-check.sh
./99-img-check.sh
rm -f 99-img-check.sh