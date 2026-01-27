#!/bin/bash

# =================================================================================
# Cerebras Model Rate Limit Checker (Clean Version)
#
# This script sends a simple "hi" message to a list of specified Cerebras models
# and extracts ONLY the rate-limit headers from the API responses.
# =================================================================================

# --- Configuration ---
if [ -z "${CEREBRAS_API_KEY}" ]; then
  echo "Error: CEREBRAS_API_KEY environment variable is not set."
  echo "Please set it using: export CEREBRAS_API_KEY='your_key_here'"
  exit 1
fi

API_ENDPOINT="https://api.cerebras.ai/v1/chat/completions"
PROMPT="hi"
MODELS=("gpt-oss-120b" "qwen-3-235b-a22b-instruct-2507" "llama-3.3-70b" "zai-glm-4.7")

# --- Main Logic ---
echo "Starting rate limit checks for models: ${MODELS[*]}"
echo "========================================================"

for MODEL in "${MODELS[@]}"; do
  echo ""
  echo "--- Rate Limits for Model: ${MODEL} ---"

  # Execute the API request and pipe the full output (headers + body) to grep.
  # grep will filter out only the lines we care about.
  curl -s -D - \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer ${CEREBRAS_API_KEY}" \
    --data "{
      \"model\": \"${MODEL}\",
      \"stream\": false,
      \"messages\": [{\"content\": \"${PROMPT}\", \"role\": \"user\"}],
      \"temperature\": 0,
      \"max_completion_tokens\": -1,
      \"seed\": 0,
      \"top_p\": 1
    }" \
    "${API_ENDPOINT}" | grep -i "x-ratelimit"

  echo "----------------------------------------"
done

echo ""
echo "========================================================"
echo "All checks complete."
