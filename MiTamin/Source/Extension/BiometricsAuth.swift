//
//  BiometricsAuth.swift
//  iTamin
//
//  Created by Tabber on 2022/11/06.
//

import LocalAuthentication

public protocol AuthenticateStateDelegate: AnyObject {
    /// loggedIn상태인지 loggedOut 상태인지 표출
    func didUpdateState(_ state: BiometricsAuth.AuthenticationState)
}

public class BiometricsAuth {

    public enum AuthenticationState {
        case loggedIn
        case LoggedOut
    }

    public weak var delegate: AuthenticateStateDelegate?
    private var context = LAContext()

    init() {
        configure()
    }

    private func configure() {
        /// 생체 인증이 실패한 경우, Username/Password를 입력하여 인증할 수 있는 버튼에 표출되는 문구
        context.localizedCancelTitle = "Enter Username/Password"
    }

    public func execute() {

        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Log in to your account"
            
            switch context.biometryType {
            case .faceID, .touchID:
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                    if success {
                        self.delegate?.didUpdateState(.loggedIn)
                    } else {
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            case .none:
                print("미지원")
            case .opticID:
                print("미지원")
            @unknown default:
                print("미지원")
            }
            
            
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
        }
    }
}
