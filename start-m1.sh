#!/bin/bash

# LibreChat M1 Startup Script
# For Apple M1/M2/M3 chips with basic text file upload functionality

set -e

echo "🚀 LibreChat M1 Edition - Startup Script"
echo "==========================================="

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

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS (Apple M1/M2/M3 chips)"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker Desktop for Mac first."
    echo "Download from: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    print_error "Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p uploads logs data-mongo meili_data

# Check if .env.m1 exists
if [ ! -f ".env.m1" ]; then
    print_error ".env.m1 file not found!"
    print_warning "Please create .env.m1 file with your configuration."
    exit 1
fi

# Check for required environment variables
print_status "Checking environment configuration..."
if ! grep -q "JWT_SECRET=your-super-secret" .env.m1; then
    print_warning "Please update JWT_SECRET in .env.m1 file for security!"
fi

# Check if AI provider is configured
AI_CONFIGURED=false
if grep -q "OPENAI_API_KEY=" .env.m1 && ! grep -q "OPENAI_API_KEY=$" .env.m1; then
    AI_CONFIGURED=true
fi
if grep -q "OPENROUTER_API_KEY=" .env.m1 && ! grep -q "OPENROUTER_API_KEY=$" .env.m1; then
    AI_CONFIGURED=true
fi
if grep -q "ANTHROPIC_API_KEY=" .env.m1 && ! grep -q "ANTHROPIC_API_KEY=$" .env.m1; then
    AI_CONFIGURED=true
fi
if grep -q "GOOGLE_API_KEY=" .env.m1 && ! grep -q "GOOGLE_API_KEY=$" .env.m1; then
    AI_CONFIGURED=true
fi

if [ "$AI_CONFIGURED" = false ]; then
    print_warning "No AI provider API key found in .env.m1"
    print_warning "Please configure at least one AI provider (OpenAI, OpenRouter, Anthropic, or Google AI)"
fi

# Stop any existing containers
print_status "Stopping any existing containers..."
docker-compose -f docker-compose.m1.yml down 2>/dev/null || true

# Build and start the containers
print_status "Building and starting LibreChat M1 Edition..."
docker-compose -f docker-compose.m1.yml up --build -d

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 10

# Check if services are running
if docker-compose -f docker-compose.m1.yml ps | grep -q "Up"; then
    print_status "✅ LibreChat M1 Edition is now running!"
    echo ""
    echo "🌐 Access your application at: http://localhost:8732"
    echo "📊 MongoDB is available at: localhost:28017"
    echo "🔍 Meilisearch is available at: http://localhost:7701"
    echo ""
    echo "📁 File uploads are stored in: ./uploads/"
    echo "📋 Logs are stored in: ./logs/"
    echo ""
    echo "🔧 To stop the application, run:"
    echo "   docker-compose -f docker-compose.m1.yml down"
    echo ""
    echo "🔄 To restart the application, run:"
    echo "   ./start-m1.sh"
    echo ""
    echo "📖 Check the logs with:"
    echo "   docker-compose -f docker-compose.m1.yml logs -f api"
else
    print_error "Failed to start LibreChat M1 Edition"
    print_error "Check the logs with: docker-compose -f docker-compose.m1.yml logs"
    exit 1
fi