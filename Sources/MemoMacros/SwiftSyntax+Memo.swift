import SwiftSyntax

extension ConditionElementSyntax {
    static func optionalElement(
        specifierLiteral: String,
        patternLiteral: String
    ) -> Self {
        .init(condition: .optionalBinding(
            .init(
                bindingSpecifier: .init(stringLiteral: specifierLiteral),
                pattern: ExpressionPatternSyntax(
                    expression: ExprSyntax(stringLiteral: patternLiteral)
                )
            )
        ))
    }
}

extension CodeBlockItemSyntax {
    static func returnElement(with literal: String) -> Self {
        .init(item: .stmt(StmtSyntax(
            ReturnStmtSyntax(
                expression: .init(ExprSyntax(stringLiteral: literal)))))
        )
    }
    
    static func letElement(
        _ name: String,
        typeLiteral: String,
        initLiteral: String
    ) -> Self {
        .init(item: .decl(
            DeclSyntax(
                VariableDeclSyntax(
                    Keyword.let,
                    name: .init(stringLiteral: name),
                    type: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: typeLiteral)),
                    initializer: .init(value: ExprSyntax(stringLiteral: initLiteral)))
                )
            )
        )
    }
    
    static func expression(with literal: String) -> Self {
        .init(item: .expr(.init(stringLiteral: literal)))
    }
}
