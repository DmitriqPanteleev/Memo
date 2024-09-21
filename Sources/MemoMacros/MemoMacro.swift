import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct MemoMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let declaration = declaration.as(FunctionDeclSyntax.self) else {
            let errorDiagnose = Diagnostic(
                node: node,
                message: MemoError.notFunction
            )
            
            context.diagnose(errorDiagnose)
            
            return []
        }
        
        guard let returnType = declaration.signature.returnClause?.type.trimmed,
              returnType.trimmedDescription != Constants.TypeLiterals.void
        else {
            let message = MemoError.invalidReturnType
            let errorDiagnose = Diagnostic(
                node: node,
                message: message,
                fixIt: .replace(
                    message: message.fixMessage ?? .wrongType,
                    oldNode: declaration.signature.returnClause?.type ?? TypeSyntax(
                        stringLiteral: ""
                    ),
                    newNode: TypeSyntax(stringLiteral: Constants.TypeLiterals.any)
                )
            )
            
            context.diagnose(errorDiagnose)
            
            return []
        }
        
        let insertName = buildInsertName(with: declaration.name.text)
        let dict = DictionaryBuilder(name: insertName)
        let params = ParametersBuilder(
            params: declaration.signature.parameterClause.parameters
        )
        let keyName = dict.keyName
        let dictionaryName = dict.dictionaryName
        
        let funcLiteral = """
        \(dict.buildDictDecl(returnType: returnType))
        
        func \(Constants.prefix)\(insertName)(\(params.build(type: .decl))) -> \(returnType) {
            let \(dict.keyName) = "\(params.build(type: .cache))"
        
            if let \(Syntax.cacheResult) = \(dictionaryName)[\(keyName)] {
                return \(Syntax.cacheResult)
            }
        
            let \(Syntax.funcResult) = \(declaration.name.text)(\(params.build(type: .call)))
            \(dictionaryName)[\(keyName)] = \(Syntax.funcResult)
            return \(Syntax.funcResult)
        }
        """

        return [DeclSyntax(stringLiteral: funcLiteral)]
    }
    
    private static func buildInsertName(with funcName: String) -> String {
        funcName.prefix(1).capitalized + funcName.dropFirst()
    }
}

private extension MemoMacro {
    enum Syntax {
        static let cacheResult = "cachedResult"
        static let funcResult = "result"
    }
}

@main
struct MemoPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MemoMacro.self
    ]
}
