#!/bin/bash

# MythicDungeonTools Deployment Script
# This script copies the addon files to the World of Warcraft AddOns directory
# Excludes development files and only copies release-ready content

set -e

SOURCE_DIR="/home/jonathan/projects/MythicDungeonTools"
TARGET_DIR="/mnt/c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns/MythicDungeonTools"

echo "MythicDungeonTools Deployment Script"
echo "====================================="
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Check if WoW is installed
if [ ! -d "/mnt/c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns" ]; then
    echo "Error: World of Warcraft AddOns directory not found"
    echo "Make sure WoW is installed and the path is correct"
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Remove existing files in target directory
echo "Cleaning target directory..."
rm -rf "$TARGET_DIR"/*

# Copy essential addon files
echo "Copying addon files..."

# Copy main addon files
cp "$SOURCE_DIR"/*.lua "$TARGET_DIR/" 2>/dev/null || true
cp "$SOURCE_DIR"/*.xml "$TARGET_DIR/" 2>/dev/null || true
cp "$SOURCE_DIR"/*.toc "$TARGET_DIR/" 2>/dev/null || true
cp "$SOURCE_DIR"/CHANGELOG.txt "$TARGET_DIR/" 2>/dev/null || true
cp "$SOURCE_DIR"/LICENSE "$TARGET_DIR/" 2>/dev/null || true

# Copy directories that are needed for the addon
echo "Copying addon directories..."
for dir in AceGUIWidgets Locales MistsOfPandaria Modules Textures TheWarWithin libs; do
    if [ -d "$SOURCE_DIR/$dir" ]; then
        echo "  Copying $dir/..."
        cp -r "$SOURCE_DIR/$dir" "$TARGET_DIR/"
    fi
done

# Copy Developer directory (contains runtime components)
if [ -d "$SOURCE_DIR/Developer" ]; then
    echo "  Copying Developer/..."
    cp -r "$SOURCE_DIR/Developer" "$TARGET_DIR/"
fi

# Remove any development files that might have been copied
echo "Cleaning up development files..."
find "$TARGET_DIR" -name "*.md" -delete 2>/dev/null || true
find "$TARGET_DIR" -name ".git*" -delete 2>/dev/null || true
find "$TARGET_DIR" -name "*.json" -delete 2>/dev/null || true
find "$TARGET_DIR" -name ".editorconfig" -delete 2>/dev/null || true
find "$TARGET_DIR" -name "pkgmeta.yaml" -delete 2>/dev/null || true

# Set proper permissions
echo "Setting permissions..."
chmod -R 755 "$TARGET_DIR"

echo ""
echo "Deployment completed successfully!"
echo "MythicDungeonTools has been deployed to:"
echo "$TARGET_DIR"
echo ""
echo "You can now start World of Warcraft and the addon should be available."