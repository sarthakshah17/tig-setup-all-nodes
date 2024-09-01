#!/bin/bash

export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin:$HOME/bin:$PATH"
# Add custom paths to the environment, including Cargo's path
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$PATH"

# Function to check if a tmux session exists
session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

# Start or restart the "tig" tmux session
if ! session_exists "tig"; then
    echo "No tmux session active. Starting a new session..."
    tmux new -s tig -d
else
    echo "Session 'tig' is already running. Stopping it..."
    tmux kill-session -t tig
    sleep 1
    echo "Starting a new 'tig' session..."
    tmux new -s tig -d
fi

# Navigate to the repository directory and set environment variables inside the tmux session
tmux send-keys -t tig "cd ~/tig/tig-monorepo && . ~/tig/.env" C-m

# Define the selected algorithms and run the benchmarker inside the tmux session
tmux send-keys -t tig "SELECTED_ALGORITHMS='{\"satisfiability\":\"sat_allocd\",\"vehicle_routing\":\"clarke_wright_super\",\"knapsack\":\"knapmaxxing\",\"vector_search\":\"optimax_gpu\"}'" C-m
tmux send-keys -t tig "./target/release/tig-benchmarker \$ACCOUNT \$API \$SELECTED_ALGORITHMS --workers \$WORKERS --duration 30000" C-m
