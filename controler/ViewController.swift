//
//  ViewController.swift
//  WeatherDemo
//
//  Created by mohamed on 9/1/19.
//  Copyright 2019mohamed. All rights reserved.
//

import UIKit
import WeatherKit
import CoreData

@available(iOS 10.0, *)
class ViewController: UIViewController {
    @IBOutlet weak var cityLabel:UILabel!
    @IBOutlet weak var CountryLABEL:UILabel!
    @IBOutlet weak var WeatherLabel1:UILabel!
    @IBOutlet weak var TempLabel:UILabel!


    var city = "San Francisco"
    var country = "U.S."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //storingCoredata
        let appdelegate=UIApplication.shared.delegate as! AppDelegate
     
        //let context= appdelegate.persistentContainer.viewContext
        //let newCity=NSEntityDescription.insertNewObject(forEntityName: "location", into: context)
       // newCity.setValue(city, forKey: "location")
        
        WeatherLabel1.text = ""
        TempLabel.text = ""
        
        displayCurrentWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayCurrentWeather() {
        // Update location
        cityLabel.text = city
        CountryLABEL.text = country
        
 // Invoke weather service to get the weather data
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.sizeToFit()
        view.addSubview(activityIndicator)
        
        // To make the activity indicator appear:
        activityIndicator.startAnimating()
        
        WeatherService.sharedWeatherService().getCurrentWeather(city + "," + country, completion: { (data,error) -> () in
            if let error = error {
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                
            }
            OperationQueue.main.addOperation({ () -> Void in
                if let weatherData = data {
                    self.WeatherLabel1.text = weatherData.weather.capitalized
                    self.TempLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
                    activityIndicator.stopAnimating()
                }
            })
        })
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func updateWeatherInfo(_ segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! LocationTableViewController
        var selectedLocation = sourceViewController.selectedLocation.split { $0 == "," }.map { String($0) }
        city = selectedLocation[0]
        country = selectedLocation[1].trimmingCharacters(in: CharacterSet.whitespaces)
        
        displayCurrentWeather()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showLocations" {
            let destinationController = segue.destination as! UINavigationController
            let locationTableViewController = destinationController.viewControllers[0] as! LocationTableViewController
            locationTableViewController.selectedLocation = "\(city), \(country)"
        }
    }

}

