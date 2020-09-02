import Firebase
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .userNotFound:
            return "없는 이메일 입니다."
        case .invalidEmail:
            return "메일 주소를 확인해주세요."
        case .missingEmail:
            return "메일 주소를 다시 입력해주세요."
        case .weakPassword:
            return "더 강력한 비밀번호를 입력해주세요."
        case .emailAlreadyInUse:
            return "이미 사용 중인 이메일입니다."
        case .webInternalError:
            return "서버와의 연결에 실패했습니다. 잠시 후 다시 이용해주세요."
        case .wrongPassword:
            return "틀린 비밀번호 입니다."
        
        default:
            return "다시 시도해주세요."
        }
    }
}
