#!/bin/bash

# Exit on error
set -e

# Create output directory if it doesn't exist
mkdir -p docs

# CSS styles for better readability
CSS_STYLE='
body { max-width: 800px; margin: 40px auto; padding: 0 20px; font-family: system-ui, -apple-system, sans-serif; line-height: 1.6; }
pre { background: #f4f4f4; padding: 15px; border-radius: 5px; overflow-x: auto; }
code { background: #f4f4f4; padding: 2px 5px; border-radius: 3px; }
'

# Find all index.md files and convert them
find . -name "index.md" | while read -r file; do
    # Get the directory containing the markdown file
    dir=$(dirname "$file")
    
    # Create corresponding output directory
    mkdir -p "docs/$dir"
    
    echo "Converting $file to docs/$dir/index.html"
    
    # Convert markdown to HTML with pandoc
    pandoc "$file" \
        -f markdown \
        -t html \
        -s \
        -o "docs/$dir/index.html" \
        --css="style.css" \
        --toc \
        --toc-depth=3

    # If this is the first file, create the CSS file
    if [ ! -f "docs/style.css" ]; then
        echo "$CSS_STYLE" > "docs/style.css"
    fi
done

echo "Build complete! Files are in the docs directory."