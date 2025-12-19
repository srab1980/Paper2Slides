#!/bin/bash
set -euo pipefail

# Health check script for Paper2Slides deployment
# Can be used to verify that the application is running correctly

BACKEND_URL=${1:-"http://localhost:8000"}
FRONTEND_URL=${2:-"http://localhost:5173"}

echo "🏥 Paper2Slides Health Check"
echo "=============================="
echo "Backend URL: $BACKEND_URL"
echo "Frontend URL: $FRONTEND_URL"
echo ""

# Check backend health endpoint
echo "🔍 Checking backend health..."
BACKEND_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health" || echo "000")

if [ "$BACKEND_RESPONSE" = "200" ]; then
    echo "✅ Backend is healthy (HTTP $BACKEND_RESPONSE)"
    
    # Get backend health details
    HEALTH_DATA=$(curl -s "$BACKEND_URL/health")
    echo "   Response: $HEALTH_DATA"
else
    echo "❌ Backend is not responding (HTTP $BACKEND_RESPONSE)"
    exit 1
fi

echo ""

# Check backend root endpoint
echo "🔍 Checking backend API root..."
ROOT_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/" || echo "000")

if [ "$ROOT_RESPONSE" = "200" ]; then
    echo "✅ Backend API root is accessible (HTTP $ROOT_RESPONSE)"
else
    echo "⚠️  Backend API root returned HTTP $ROOT_RESPONSE"
fi

echo ""

# Check if backend API docs are accessible
echo "🔍 Checking backend API documentation..."
DOCS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/docs" || echo "000")

if [ "$DOCS_RESPONSE" = "200" ]; then
    echo "✅ API documentation is accessible at $BACKEND_URL/docs"
else
    echo "⚠️  API documentation returned HTTP $DOCS_RESPONSE"
fi

echo ""

# Check frontend
echo "🔍 Checking frontend..."
FRONTEND_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$FRONTEND_URL/" || echo "000")

if [ "$FRONTEND_RESPONSE" = "200" ]; then
    echo "✅ Frontend is accessible (HTTP $FRONTEND_RESPONSE)"
else
    echo "❌ Frontend is not responding (HTTP $FRONTEND_RESPONSE)"
    exit 1
fi

echo ""
echo "=============================="
echo "🎉 Health Check Complete!"
echo "=============================="
echo ""
echo "📊 Summary:"
echo "  Backend: $BACKEND_URL"
echo "  Frontend: $FRONTEND_URL"
echo "  API Docs: $BACKEND_URL/docs"
echo ""
echo "✅ All services are operational"
exit 0
