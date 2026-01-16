#!/bin/bash
set -e

# --- Configuration & Path Portability ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRD_FILE="$SCRIPT_DIR/ralph_prd.json"
PROGRESS_FILE="$SCRIPT_DIR/ralph_progress.txt"
PROMPT_FILE="$SCRIPT_DIR/ralph_prompt.md"

MAX_ITERATIONS=${1:-10}

# 1. Validation & Pre-flight Sanity Check
if [ ! -f "$PROMPT_FILE" ] || [ ! -f "$PRD_FILE" ]; then
  echo "❌ Error: Ensure both prompt.md and prd.json exist in $SCRIPT_DIR"
  exit 1
fi

# Check if JSON is valid before starting (prevents wasting API credits)
if ! jq '.' "$PRD_FILE" > /dev/null 2>&1; then
  echo "❌ Error: prd.json is malformed or has syntax errors. Please fix it before running."
  exit 1
fi

# 2. Progress Log Initialization
if [ ! -f "$PROGRESS_FILE" ]; then
  echo "# AI Agent Progress Log" > "$PROGRESS_FILE"
  echo "Started: $(date)" >> "$PROGRESS_FILE"
  echo "---" >> "$PROGRESS_FILE"
fi

echo "🚀 Starting Agent Loop - Max iterations: $MAX_ITERATIONS"

# 3. The Loop
for ((i=1; i<=$MAX_ITERATIONS; i++)); do
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  Iteration $i of $MAX_ITERATIONS"
  echo "═══════════════════════════════════════════════════════"

  # Streaming Output & Graceful Failure
  # result captures the output, while 'tee' shows it to you live
  result=$(docker sandbox run claude --permission-mode acceptEdits \
    -p "@$PRD_FILE @$PROGRESS_FILE $(cat "$PROMPT_FILE")" 2>&1 | tee /dev/stderr) || true

  # 4. Completion Check
  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo ""
    echo "✅ SUCCESS: Task marked as COMPLETE."
    echo "Completed at iteration $i."
    exit 0
  fi

  # 5. Iteration Pacing
  echo -e "\n--- End of Iteration $i ---"
  [ $i -lt $MAX_ITERATIONS ] && sleep 2
done

# 6. Status Summary
echo ""
echo "═══════════════════════════════════════════════════════"
echo "🛑 LOOP TERMINATED"
echo "═══════════════════════════════════════════════════════"
echo "Reached max iterations ($MAX_ITERATIONS) without a COMPLETE signal."
echo "Last status update available in: $PROGRESS_FILE"
exit 1