enum InteractorError: Error {
    case saveAccountError(errorDescription: String)
    case getAccountError(errorDescription: String)
    case fetchAccountsError(errorDescription: String)
    case deleteAccountError(errorDescription: String)
    
    case saveTransactionError(errorDescription: String)
    case getTransactionError(errorDescription: String)
    case fetchTransactionsError(errorDescription: String)
}
