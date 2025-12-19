#!/bin/sh
# This script is called when Nixpacks tries to deploy Paper2Slides
# Paper2Slides MUST be deployed with Docker Compose, not Nixpacks

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                            ERROR                                   ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Paper2Slides must be deployed with Docker Compose, not Nixpacks."
echo ""
echo "Please configure Coolify to use 'Docker Compose' as the build pack."
echo ""
echo "See QUICKSTART_COOLIFY.md or DEPLOYMENT.md for detailed instructions."
echo ""
echo "Why? Paper2Slides is a multi-service application (backend + frontend)"
echo "that requires Docker Compose for proper orchestration."
echo ""
exit 1