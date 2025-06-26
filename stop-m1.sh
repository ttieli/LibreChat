#!/bin/bash

# LibreChat M1 Stop Script
# For Apple M1/M2/M3 chips

set -e

echo "🛑 LibreChat M1 Edition - Stop Script"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info &> /dev/null; then
    print_error "Docker is not running."
    exit 1
fi

# Stop the containers
print_status "Stopping LibreChat M1 Edition..."
docker-compose -f docker-compose.m1.yml down

# Check if containers are stopped
if docker-compose -f docker-compose.m1.yml ps | grep -q "Up"; then
    print_warning "Some containers are still running:"
    docker-compose -f docker-compose.m1.yml ps
else
    print_status "✅ LibreChat M1 Edition has been stopped successfully!"
    echo ""
    echo "🔄 To start the application again, run:"
    echo "   ./start-m1.sh"
    echo ""
    echo "🗑️  To completely remove all data (careful!), run:"
    echo "   rm -rf data-mongo meili_data uploads logs"
fi