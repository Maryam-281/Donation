//
//  SupabaseConfig.swift
//  Donation
//
//  Created by Claude
//

import Foundation

struct SupabaseConfig {
    // ✅ Your Supabase Project URL (ALREADY FILLED IN!)
    static let supabaseURL = "https://dytlriqwrsyytnwjnmzp.supabase.co"
    
    // ⚠️ YOU NEED TO ADD YOUR ANON KEY HERE:
    // 1. Go to https://supabase.com/dashboard/project/dytlriqwrsyytnwjnmzp/settings/api
    // 2. Scroll down to "Project API keys"
    // 3. Copy the "anon" "public" key (the long string starting with eyJ...)
    // 4. Paste it below (replace the text between the quotes)
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5dGxyaXF3cnN5eXRud2pubXpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0ODkxMzgsImV4cCI6MjA4MjA2NTEzOH0.GyrUjaI_m5rs020nNLquoX_RoUU0KuNBTFSoPJK28PY"  // ← PASTE YOUR KEY HERE!
    
    // MARK: - Table Names
    struct Tables {
        static let users = "User"
        static let reports = "Report"
    }
    
    // MARK: - Storage Buckets
    struct Buckets {
        static let profileImages = "profile-images"
    }
}
