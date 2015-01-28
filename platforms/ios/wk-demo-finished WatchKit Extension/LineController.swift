//
//  LineController.swift
//  wk-demo-finished
//
//  Created by Álvaro on 25/01/15.
//
//

import Foundation
import WatchKit


class LineController: WKInterfaceController {
    
    @IBOutlet weak var lineName: WKInterfaceLabel!
    @IBOutlet weak var lineNumber: WKInterfaceLabel!
    @IBOutlet weak var estimatedTimeOfArrival: WKInterfaceTimer!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let line = context as? [String:AnyObject] {
            if let lineNameString = line["name"] as? String {
                self.lineName.setText(lineNameString)
            }
            if let lineNumberInt = line["number"] as? String {
                self.lineNumber.setText(String(lineNumberInt))
            }
            if let etaNumber = line["eta"] as? Int {
                var date = NSDate()
                date = date.dateByAddingTimeInterval(NSTimeInterval(etaNumber))
                self.estimatedTimeOfArrival.setDate(date)
                self.estimatedTimeOfArrival.start()
            }
        }
    }
    
}