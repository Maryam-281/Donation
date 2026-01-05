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
            supabaseKey: "sb_secret_fh0dZFvyy2agGx8pv0ngBg_O73Jd2rE",
        )
    }
}
