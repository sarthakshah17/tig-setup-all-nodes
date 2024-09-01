#!/bin/bash


export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin:$HOME/bin:$PATH"


# Function to check if a tmux session exists
session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

# Start the tmux session with name "tig" if it doesn't exist
if ! session_exists "tig"; then
    echo "no tmux session active"
    sleep 1
    
else
    echo "Session 'tig' is already running."
    tmux kill-session -t tig
    
    echo "tmux session stoped"
    sleep 1
fi



mkdir -p tig

cd ~/tig

# Stop and remove all Docker containers
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

sudo apt update && \
sudo apt install -y curl tmux git libssl-dev pkg-config && \
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh -s -- -y && \
source $HOME/.cargo/env

sudo apt install -y tmux build-essential pkg-config libssl-dev git curl


# Remove existing tig-monorepo directory if it exists
if [ -d "tig-monorepo" ]; then
    rm -rf tig-monorepo
fi


# Clone the repository
git clone https://github.com/tig-foundation/tig-monorepo && cd tig-monorepo && git config pull.rebase false && git pull origin benchmarker_v2.0 --no-edit


# Navigate to the repository directory
cd tig-monorepo

#Set git config
git config --global user.email "you@example.com"
git config --global user.name "Your Name"


git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git vehicle_routing/clarke_wright_super

git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git vector_search/optimax_gpu

git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git satisfiability/sat_allocd

git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git knapsack/knapmaxxing

ALGOS_TO_COMPILE="satisfiability_sat_allocd vehicle_routing_clarke_wright_super knapsack_knapmaxxing vector_search_optimax_gpu"
cargo build -p tig-benchmarker --release --no-default-features --features "standalone ${ALGOS_TO_COMPILE}"
