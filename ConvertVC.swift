import UIKit
import CountryPickerView

class ConvertVC: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var convertBTN: UIButton!
    
    @IBOutlet weak var cv1: CountryPickerView!
    
    @IBOutlet weak var cv2: CountryPickerView!
    
    var timeZoneData: [TimeZoneData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCountryData()
        self.fetchTimeZoneData()
    }
    
    func getCountryData() {
        cv1.delegate = self
        cv2.delegate = self
        

    }
    
    func fetchTimeZoneData() {
        let apiKey = "3JM5HNZ1AF4S" // Replace with your actual API key
        let urlString = "http://api.timezonedb.com/v2.1/list-time-zone?key=\(apiKey)&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching timezone data:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.timeZoneData = try decoder.decode([TimeZoneData].self, from: data)
            } catch {
                print("Error decoding timezone data:", error.localizedDescription)
            }
        }.resume()
    }
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        let fromTimeZone = cv1.selectedCountry.code
        let toTimeZone = cv2.selectedCountry.code
        let currentTime = Int(Date().timeIntervalSince1970)
        
        convertTimeZone(from: fromTimeZone, to: toTimeZone, time: currentTime) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.resultLabel.text = "Offset: \(response.offset)"
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.resultLabel.text = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func convertTimeZone(from: String, to: String, time: Int, completion: @escaping (Result<TimeZoneConversionResponse, Error>) -> Void) {
        let baseURL = "http://api.timezonedb.com/v2.1/convert-time-zone"
        let apiKey = "3JM5HNZ1AF4S" // Replace with your actual API key
        let urlString = "\(baseURL)?key=\(apiKey)&format=json&from=\(from)&to=\(to)&time=\(time)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let timeZoneResponse = try decoder.decode(TimeZoneConversionResponse.self, from: data)
                completion(.success(timeZoneResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension ConvertVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        if countryPickerView == cv1 {
            print("Selected Country Name:", country.name)
            print("Selected Country Code:", country.code)
        } else if countryPickerView == cv2 {
            print("Selected Country Name:", country.name)
            print("Selected Country Code:", country.code)
        }
    }
}

struct TimeZoneConversionResponse: Codable {
    let status: String
    let message: String
    let fromZoneName: String
    let fromAbbreviation: String
    let fromTimestamp: Int
    let toZoneName: String
    let toAbbreviation: String
    let toTimestamp: Int
    let offset: Int
}

struct TimeZoneData: Codable {
    let countryCode: String
    let countryName: String
    let zoneName: String
    let gmtOffset: Int
    let timestamp: Int
}


