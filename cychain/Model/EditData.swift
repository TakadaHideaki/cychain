class EditData {
    var SingletonUserData: [String: Any]?
    static let sharedInstance = EditData()
    private init() {}
    func a(){
        log.debug(SingletonUserData)
    }
}



