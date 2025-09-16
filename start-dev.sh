#!/bin/bash

set -e

export POSTGRES_DATABASE=school
export POSTGRES_USER=root
export POSTGRES_PASSWORD=root
export APP_URL=http://localhost:8080
export DEBUG=true

SESSION_NAME="dev_session"

tmux new-session -d -s $SESSION_NAME

# Pane 0: frontend
tmux send-keys -t $SESSION_NAME:0.0 "cd frontend &&  npm run dev -- --port 8080 --host $HOST" C-m

# Split and start api in pane 1
tmux split-window -v -t $SESSION_NAME
tmux send-keys -t $SESSION_NAME:0.1 "cd backend/core && uv run python manage.py runserver $HOST:8000" C-m

# Optional: Bind 'x' (after Ctrl+b) to kill the session
tmux bind-key -n C-x kill-session

# Attach to the session
tmux attach -t $SESSION_NAME