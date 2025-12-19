#!/bin/bash
set -euo pipefail

# Validation script for Paper2Slides environment configuration
# This script helps verify that all required environment variables are set

echo "🔍 Validating Paper2Slides Environment Configuration"
echo "======================================================"

ERRORS=0
WARNINGS=0

# Function to check if a variable is set
check_var() {
    local var_name=$1
    local var_value=$2
    local required=$3
    
    if [ -z "$var_value" ]; then
        if [ "$required" = "true" ]; then
            echo "❌ ERROR: $var_name is not set (REQUIRED)"
            ((ERRORS++))
        else
            echo "⚠️  WARNING: $var_name is not set (OPTIONAL)"
            ((WARNINGS++))
        fi
        return 1
    else
        echo "✅ $var_name is set"
        return 0
    fi
}

echo ""
echo "📝 Checking Required Environment Variables..."
echo "----------------------------------------------"

# Required LLM variables
check_var "RAG_LLM_API_KEY" "$RAG_LLM_API_KEY" "true"
check_var "RAG_LLM_BASE_URL" "$RAG_LLM_BASE_URL" "true"

# Required Image Generation variables
check_var "IMAGE_GEN_PROVIDER" "$IMAGE_GEN_PROVIDER" "true"
check_var "IMAGE_GEN_API_KEY" "$IMAGE_GEN_API_KEY" "true"
check_var "IMAGE_GEN_BASE_URL" "$IMAGE_GEN_BASE_URL" "true"
check_var "IMAGE_GEN_MODEL" "$IMAGE_GEN_MODEL" "true"

echo ""
echo "📝 Checking Optional Environment Variables..."
echo "----------------------------------------------"

# Optional variables
check_var "RAG_LLM_MAX_TOKENS" "$RAG_LLM_MAX_TOKENS" "false"
check_var "IMAGE_GEN_RESPONSE_MIME_TYPE" "$IMAGE_GEN_RESPONSE_MIME_TYPE" "false"
check_var "GOOGLE_GENAI_BASE_URL" "$GOOGLE_GENAI_BASE_URL" "false"
check_var "BACKEND_PORT" "$BACKEND_PORT" "false"
check_var "FRONTEND_PORT" "$FRONTEND_PORT" "false"
check_var "VITE_API_URL" "$VITE_API_URL" "false"

echo ""
echo "📁 Checking File System..."
echo "----------------------------------------------"

# Check if .env file exists for paper2slides module
if [ -f "/app/paper2slides/.env" ]; then
    echo "✅ /app/paper2slides/.env exists"
    
    # Check if it has the required keys
    if grep -q "RAG_LLM_API_KEY" /app/paper2slides/.env && \
       grep -q "IMAGE_GEN_API_KEY" /app/paper2slides/.env; then
        echo "✅ /app/paper2slides/.env contains required API keys"
    else
        echo "⚠️  WARNING: /app/paper2slides/.env may be missing required keys"
        ((WARNINGS++))
    fi
else
    echo "❌ ERROR: /app/paper2slides/.env does not exist"
    echo "   This file is required for the Paper2Slides Python module"
    echo "   Create it with your API keys or mount it as a volume"
    ((ERRORS++))
fi

# Check outputs directory
if [ -d "/app/outputs" ]; then
    echo "✅ /app/outputs directory exists"
else
    echo "⚠️  WARNING: /app/outputs directory does not exist"
    echo "   Creating it now..."
    mkdir -p /app/outputs && echo "✅ Created /app/outputs" || echo "❌ Failed to create /app/outputs"
fi

echo ""
echo "🔍 Image Generation Provider Check..."
echo "----------------------------------------------"

if [ "$IMAGE_GEN_PROVIDER" = "google" ]; then
    echo "📌 Using Google Gemini for image generation"
    if [ -z "$GOOGLE_GENAI_BASE_URL" ]; then
        echo "⚠️  WARNING: GOOGLE_GENAI_BASE_URL not set, will use default"
        ((WARNINGS++))
    fi
elif [ "$IMAGE_GEN_PROVIDER" = "openrouter" ]; then
    echo "📌 Using OpenRouter for image generation"
else
    echo "⚠️  WARNING: Unknown IMAGE_GEN_PROVIDER: $IMAGE_GEN_PROVIDER"
    echo "   Expected 'google' or 'openrouter'"
    ((WARNINGS++))
fi

echo ""
echo "======================================================"
echo "📊 Validation Summary"
echo "======================================================"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "🎉 All checks passed! Your environment is properly configured."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "✅ No critical errors found"
    echo "⚠️  $WARNINGS warning(s) - review optional configurations"
    exit 0
else
    echo "❌ $ERRORS error(s) found - please fix before deploying"
    echo "⚠️  $WARNINGS warning(s)"
    echo ""
    echo "💡 Tip: Make sure all required environment variables are set in Coolify"
    echo "    and /app/paper2slides/.env file exists with API keys"
    exit 1
fi
