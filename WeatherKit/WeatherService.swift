//
//  WeatherService.swift
//  WeatherDemo
//
//  Created by mohamed on 9/1/19.
//  Copyright 2019mohamed. All rights reserved.
//

import Foundation

open class WeatherService {
  public typealias WeatherDataCompletionBlock = (_ data: WeatherData?) -> ()
  
  let openWeatherBaseAPI = "http://api.openweathermap.org/data/2.5/weather?appid=97cce5b42320d87100a885f5dfa0dac9&units=metric&q="
  let urlSession:URLSession = URLSession.shared
  
  open class func sharedWeatherService() -> WeatherService {
    return _sharedWeatherService
  }
  
    open func getCurrentWeather(_ location:String, completion: @escaping  (_ data:WeatherData?,_ error:Error?) -> ()) {
        let openWeatherAPI = openWeatherBaseAPI + location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let request = URLRequest(url: URL(string: openWeatherAPI)!)
        let weatherData = WeatherData()
        
        let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error  {
                completion(nil,error)
            }
            guard let data = data else {
                
                return
            }
            // Retrieve JSON data
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                // Parse JSON data
                let jsonWeather = jsonResult?["weather"] as! [AnyObject]
                for jsonCurrentWeather in jsonWeather {
                    weatherData.weather = jsonCurrentWeather["description"] as! String
                }
                let jsonMain = jsonResult?["main"] as! Dictionary<String, AnyObject>
                weatherData.temperature = Int(truncating: jsonMain["temp"] as! NSNumber)
                
                completion(weatherData,nil)
            } catch {
                print(error)
            }
        })
        
        task.resume()
  }
}

let _sharedWeatherService: WeatherService = { WeatherService() }()
