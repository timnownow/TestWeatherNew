import Foundation
import Moya

// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let myApi = MoyaProvider<WeatherAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support
private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum WeatherAPI {
    case forecast(Int)
    case city(Int)
    case find(String)
}

extension WeatherAPI: TargetType {

    public var baseURL: URL { return URL(string: "http://api.openweathermap.org/data/2.5")! }
    public var path: String {
        switch self {
        case .forecast(_):
            return "/forecast"
        case .city(_):
            return "/weather"
        case .find(_):
            return "/find"
        }
    }
    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        switch self {
        case .forecast(let id):
            var params: [String: Any] = [:]
            params["id"] = id
            params["APPID"] = "e02c6a8c0eb6fbc54984df30017be6b0"
            params["lang"] = "ru"
            params["units"] = "metric"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .city(let id):
            var params: [String: Any] = [:]
            params["id"] = id
            params["APPID"] = "e02c6a8c0eb6fbc54984df30017be6b0"
            params["lang"] = "ru"
            params["units"] = "metric"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .find(let name):
            var params: [String: Any] = [:]
            params["q"] = name
            params["APPID"] = "e02c6a8c0eb6fbc54984df30017be6b0"
            params["type"] = "like"
            params["units"] = "metric"
            params["mode"] = "json"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    public var headers: [String : String]? {
        return nil
    }
    
    public var sampleData: Data {
        switch self {

        case .forecast(let id):
            return "{\"id\": \"\(id)\"}".data(using: String.Encoding.utf8)!
        case .city(let id):
            return "{\"id\": \"\(id)\"}".data(using: String.Encoding.utf8)!
        case .find(let name):
            return "{\"q\": \"\(name)\"}".data(using: String.Encoding.utf8)!

        }
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
