#!/bin/bash

echo "🧪 Testing Pharmacy API Endpoint..."
echo ""
echo "📡 Fetching all pharmacies from backend..."
echo ""

response=$(curl -s http://localhost:5000/api/pharmacy/get_all_pharmacy)

# Check if response contains success
if echo "$response" | grep -q '"success":true'; then
    echo "✅ API Response: SUCCESS"
    
    # Count pharmacies
    count=$(echo "$response" | grep -o '"_id"' | wc -l)
    echo "📊 Total Pharmacies Found: $count"
    echo ""
    
    # Show first pharmacy details
    echo "📋 Sample Pharmacy Data:"
    echo "$response" | python3 -m json.tool | head -n 30
else
    echo "❌ API Response: FAILED"
    echo "$response"
fi
