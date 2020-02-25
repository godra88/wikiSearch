import UIKit

class Service {
    
    static let shared = Service()
    
    private init() { }
    
    var taskList : URLSessionDataTask?
    var taskDetails: URLSessionDataTask?
    var components = URLComponents()
    
    func parseWikiList(searchString: String, Offset: String, url:String, completion: @escaping (Result<[PageList], Error>) -> Void) {
        let urlSession = URLSession.shared
        urlSession.invalidateAndCancel()
        
        components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: false)!
        
        components.queryItemsDictionary = [
            "action": "query",
            "list": "search",
            "srsearch" : searchString,
            "format": "json",
            "sroffset": Offset,
            "continue" : "-||"
        ]
        
        guard let url = components.url else {return}
        
        
        taskList = urlSession.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let wikiList = try JSONDecoder().decode(ResultList.self, from: data)
                completion(.success(wikiList.query.search))
            } catch {
                print("Unexpected error: \(error).")
            }
        }
        
        taskList?.resume()
    }
    
    func parseDetailsFromId(pageId:Int, url:String, completion: @escaping (Result<String, Error>) -> Void) {
        
        components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: false)!
        
        components.queryItemsDictionary = [
            "action": "query",
            "pageids": "\(pageId)",
            "prop" : "extracts",
            "format": "json"
        ]
        
        guard let url = components.url else {return}
        
        let urlSession = URLSession.shared
        taskDetails = urlSession.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let wikiDetails = try JSONDecoder().decode(ResultDetails.self, from: data)
                
                for details in wikiDetails.query.pages {
                    completion(.success(details.value.extract))
                }
            } catch {
                print("Unexpected error: \(error).")
            }
            
        }
        taskDetails?.resume()
    }
    
    deinit {
        taskList?.cancel()
        taskDetails?.cancel()
    }
}
