extension String {
     
    func deleteSpace() -> String {
        return replacingOccurrences(of: " ", with: "")
    }
}
