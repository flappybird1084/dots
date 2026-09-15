deepseek() {
    local M="accounts/fireworks/models/deepseek-v4p1-flash[1m]"
      ANTHROPIC_BASE_URL="https://api.fireworks.ai/inference" \
          ANTHROPIC_AUTH_TOKEN="$FIREWORKS_API_KEY" \
            ANTHROPIC_CUSTOM_HEADERS="X-Fireworks-Api-Key: $FIREWORKS_API_KEY" \
              ANTHROPIC_MODEL="$M" \
                ANTHROPIC_DEFAULT_OPUS_MODEL="$M" \
                  ANTHROPIC_DEFAULT_SONNET_MODEL="$M" \
                    ANTHROPIC_DEFAULT_HAIKU_MODEL="$M" \
                      ANTHROPIC_DEFAULT_FABLE_MODEL="$M" \
                        ANTHROPIC_SMALL_FAST_MODEL="$M" \
                          CLAUDE_CODE_SUBAGENT_MODEL="$M" \
                            CLAUDE_CODE_AUTO_COMPACT_WINDOW=786432 \
                              CLAUDE_CODE_EFFORT_LEVEL=max \
                                claude "$@"
                              }
