#!/bin/bash

# LibreChat M1 Git Initialization Script
# Initialize as local Git repository (no remote)

set -e

echo "📦 LibreChat M1 - Git Initialization"
echo "===================================="

# Colors for output
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

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_warning "Git is not installed. Please install Git first."
    exit 1
fi

# Check if already a git repository
if [ -d ".git" ]; then
    print_warning "Already a Git repository."
    echo "Current status:"
    git status --short
    exit 0
fi

# Initialize git repository
print_status "Initializing local Git repository..."
git init

# Create .gitignore for M1 edition
print_status "Creating .gitignore for M1 edition..."
cat > .gitignore << 'EOF'
# LibreChat M1 Edition - Git Ignore

# Environment files (contain sensitive data)
.env*
!.env.m1
.env.m1.local

# Node modules
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
data-mongo/
meili_data/
uploads/
logs/

# Docker volumes
volumes/

# Temporary files
*.tmp
*.temp
temp/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Build outputs
dist/
build/
*.tgz

# Coverage directory used by tools like istanbul
coverage/

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env

# Runtime configuration
librechat.yaml
!librechat.m1.yaml

# Backup files
*.backup
*.bak

# Log files
*.log

# Docker-specific ignores
docker-compose.override.yml
!docker-compose.m1.yml
EOF

# Add all files to git
print_status "Adding files to Git..."
git add .

# Initial commit
print_status "Creating initial commit..."
git commit -m "Initial commit: LibreChat M1 Edition

- Optimized for Apple M1/M2/M3 chips
- Basic text file upload functionality
- Non-standard ports (8732, 28017, 7701)
- Removed RAG complexity
- Local Git repository (no remote)"

print_status "✅ Git repository initialized successfully!"
echo ""
echo "📋 Repository summary:"
echo "   - Branch: $(git branch --show-current)"
echo "   - Commits: $(git rev-list --count HEAD)"
echo "   - Files tracked: $(git ls-files | wc -l | tr -d ' ')"
echo ""
echo "🔧 Useful Git commands:"
echo "   git status          # Check repository status"
echo "   git log --oneline   # View commit history"
echo "   git add .           # Add all changes"
echo "   git commit -m 'msg' # Commit changes"