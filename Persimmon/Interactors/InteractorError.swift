enum InteractorError: Error {
    case saveAccountError(errorDescription: String)
    case getAccountError(errorDescription: String)
    case fetchAccountsError(errorDescription: String)
    case deleteAccountError(errorDescription: String)
    
    case saveTransactionError(errorDescription: String)
    case getTransactionError(errorDescription: String)
    case fetchTransactionsError(errorDescription: String)
    case deleteTransactionsError(errorDescription: String)
    
    case saveLocationError(errorDescription: String)
    case getLocationError(errorDescription: String)
    case fetchLocationsError(errorDescription: String)
    case deleteLocationsError(errorDescription: String)
}
