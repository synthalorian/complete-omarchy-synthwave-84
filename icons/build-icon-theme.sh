#!/bin/bash
# Build script for cyberpunk-technotronic-rebuilt icon theme
# Run this after extracting the source theme to generate all size directories

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="$SCRIPT_DIR/cyberpunk-technotronic-icon-theme"
REBUILT="$SCRIPT_DIR/cyberpunk-technotronic-rebuilt"

if [ ! -d "$BASE" ]; then
    echo "Error: Source theme not found at $BASE"
    echo "Please extract the original cyberpunk-technotronic-icon-theme first"
    exit 1
fi

SIZES=(16 22 24 32 48 64)
SCALABLE_SIZE=64

echo "Building cyberpunk-technotronic-rebuilt icon theme..."

# Clean up previous build
if [ -d "$REBUILT" ]; then
    rm -rf "$REBUILT"
fi

# Copy source
cp -r "$BASE" "$REBUILT"

# Python script to add width/height to SVGs
python3 << 'PYTHON'
import os
import re

rebuilt = os.environ.get("REBUILT")
sizes = [16, 22, 24, 32, 48, 64]
scalable_size = 64

def add_dimensions(svg_content, size):
    size_str = str(size)
    has_width = re.search(r'<svg[^>]*\swidth="', svg_content) is not None
    has_height = re.search(r'<svg[^>]*\sheight="', svg_content) is not None
    
    if has_width and has_height:
        svg_content = re.sub(r'width="[^"]*"', f'width="{size_str}"', svg_content, count=1)
        svg_content = re.sub(r'height="[^"]*"', f'height="{size_str}"', svg_content, count=1)
    elif has_width:
        svg_content = re.sub(r'(width="[^"]*")', r'\1 height="' + size_str + '"', svg_content, count=1)
    elif has_height:
        svg_content = re.sub(r'(height="[^"]*")', r'width="' + size_str + r'" \1', svg_content, count=1)
    else:
        svg_content = re.sub(r'(<svg\s)', r'\1width="' + size_str + '" height="' + size_str + '" ', svg_content, count=1)
    
    return svg_content

def process_svg_file(src_path, dest_dir, size):
    with open(src_path, 'r') as f:
        svg_content = f.read()
    svg_content = add_dimensions(svg_content, size)
    os.makedirs(dest_dir, exist_ok=True)
    dest_path = os.path.join(dest_dir, os.path.basename(src_path))
    with open(dest_path, 'w') as f:
        f.write(svg_content)

def ensure_real_dir(path):
    if os.path.islink(path):
        os.unlink(path)
    if not os.path.exists(path):
        os.makedirs(path, exist_ok=True)

def process_category(category_name):
    src_dir = os.path.join(rebuilt, category_name, "16")
    if not os.path.exists(src_dir):
        return
    
    icons = [f for f in os.listdir(src_dir) if f.endswith('.svg')]
    
    for icon in icons:
        src_path = os.path.join(src_dir, icon)
        if os.path.islink(src_path):
            continue
        for size in sizes:
            dest_dir = os.path.join(rebuilt, f"{category_name}/{size}")
            ensure_real_dir(dest_dir)
            process_svg_file(src_path, dest_dir, size)
        dest_dir = os.path.join(rebuilt, f"{category_name}/scalable")
        ensure_real_dir(dest_dir)
        process_svg_file(src_path, dest_dir, scalable_size)
    
    for icon in icons:
        src_path = os.path.join(src_dir, icon)
        if os.path.islink(src_path):
            link_target = os.readlink(src_path)
            for size in sizes:
                dest_dir = os.path.join(rebuilt, f"{category_name}/{size}")
                ensure_real_dir(dest_dir)
                dest_link = os.path.join(dest_dir, icon)
                if os.path.exists(dest_link) or os.path.islink(dest_link):
                    os.remove(dest_link)
                os.symlink(link_target, dest_link)
            dest_dir = os.path.join(rebuilt, f"{category_name}/scalable")
            ensure_real_dir(dest_dir)
            dest_link = os.path.join(dest_dir, icon)
            if os.path.exists(dest_link) or os.path.islink(dest_link):
                os.remove(dest_link)
            os.symlink(link_target, dest_link)

categories = []
for item in os.listdir(rebuilt):
    item_path = os.path.join(rebuilt, item)
    if os.path.isdir(item_path) and os.path.exists(os.path.join(item_path, "16")):
        categories.append(item)

for cat in categories:
    process_category(cat)

# Fix XML spacing
fixed_count = 0
for root, dirs, files in os.walk(rebuilt):
    for file in files:
        if file.endswith('.svg'):
            path = os.path.join(root, file)
            with open(path, 'r') as f:
                content = f.read()
            original = content
            content = re.sub(r'"xmlns=', '" xmlns=', content)
            content = re.sub(r'"version=', '" version=', content)
            if content != original:
                with open(path, 'w') as f:
                    f.write(content)
                fixed_count += 1

print(f"Fixed {fixed_count} SVG files")

# Fix Nautilus symlinks
for size in sizes:
    nautilus_link = os.path.join(rebuilt, f"apps/{size}/org.gnome.Nautilus.svg")
    if os.path.islink(nautilus_link):
        os.remove(nautilus_link)
        os.symlink("nautilus.svg", nautilus_link)

print("Build complete!")
PYTHON

# Update index.theme to include 64 directories
python3 << 'PYTHON'
import os
import re

rebuilt = os.environ.get("REBUILT")
index_path = os.path.join(rebuilt, "index.theme")
with open(index_path, 'r') as f:
    content = f.read()

lines = content.split('\n')
contexts = {
    'actions': 'Actions', 'apps': 'Applications', 'categories': 'Categories',
    'devices': 'Devices', 'emblems': 'Emblems', 'emotes': 'Emotes',
    'intl': 'International', 'mimetypes': 'MimeTypes', 'panel': 'Status',
    'places': 'Places', 'status': 'Status', 'stock': 'Stock',
}

# Add to Directories= line
for i, line in enumerate(lines):
    if line.startswith('Directories='):
        dirs = line.replace('Directories=', '').split(',')
        new_dirs = []
        for d in dirs:
            new_dirs.append(d)
            for cat in contexts:
                if d == f"{cat}/48@2x" and os.path.exists(os.path.join(rebuilt, f"{cat}/64")):
                    new_dirs.append(f"{cat}/64")
        lines[i] = 'Directories=' + ','.join(new_dirs)
        break

# Add [category/64] sections after [category/48@2x]
new_lines = []
i = 0
while i < len(lines):
    line = lines[i]
    new_lines.append(line)
    
    match = re.match(r'^\[(\w+)/48@2x\]', line)
    if match:
        cat = match.group(1)
        if cat in contexts and os.path.exists(os.path.join(rebuilt, f"{cat}/64")):
            # Skip to end of this section
            j = i + 1
            while j < len(lines) and not lines[j].startswith('['):
                new_lines.append(lines[j])
                j += 1
            new_lines.append('')
            new_lines.append(f'[{cat}/64]')
            new_lines.append(f'Context={contexts[cat]}')
            new_lines.append('Size=64')
            new_lines.append('Type=Fixed')
            i = j - 1
    
    i += 1

with open(index_path, 'w') as f:
    f.write('\n'.join(new_lines))

print("Updated index.theme")
PYTHON

# Fix file manager symlinks to point to nautilus.svg (not 16px panel icon)
for size in "${SIZES[@]}" scalable; do
    for dir in apps categories; do
        base="$REBUILT/$dir/$size"
        [ -d "$base" ] || continue
        
        for icon in system-file-manager.svg file-manager.svg org.gnome.Files.svg org.gnome.files.svg dde-file-manager.svg nautilus-actions.svg; do
            path="$base/$icon"
            [ -e "$path" ] || continue
            
            if [ -L "$path" ]; then
                target=$(readlink "$path")
                case "$target" in
                    nautilus.svg|file-manager.svg|system-file-manager.svg)
                        rm -f "$path"
                        ln -s nautilus.svg "$path"
                        ;;
                esac
            elif [ -f "$path" ]; then
                if grep -q 'transform="matrix(0.34042553' "$path" 2>/dev/null; then
                    rm -f "$path"
                    ln -s nautilus.svg "$path"
                fi
            fi
        done
    done
done

# Fix Alacritty (broken tiny paths) to use terminal.svg
for size in "${SIZES[@]}" scalable; do
    for dir in apps categories; do
        base="$REBUILT/$dir/$size"
        [ -f "$base/Alacritty.svg" ] || continue
        if grep -q 'transform="matrix(0.34042553' "$base/Alacritty.svg" 2>/dev/null || \
           grep -q 'd="m 0.2' "$base/Alacritty.svg" 2>/dev/null; then
            rm -f "$base/Alacritty.svg"
            ln -s terminal.svg "$base/Alacritty.svg"
        fi
    done
done

echo "Build complete: $REBUILT"
echo "To install: cp -r $REBUILT ~/.icons/"
