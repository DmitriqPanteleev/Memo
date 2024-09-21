import SwiftSyntax

// MARK: - Parameters
struct ParametersBuilder {
    
    private let parameters: FunctionParameterListSyntax
    
    init(params: FunctionParameterListSyntax) {
        parameters = params
    }
    
    func build(
        type: BuildType
    ) -> String {
        parameters.map {
            let name = $0.secondName ?? $0.firstName
            var string = "\(name.text): "

            if type == .cache { string.append("\\(") }
            
            string.append(
                [.cache, .call].contains(type) ? name.text : $0.type.trimmedDescription
            )
            
            if type == .cache { string.append(")") }
            
            return string
        }.joined(separator: ", ")
    }
}

extension ParametersBuilder {
    enum BuildType {
        case decl
        case call
        case cache
    }
}


// MARK: - Dictionary

struct DictionaryBuilder {
    private let name: String
    
    var keyName: String {
        "\(Constants.prefix)Key"
    }
    
    var dictionaryName: String {
        "memo\(name)Dict"
    }
    
    init(name: String) {
        self.name = name
    }
    
    func buildDictDecl(returnType: TypeSyntax) -> String {
        let type = "[\(Constants.TypeLiterals.string) : \(returnType)]"
        return "private var \(dictionaryName): \(type) = [:]"
    }
}
