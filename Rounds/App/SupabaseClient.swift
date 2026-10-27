import Foundation
import Supabase

/// Shared Supabase client. Returns nil until Config/Secrets.xcconfig is filled in —
/// see "Backend" in the README.
enum Backend {
    static let client: SupabaseClient? = {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let url = URL(string: urlString),
            let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
            !key.isEmpty
        else { return nil }
        return SupabaseClient(supabaseURL: url, supabaseKey: key)
    }()
}
