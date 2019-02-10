//
//  TodayViewController.swift
//  Weather Widget
//
//  Created by mohamed on 9/1/19.
//  Copyright 2019mohamed. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherKit

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var weatherLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  
  fileprivate var isFetched = false
  fileprivate var location = "Egypt"

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = CGSize(width: UIScreen.main.applicationFrame.size.width, height: 37.0);
    
    // This will be called before widgetPerformUpdate func
    displayCurrentWeather()
  }
  
  func displayCurrentWeather() {
    // Update location
    cityLabel.text = location

    // Invoke weather service to get the weather data
   WeatherService.sharedWeatherService().getCurrentWeather(location, completion: { (data, error) -> () in
      OperationQueue.main.addOperation({ () -> Void in
        guard let weatherData = data else {
          self.isFetched = false
          return
        }
        
        self.isFetched = true

        self.weatherLabel.text = weatherData.weather.capitalized
        self.tempLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
      })
    })
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    if isFetched {
      completionHandler(NCUpdateResult.newData)
    } else {
      completionHandler(NCUpdateResult.noData)
    }
  }
    
}
