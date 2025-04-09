#!/bin/bash

# Set minimum version you want to enforce
TARGET_VERSION="3.25"

# Start from current directory
echo "🔍 Searching for outdated cmake_minimum_required lines..."
find . -name "CMakeLists.txt" | while read -r file; do
    if grep -q "cmake_minimum_required(VERSION" "$file"; then
        current_version=$(grep -oP 'cmake_minimum_required\s*\(VERSION\s*\K[0-9.]+(?=\))' "$file")
        if [[ "$current_version" < "3.5" ]]; then
            echo "✍️  Updating $file (was VERSION $current_version)"
            sed -i "s/cmake_minimum_required(VERSION [0-9.]\+)/cmake_minimum_required(VERSION $TARGET_VERSION)/" "$file"
        fi
    fi
done

echo "✅ All matching CMakeLists.txt files updated to version $TARGET_VERSION."

