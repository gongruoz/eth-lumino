import SwiftUI
import PrivySDK

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var isPrivySdkReady = false
    @State private var myAuthState: AuthState?
    private let privy: Privy
    
    init(isAuthenticated: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
        let config = PrivyConfig(
            appId: "cm3K1sk8203u5ijvf8hxjd12H",
            appClientId: "client-WY5dc9uickEsVHLi5vPa2gMr5uLC5YMJNqS56zpp9TVc"
        )
        privy = PrivySdk.initialize(config: config)
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Lumino")
                    .font(.custom("IM FELL DW Pica", size: 40))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                Spacer()
                
                // 临时添加一个测试按钮
                Button(action: {
                    print("Privy SDK Ready: \(isPrivySdkReady)")
                    print("Auth State: \(String(describing: myAuthState))")
                }) {
                    Text("Check Privy Status")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .onAppear {
            initializePrivySDK()
            setupSiweFlowStateTracking()
        }
    }
    
    func initializePrivySDK() {
        privy.setAuthStateChangeCallback { state in
            print("Privy Auth State Changed: \(state)")
            if !self.isPrivySdkReady && state != AuthState.notReady {
                DispatchQueue.main.async {
                    self.isPrivySdkReady = true
                }
            }
            self.myAuthState = state
            
            if case .authenticated = state {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            }
        }
    }
    
    func setupSiweFlowStateTracking() {
        privy.siwe.setSiweFlowStateChangeCallback { siweFlowState in
            print("SIWE Flow State: \(siweFlowState)")
            switch siweFlowState {
            case .initial:
                print("Starting SIWE flow")
            case .generatingMessage:
                print("Generating SIWE message")
            case .awaitingSignature:
                print("Waiting for wallet signature")
            case .submittingSignature:
                print("Submitting signature")
            case .done:
                print("SIWE flow completed")
            case .error:
                print("SIWE flow error occurred")
            }
        }
    }
}

#Preview {
    LoginView(isAuthenticated: .constant(false))
}


