//
//  ContentView.swift
//  Dining App
//
//  Created by Udit Garg on 9/19/21.
//

import SwiftUI
import UIKit
import Foundation
import WebKit

struct ContentView: View {
    
    //Current Date
    @State private var currentDate: String = ""
    
    //Booleans to control the webview and delay data parsing
    @State private var showMenu = false
    @State private var populateView = false
    @State private var allowPopulation = false
        
    //API URL
    let JSONUrl = URL(string: "https://api.pennlabs.org/dining/venues")
    
    //Arrays to store data used to populate dining hall lists
    @State var venueData: [venue] = [venue]()
    @State var imageURLs = [String]()
    @State var facilityURLs = [String]()
    @State var diningHalls = ["1920 Commons", "Hill College House", "English House", "Lauder House"]
    @State var retailDining = ["Starbucks", "McClelland", "Joe's Cafe", "MBA Cafe", "Pret Locust Walk"]
    @State var diningTimes = [String]()
        
    var body: some View {
        
        //Entire screen is a vertical scroll view with two lists of dining halls / retail dining
        ScrollView(.vertical) {
            
            if allowPopulation {

                VStack(alignment: .leading) {
                    if populateView {
                        
                        Text(currentDate)
                            .font(.system(size: 11).weight(.bold))
                            .foregroundColor(Color(UIColor(red: 0.642, green: 0.642, blue: 0.642, alpha: 1)))
                            .padding(.top, 10)
                            .padding(.bottom, -5)
                            .padding(.leading, 14)
                        
                        Text("Dining Halls")
                            .font(.system(size: 28).weight(.bold))
                            .padding(.leading, 14)
                        
                        //List of Dining Halls
                        VStack() {
                            ForEach(0...3, id: \.self) { index in
                                Button(action: {
                                    showMenu = true
                                }, label: {
                                        HStack(alignment: .center) {
                                            RemoteImage(urlString: imageURLs[index])
                                                .frame(width: 120, height: 80)
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(7)
                                                .padding(.leading, 14)
                                                .padding(.bottom, 21)
                                            
                                            VStack(alignment: .leading, spacing: 1) {
                                                
                                                //Wasn't able to add control for determing open/close time
                                                Text("OPEN")
                                                    .font(.system(size: 14).weight(.bold))
                                                    .foregroundColor(Color(UIColor(red: 0.125, green: 0.612, blue: 0.933, alpha: 1)))
                                                    
                                                Text(diningHalls[index])
                                                    .font(.system(size: 20).weight(.regular))
                                                    .foregroundColor(Color(UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1)))

                                                Text(diningTimes[index])
                                                    .font(.system(size: 14).weight(.light))
                                                    .foregroundColor(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
                                            }
                                            .frame(width: 229, alignment: .leading)
                                            .padding(.bottom)
                                            
                                            Image("Arrow")
                                                .resizable()
                                                .frame(width: 5.44, height: 13.17)
                                                .aspectRatio(contentMode: .fill)
                                                .padding(.horizontal, -20)
                                                .foregroundColor(Color(UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1)))
                                        }
                                    })
                                    .fullScreenCover(isPresented: $showMenu, content: {
                                        //Shows WebView
                                        WebView(url: facilityURLs[index])
                                    })
                            }
                        }
                        
                        Text("Retail Dining")
                            .font(.system(size: 28).weight(.bold))
                            .padding(.leading, 14)
                            .padding(.top, -7)
                        
                        //List of Retail Dining
                        VStack() {
                            ForEach(4...8, id: \.self) { index in
                                
                                Button (action: {
                                    showMenu = true
                                }, label: {
                                    HStack(alignment: .center) {
                                        RemoteImage(urlString: imageURLs[index])
                                            .frame(width: 120, height: 80)
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(7)
                                            .padding(.leading, 14)
                                            .padding(.bottom, 21)
                                        
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text("OPEN")
                                                .font(.system(size: 14).weight(.bold))
                                                .foregroundColor(Color(UIColor(red: 0.125, green: 0.612, blue: 0.933, alpha: 1)))
                                            
                                            Text(retailDining[index-4])
                                                .font(.system(size: 20).weight(.regular))
                                                .foregroundColor(Color(UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1)))

                                            Text(diningTimes[index])
                                                .font(.system(size: 14).weight(.light))
                                                .foregroundColor(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
                                        }
                                        .frame(width: 229, alignment: .leading)
                                        .padding(.bottom)
                                        
                                        Image("Arrow")
                                            .resizable()
                                            .frame(width: 5.44, height: 13.17)
                                            .aspectRatio(contentMode: .fill)
                                            .padding(.horizontal, -20)
                                            .foregroundColor(Color(UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1)))
                                    }
                                })
                                .fullScreenCover(isPresented: $showMenu, content: {
                                    WebView(url: facilityURLs[index])
                                })
                                
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: .infinity, alignment: .leading)
                        .onAppear() {
                            currentDate = getDate()
                        }
                    }
                }.onAppear(perform: {
                    //Used to handle JSON parsing times
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        populateView = true
                    }
                })
                }
        
            }.onAppear(perform: {
                
                //Parse JSON Data into arrays
                accessJSONData(url: JSONUrl)
    
                // Used to handle data parsing delays
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    allowPopulation = true
                }
            })

    }
    
    //Gets current data
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full

        currentDate = dateFormatter.string(from: Date())
        for _ in 0...5 {
            currentDate.removeLast()
        }
        return currentDate.uppercased()
    }
    
    // JSON DATA FUNCTIONS
    
    //Starts a URL session with the URL to Penn Labs API
    func accessJSONData(url: URL?) {
        
        //Creates URL Session
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            //Handle errors
            guard let data = data else {
                print("Error : No Response")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("HTTP Response Error")
                return
            }
            
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
            
            //Sets venueData to the decoded JSONData
            venueData = decodeJSONData(JSONData: data)!
            
        }
        task.resume()
    }
    
    // Decodes JSON Data and stores values in Data Arrays
    // Messy function due to all the Data cleaning
    func decodeJSONData(JSONData: Data) -> [venue]? {
        
        //Initialize response to the decoded Dininng Data
        let response = try! JSONDecoder().decode(documentData.self, from: JSONData)
        
        var venueInfo = response.document["venue"]
        
        //Strings for dining times
        var breakfast = ""
        var lunch = ""
        var dinner = ""

        //Remove venues not shown in Figma
        var i = venueInfo!.count
        while (i>=0) {
            if (i == 3 || i == 4 || i == 5 || i == 8 || i == 11 || i == 14 || i == 15) {
                venueInfo!.remove(at: i)
            }
            i = i - 1
        }
        
        //Ensure correct order of venue data
        venueInfo?.swapAt(3, 6)
        venueInfo?.swapAt(4, 5)
        
        //Remove dates other than the current date
        for i in 0...8 {
            let x = venueInfo![i].dateHours.count
            for _ in 0...x-2 {
                venueInfo![i].dateHours.removeLast()
            }
        }
        
        //Formats dining times
        for i in 0...8 {
            imageURLs.append(venueInfo![i].imageURL!)
            facilityURLs.append(venueInfo![i].facilityURL)
            
            for j in 0...venueInfo![i].dateHours[0].meal.count-1 {
                var open = venueInfo![i].dateHours[0].meal[j].open
                var close = venueInfo![i].dateHours[0].meal[j].close
                let type = venueInfo![i].dateHours[0].meal[j].type
                
                open.removeLast(6)
                close.removeLast(6)
                
                if open.first == "0" {
                    open.removeFirst()
                }
                
                if close.first == "0" {
                    close.removeFirst()
                }
                
                if Int(open)! > 12 {
                    open = String(Int(open)!-12)
                }
                
                if Int(close)! > 12 {
                    close = String(Int(close)!-12)
                }
                
                if type == "Breakfast" {
                    breakfast = open + " - " + close
                    //print(breakfast)
                }
                
                if type == "Lunch" && breakfast != "" {
                    lunch = " | " + open + " - " + close
                    //print(breakfast + lunch)
                } else if type == "Lunch" {
                    if Int(open)! <= 11 {
                        lunch = open + "a" + "-" + close + "p"
                    } else {
                        lunch = open + "p" + "-" + close + "p"
                    }
                }
                
                if type == "Dinner" && lunch != "" && breakfast != "" {
                    dinner = " | " + open + " - " + close
                } else if type == "Dinner" {
                    dinner = open + "p" + "-" + close + "p"
                }
                
                if type == "Starbucks" {
                    lunch = open + "p" + "-" + close + "p"
                }
                
                if type == "Joe" {
                    lunch = open + "a" + "-" + close + "p"
                }
                
                if type == "Pret a Manger" {
                    lunch = open + "a" + "-" + close + "p"
                }
            }
            diningTimes.append(breakfast + lunch + dinner)
            
            breakfast = ""
            lunch = ""
            dinner = ""
        }
        
        for i in diningTimes {
            print(i)
        }
        
        return venueInfo
    }
    
    func stringToTime(time: String) -> Date {
        
        let currentTime = Date()
        
        let dateFormatter = DateFormatter()
        let Time = dateFormatter.date(from: time)
        print(Time ?? "Hello")
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: currentTime)
        let hour = components.hour
        let minute = components.minute

        print(hour!)
        print(minute!)
        
        let components2 = Calendar.current.dateComponents([.hour, .minute], from: ((Time ?? dateFormatter.date(from: "7:30"))!))
        let hr = components2.hour
        let min = components2.minute
        
        print(hr!)
        print(min!)

        return Time ?? currentTime
    }

}
