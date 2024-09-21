@attached(peer, names: arbitrary)
public macro Memo() = #externalMacro(module: "MemoMacros", type: "MemoMacro")
