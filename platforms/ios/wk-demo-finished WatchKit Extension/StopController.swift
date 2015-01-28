//
//  StopController.swift
//  wk-demo-finished WatchKit Extension
//
//  Created by Álvaro on 25/01/15.
//
//

import WatchKit
import Foundation


class StopController: WKInterfaceController {
    
    @IBOutlet weak var lineTable: WKInterfaceTable!
    
    var stops = [[:]]

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //readBusStops()
        readStaticBusStops()
    }
    
    func readStaticBusStops() {
        self.stops = [["name": "PALMA-PORT", "number": "1", "eta": 2455], ["name": "sSARDINA-saGARRIGA", "number": "12", "eta": 2455], ["name": "PLAÇA REINA", "number": "15", "eta": 2455], ["name": "PARC BIT", "number": "19", "eta": 2455], ["name": "SON ESPASES", "number": "33", "eta": 2455], ["name": "ESPORLES", "number": "16", "eta": 2455]]
        populateTable()
    }
    
    func readBusStops() {
        let url = NSURL(string: "http://pasoporparada.emtpalma.es/EMTPalma/Front/pasoporparada.es.svr?p=452")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let str = NSString(data: data, encoding: NSASCIIStringEncoding)
            var parseError: NSError?
            let utf8Data = str?.dataUsingEncoding(NSUTF8StringEncoding)
            let parsedJson: AnyObject? = NSJSONSerialization.JSONObjectWithData(utf8Data!, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            
            if let jsonResponse = parsedJson as? Dictionary<String, AnyObject> {
                if let estimates = jsonResponse["estimaciones"] as? NSArray {
                    for (index, estimate) in enumerate(estimates) {
                        var stop = Dictionary<String, AnyObject>()
                        if let number = estimate["line"] as? String {
                            stop["number"] = number
                        }
                        if let first = estimate["vh_first"] as? NSDictionary {
                            if let dest = first["destino"] as? String {
                                stop["name"] = dest
                            }
                            if let eta = first["seconds"] as? Int {
                                stop["eta"] = eta
                            }
                        }
                        self.stops.append(stop)
                        println(stop)
                    }
                }
            }
            self.populateTable()
        }
        task.resume()
    }
    
    func populateTable() {
        self.lineTable.setNumberOfRows(self.stops.count, withRowType: "StopRowIdentifier")
        for (index, stop) in enumerate(self.stops) {
            var line = self.lineTable.rowControllerAtIndex(index) as StopRowController
            if let stopName = stop["name"] as? String {
                line.lineName.setText(stopName)
            }
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        let stop = self.stops[rowIndex]
        println(stop)
        return stop
    }

    // Lifecycle
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
