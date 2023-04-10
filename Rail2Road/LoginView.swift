//
//  LoginView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import FirebaseAuth


struct LoginView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var rememberUser: Bool = false
    @State private var tryAgainLater: Bool = false
    @State private var networkError: Bool = false
    @State private var failed: Bool = false
    @State private var uid: String = ""
    
    private func checkKeychain() {
        email = getStoredPassword(account: "email")
        password = getStoredPassword(account: "password")
        rememberUser = (!email.isEmpty && !password.isEmpty)
    }
    
    private func authenticate() {
        failed = false
        networkError = false
        tryAgainLater = false
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if((result) != nil) {
//                print("success!")
//                print(result!.user.uid)
                uid = result!.user.uid
                if(rememberUser) {
                    updateStoredPassword(account: "email", password: email)
                    updateStoredPassword(account: "password", password: password)
                } else {
                    deleteStoredPassword(account: "email")
                    deleteStoredPassword(account: "password")
                }
                isAuthenticated = true
                failed = false
            }
            else {
//                isAuthenticated = false
//                failed = true
//                print("ERROR")
//                print(error!)
                let errorCode = (error as NSError?)!.code
                if(errorCode == 17010) {
                    tryAgainLater = true
                } else if(errorCode == 17020) {
                    networkError = true
                }
                isAuthenticated = false
                failed = true
            }
        }
    }
    
    func getStoredPassword(account: String) -> String {
      let kcw = KeychainWrapper()
      if let password = try? kcw.getGenericPasswordFor(
        account: account,
        service: "Rail2Road") {
        return password
      }

      return ""
    }

    func updateStoredPassword(account: String, password: String) {
      let kcw = KeychainWrapper()
      do {
        try kcw.storeGenericPasswordFor(
          account: account,
          service: "Rail2Road",
          password: password)
      } catch let error as KeychainWrapperError {
        print("Exception setting password: \(error.message ?? "no message")")
      } catch {
        print("An error occurred setting the password.")
      }
    }
    
    func deleteStoredPassword(account: String) {
        let kcw = KeychainWrapper()
        do {
            try kcw.deleteGenericPasswordFor(
                account: account,
                service: "Rail2Road")
        } catch let error as KeychainWrapperError {
            print("Exception deleting password: \(error.message ?? "no message")")
        } catch {
            print("An error occurred deleting the password.")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Rail2Road")
                    .font(.title)
                    .bold()
                TextField("Email", text: $email)
                    .font(.title3)
            
                SecureField("Password", text: $password)
                    .font(.title3)
                
                Toggle("Remember me", isOn: $rememberUser)
            
                NavigationLink(
                    destination: MapView(uid: uid)
                        .environmentObject(database)
                        .environmentObject(dataConglomerate),
                    isActive: $isAuthenticated) {
                    Button(action: {
                        authenticate()
                    }) {
                        Text("Login")
                            .font(.title3)
                    }
                        .buttonStyle(.borderedProminent)
                }
                if(tryAgainLater) {
                    Text("Reset passowrd or try again later")
                } else if(networkError) {
                    Text("Network error")
                } else if(failed) {
                    Text("Incorrect credentials")
                }
                
                Spacer()
                
                NavigationLink(
                    destination: ResetView()) {
                    Text("Reset Password")
                        .font(.title3)
                }
                    .buttonStyle(.bordered)
                NavigationLink(
                    destination: RegisterView()
                        .environmentObject(database)
                        .environmentObject(dataConglomerate)) {
                    Text("Register")
                        .font(.title3)
                }
                    .buttonStyle(.bordered)
            }
                .padding()
        }
            .navigationBarTitle("Rail2Road")
            .navigationBarHidden(true)
            .onAppear {
                checkKeychain()
                hideKeyboard()
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
