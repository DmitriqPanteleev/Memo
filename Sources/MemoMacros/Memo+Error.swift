import SwiftDiagnostics

extension MemoMacro {
    enum MemoError: String {
        case notFunction
        case invalidReturnType
    }
}

extension MemoMacro.MemoError: DiagnosticMessage {
    var message: String {
        switch self {
        case .notFunction:
            "@Memo macro can only be applied to a functions"
        case .invalidReturnType:
            "@Memo macro can only be applied to a functions with non-void return type"
        }
        
    }
    
    var diagnosticID: MessageID {
        .init(domain: Constants.domain, id: rawValue)
    }
    
    var severity: DiagnosticSeverity {
        .error
    }
    
    var fixMessage: MemoFixMessage? {
        switch self {
        case .notFunction:
            return nil
        case .invalidReturnType:
            return .wrongType
        }
    }
}

enum MemoFixMessage: String {
    case wrongType
}

extension MemoFixMessage: FixItMessage {
    var message: String {
        "Replace return type"
    }
    
    var fixItID: SwiftDiagnostics.MessageID {
        .init(domain: Constants.domain, id: rawValue)
    }
}
