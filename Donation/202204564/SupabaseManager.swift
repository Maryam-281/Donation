//
//  SupabaseManager.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://dytlriqwrsyytnwjnmzp.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5dGxyaXF3cnN5eXRud2pubXpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0ODkxMzgsImV4cCI6MjA4MjA2NTEzOH0.GyrUjaI_m5rs020nNLquoX_RoUU0KuNBTFSoPJK28PY"
        )
    }
}
