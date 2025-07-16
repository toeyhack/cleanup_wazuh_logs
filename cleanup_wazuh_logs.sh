#!/bin/bash

DAYS_TO_KEEP=0
LOG_DIR="/var/ossec/logs/alerts"

# ใช้ array เพื่อเก็บรายชื่อไฟล์ปกติ (เพื่อ count และแสดง)
file_list=$(find "$LOG_DIR" -type f \( -name "*.json.gz" -o -name "*.log.gz" -o -name "*.sum" \) -mtime +$DAYS_TO_KEEP)
if [ -z "$file_list" ]; then
  echo "❌ ไม่พบไฟล์เก่ากว่า $DAYS_TO_KEEP วัน"
  exit 0
fi

file_count=$(echo "$file_list" | wc -l)

# คำนวณขนาดรวม โดยใช้ -print0 โดยตรงใน pipeline ไม่เก็บลงตัวแปร
total_size=$(find "$LOG_DIR" -type f \( -name "*.json.gz" -o -name "*.log.gz" -o -name "*.sum" \) -mtime +$DAYS_TO_KEEP -print0 | du --files0-from=- -ch | grep total$ | awk '{print $1}')

echo "🧾 พบไฟล์จำนวน $file_count รายการ ที่เก่ากว่า $DAYS_TO_KEEP วัน"
echo "📦 ใช้พื้นที่ทั้งหมด $total_size"
read -rp "❓ ต้องการลบไฟล์เหล่านี้ทั้งหมดหรือไม่? (y/N): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
  echo "🗑️ กำลังลบไฟล์..."
  # ลบโดยใช้ find -print0 ส่งเข้า xargs -0 โดยตรง
  find "$LOG_DIR" -type f \( -name "*.json.gz" -o -name "*.log.gz" -o -name "*.sum" \) -mtime +$DAYS_TO_KEEP -print0 | xargs -0 rm -v
  echo "✅ ลบไฟล์เรียบร้อยแล้ว"
else
  echo "❎ ยกเลิกการลบไฟล์"
fi
