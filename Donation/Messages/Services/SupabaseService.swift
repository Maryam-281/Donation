import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        let urlString = "https://dytlriqwrsyytnwjnmzp.supabase.co"
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5dGxyaXF3cnN5eXRud2pubXpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0ODkxMzgsImV4cCI6MjA4MjA2NTEzOH0.GyrUjaI_m5rs020nNLquoX_RoUU0KuNBTFSoPJK28PY"
        
        guard let url = URL(string: urlString) else {
            fatalError("⚠️ Invalid Supabase URL")
        }
        
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key
        )
        
        print("✅ Supabase initialized: \(urlString)")
    }
}
