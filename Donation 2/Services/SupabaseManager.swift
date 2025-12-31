//
//  SupabaseManager.swift
//  Donation
//
//  Created by BP-36-201-19 on 31/12/2025.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init(){
        //Loading credentials from the Config.plist file
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let urlString = config["SUPABASE_URL"],
              let url = URL(string: urlString as! String),
              let key = config["SUPABASE_ANON_KEY"] as? String else {
            fatalError("Missing supabase configuration in Config.plist")
        }
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key
        )
        
        print("Supabase initialized: \(urlString)")
    }
}
