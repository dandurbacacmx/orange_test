//
//  ViewController.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView! 
    @IBOutlet weak var timestampLabel : UILabel!

    var timer:Timer?
    
    let viewModel = CurrencyViewModel(service: CurrencyService.shared)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Exchange rates"
        self.timestampLabel.text = "N/A"
        self.bindViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: CurrencyService.refreshInterval, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
    }
    
    @objc func fire()
    {
        let date = Date()
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.timestampLabel.text = CurrencyService.baseCurrency+" -> "+dateFormatterGet.string(from: date)
        self.viewModel.refreshData()
    }
    
    private func bindViews() {
    
        // bind data to tableview
        self.viewModel.output.rates
            .drive(self.tableView.rx.items(cellIdentifier: "CurrencyCell", cellType: CurrencyCell.self)) { (row, currencyRate, cell) in
                cell.currencyRate = currencyRate
            }
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
