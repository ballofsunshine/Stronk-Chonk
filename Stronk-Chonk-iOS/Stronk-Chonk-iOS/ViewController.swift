//
//  ViewController.swift
//  Stronk-Chonk-iOS
//
//  Created by Niels Mainville on 2022-05-14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var timerCounting:Bool = false
    
    var startTime:Date?
    var stopTime:Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    var scheduledTimer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        if timerCounting {
            startTimer()
        }
        else {
            stopTimer()
            if let start = startTime
            {
                if let stop = stopTime
                {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }
    }
    @IBAction func startStopAction(_ sender: Any) {
        if (timerCounting)
        {
            setStopTime(date: Date())
            stopTimer()
        }
        else{
            if let stop = stopTime
            {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else
            {
                setStartTime(date: Date())
            }
            startTimer()
        }
    }
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    func startTimer() {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        startStopButton.setTitle("STOP", for: .normal)
        startStopButton.setTitleColor(UIColor.red, for: .normal)
    }
    @objc func refreshValue() {
        if let start = startTime{
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        }
        else{
            stopTimer()
            setTimeLabel(0)
        }
    }
    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        TimerLabel.text = timeString
    }
    func stopTimer() {
        if scheduledTimer != nil {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
        startStopButton.setTitle("START", for: .normal)
        startStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
        
    }
    @IBAction func resetAction(_ sender: Any) {
        setStopTime(date: nil)
        setStartTime(date: nil)
        TimerLabel.text = makeTimeString(hours: 0, minutes: 0, seconds: 0)
        stopTimer()
    }
    
    func setStartTime(date: Date?){
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    func setStopTime(date: Date?){
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    func setTimerCounting(_ val: Bool){
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int){
        return (seconds / 3600, (seconds % 3600) / 60, ((seconds % 3600) % 60 ))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "0%2d", hours)
        timeString += String(format: "0%2d", hours)
        timeString += " : "
        timeString += String(format: "0%2d", minutes)
        timeString += " : "
        timeString += String(format: "0%2d", seconds)
        return timeString
    }
    

}

