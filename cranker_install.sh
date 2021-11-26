#!/bin/bash

# Install packages
apt-get update && apt-get upgrade 
apt-get install libssl-dev libudev-dev build-essential pkg-config curl

# Prepare Node install
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -

# Install Node
apt-get install -y nodejs

# Install pm2 and yarn
npm install -g npm@latest
npm install --global yarn && npm install --global pm2

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Reset folder
cd audaces-perps && git reset --hard && cd ..

# Get updated files from github
git clone https://github.com/AudacesFoundation/audaces-perps.git

# Build Cranker
cd audaces-perps/cranker && $HOME/.cargo/bin/cargo update && $HOME/.cargo/bin/cargo build --release

# Run yarn
cd $HOME/audaces-perps/cranker/pm2 && yarn

# Add pm2 to system
pm2 startup

# Install PM2 metrics
pm2 install pm2-metrics

# Start crankers
cd  $HOME/audaces-perps/cranker/pm2/ && pm2 start crank_garbage_collect crank_liquidate liquidation_cleanup
cd  $HOME/audaces-perps/cranker/pm2/ && pm2 stop crank_funding crank_funding_extraction
