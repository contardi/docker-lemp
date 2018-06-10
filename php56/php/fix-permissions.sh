#!/bin/bash

# Add a user qith the same ID as a host user and add permissions
groupadd --gid ${USERGID} ${USERNAME}
useradd --uid ${USERUID} --gid ${USERNAME} --shell /bin/bash --create-home ${USERNAME}
usermod -aG www-data ${USERNAME}
usermod -aG ${USERNAME} www-data
