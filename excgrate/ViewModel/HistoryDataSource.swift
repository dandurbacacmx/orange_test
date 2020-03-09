//
//  HistoryDataSource.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit
import Charts

class HistoryDataSource : GenericDataSource<CurrencyHist> {
    
    var chart1:BarChartView
    var chart2:BarChartView
    var chart3:BarChartView
    
    override init() {
        self.chart1 = BarChartView()
        self.chart2 = BarChartView()
        self.chart3 = BarChartView()
        super.init()
    }

    init(chart1: BarChartView, chart2: BarChartView, chart3:BarChartView) {
        self.chart1 = chart1
        self.chart2 = chart2
        self.chart3 = chart3
    }
    
    func updateData(_ data: [CurrencyHist]) {
                
        let yVals1 = data.enumerated().map { (arg) -> BarChartDataEntry in
            let (index, element) = arg
            return BarChartDataEntry(x: Double(index), y: element.rateRon)
        }
        let set1: BarChartDataSet! = BarChartDataSet(entries: yVals1, label: "RON last 10 days")
        set1.colors = ChartColorTemplates.material()
        set1.drawValuesEnabled = false
            
        let data1 = BarChartData(dataSet: set1)
        data1.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data1.barWidth = 0.9
        self.chart1.data = data1

        let yVals2 = data.enumerated().map { (arg) -> BarChartDataEntry in
            let (index, element) = arg
            return BarChartDataEntry(x: Double(index), y: element.rateUsd)
        }
        let set2: BarChartDataSet! = BarChartDataSet(entries: yVals2, label: "USD last 10 days")
        set2.colors = ChartColorTemplates.material()
        set2.drawValuesEnabled = false
            
        let data2 = BarChartData(dataSet: set2)
        data2.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data2.barWidth = 0.9
        self.chart2.data = data2

        let yVals3 = data.enumerated().map { (arg) -> BarChartDataEntry in
            let (index, element) = arg
            return BarChartDataEntry(x: Double(index), y: element.rateBgn)
        }
        let set3: BarChartDataSet! = BarChartDataSet(entries: yVals3, label: "BGN last 10 days")
        set3.colors = ChartColorTemplates.material()
        set3.drawValuesEnabled = false
            
        let data3 = BarChartData(dataSet: set3)
        data3.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data3.barWidth = 0.9
        self.chart3.data = data3
    }
}
