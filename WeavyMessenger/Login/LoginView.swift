//
//  LoginView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginVM: LoginViewModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    @State private var isLoading = false
    @State private var showError = false
    
    var body: some View {
            
            VStack {
            
                    if isLoading {
                        ProgressView()
                            .scaleEffect(2)
                            .padding()
                    }
                    
                    Form {
                        
                        Section(header: Text("Login")) {
                            
                            TextField("username", text: $loginVM.username)
                            SecureField("password", text: $loginVM.password)
                            
                        }
                        
                        if loginVM.errorMessage != "" {
                            Section {
                                Text(loginVM.errorMessage)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Section {
                            Button {
                                loginVM.login() { success in
                                    if success {
                                        print("Login was successful.")
                                        self.navigationStateManager.selectionPath = []
                                    } else {
                                        print("Login failed.")
                                        print("Error message: \(loginVM.errorMessage)")
                                        loginVM.invalid = true
                                    }
                                }
                            } label: {
                                   Text("Login")
                            }
                        }
                    }
                }
            .alert(isPresented: $showError) {
                Alert(title: Text("Login failed"),
                      message: Text(loginVM.errorMessage),
                      dismissButton: .default(Text("OK")) {
                        showError = false
                    })
                }
        
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("", displayMode: .inline)
        
        }
    }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: LoginViewModel())
    }
}
