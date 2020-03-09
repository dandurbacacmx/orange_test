//
//  HistoryViewController.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Charts

class HistoryViewController: UIViewController {
    
    @IBOutlet var chartView1: BarChartView!
    @IBOutlet var chartView2: BarChartView!
    @IBOutlet var chartView3: BarChartView!

    let viewModel = HistoryViewModel(service: HistoryService.shared)
    var dataSource = HistoryDataSource()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "History"
        self.bindViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
        
    private func bindViews() {
    
        self.dataSource = HistoryDataSource(chart1: chartView1, chart2: chartView2, chart3: chartView3)

        self.viewModel.output.rates
            .drive(onNext: { [weak self] histData in
                guard let strongSelf = self else { return }
                strongSelf.dataSource.updateData(histData)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.output.errorMessage
            .drive(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else { return }
                strongSelf.showError(errorMessage)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.input.reload.accept(())
    }
    
    // MARK: - UI
    
    private func showError(_ errorMessage: String) {
        
        // display error ?
        let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}
