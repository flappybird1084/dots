#!/bin/bash

# ---------------------------------------------------------
# USB Benchmark Script for macOS
# Usage: ./usb_benchmark.sh "Name_of_Your_USB_Drive"
# ---------------------------------------------------------

# 1. Check if a Volume Name was provided
if [ -z "$1" ]; then
    echo "❌ Error: No volume name provided."
    echo "Usage: $0 \"VolumeName\""
    echo ""
    echo "To find your volume name, run: ls /Volumes/"
    exit 1
fi

VOL_NAME="$1"
VOL_PATH="/Volumes/$VOL_NAME"
TEST_FILE="._benchmark_temp_file_"
# Test size: 1024MB (1GB). Change this if you want a smaller/faster test (e.g., 512)
COUNT=1024

# 2. Check if the drive exists
if [ ! -d "$VOL_PATH" ]; then
    echo "❌ Error: The volume '$VOL_NAME' was not found at /Volumes/"
    echo "Please make sure the drive is mounted and the name is correct (case-sensitive)."
    exit 1
fi

echo "🚀 Starting Benchmark on: $VOL_PATH"
echo "⚠️  Please do not remove the drive during testing."
echo "-------------------------------------------------"

# 3. WRITE TEST
# Note: macOS dd uses 'bs=1m' (lowercase m) for 1048576 bytes.
# 'status=progress' is available on modern macOS versions (10.12+).
echo "📝 Testing WRITE Speed (Writing ${COUNT}MB file)..."
sync # Flush system buffers before we start

/usr/bin/time -h bash -c "dd if=/dev/zero of=\"$VOL_PATH/$TEST_FILE\" bs=1m count=$COUNT conv=notrunc && sync"

echo "✅ Write Complete."
echo "-------------------------------------------------"

# 4. CLEAR CACHE (Optional/MacOS limited)
# Note: Unlike Linux, macOS does not allow easy dropping of disk caches via command line
# without sudo. The Purge command clears inactive memory but might not drop file cache.
# We will run it just in case you have 'sudo' access, otherwise we ignore errors.
sudo purge 2>/dev/null || echo "ℹ️  Note: Skipping cache clear (requires sudo/less impact on MacOS)"

# 5. READ TEST
echo "📖 Testing READ Speed..."
sync

/usr/bin/time -h bash -c "dd if=\"$VOL_PATH/$TEST_FILE\" of=/dev/null bs=1m"

echo "✅ Read Complete."
echo "-------------------------------------------------"

# 6. CLEANUP
echo "🧹 Cleaning up test file..."
rm "$VOL_PATH/$TEST_FILE"

echo "✨ Benchmark Finished!"
