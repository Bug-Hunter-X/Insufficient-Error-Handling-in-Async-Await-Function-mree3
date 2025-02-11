enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
}

func fetchData() async throws -> Data {
    let url = URL(string: "https://api.example.com/data")!
    guard let url = url else { throw NetworkError.invalidURL }
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.networkError(NSError(domain: "API Error", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: nil))
        }
        return data
    } catch {
        throw NetworkError.networkError(error)
    }
}

Task { 
    do {
        let data = try await fetchData()
        // Process data
    } catch let error {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidURL:
                print("Invalid URL")
            case .networkError(let underlyingError):
                print("Network Error: \(underlyingError)")
                // Implement retry logic here, potentially with exponential backoff
            }
        }
    }
}