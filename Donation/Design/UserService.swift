import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserService {

    static let shared = UserService()
    private init() {}

    private let db = Firestore.firestore()

    // ✅ الأفضل: يكون Document ID = uid
    func fetchCurrentUserRole(completion: @escaping (UserRole?) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        db.collection("users").document(uid).getDocument { snap, error in
            if let error = error {
                print("❌ fetch role error:", error.localizedDescription)
                completion(nil)
                return
            }

            let roleString = snap?.data()?["role"] as? String
            let role = UserRole(rawValue: roleString ?? "")
            completion(role)
        }
    }

    // ✅ لو عندك الدوكيومنت مو uid وتبين تبحث بالإيميل:
    func fetchRoleByEmail(_ email: String, completion: @escaping (UserRole?) -> Void) {
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments { snap, error in

                if let error = error {
                    print("❌ fetch role by email error:", error.localizedDescription)
                    completion(nil)
                    return
                }

                let doc = snap?.documents.first
                let roleString = doc?.data()["role"] as? String
                completion(UserRole(rawValue: roleString ?? ""))
            }
    }
}
