//
//  FirebaseManager.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 28.08.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreInternal

class FirebaseManager {
    
    static let shared = FirebaseManager()
    let database = Firestore.firestore()
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(authResult))
            }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[UserInfo], Error>) -> Void) {
        database.collection("Users").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                var allUsers = [UserInfo]()
                for document in snapshot.documents {
                    let dict = document.data()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: dict) {
                        do {
                            let user = try JSONDecoder().decode(UserInfo.self, from: jsonData)
                            allUsers.append(user)
                        } catch {
                            completion(.failure(error))
                            return
                        }
                    }
                }
                completion(.success(allUsers))
            }
        }
    }
    
    func createUser(email: String, password: String, userData: [String: Any], completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                self.database.collection("Users").document(email).setData(userData) { firestoreError in
                    if let firestoreError = firestoreError {
                        completion(.failure(firestoreError))
                    } else {
                        completion(.success(authResult))
                    }
                }
            }
        }
    }
}
