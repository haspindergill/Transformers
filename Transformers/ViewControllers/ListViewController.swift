//
//  ListViewController.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-12.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var battle = Battle()
    
    var dataSource : TableDataSource?{
        didSet{
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
        }
    }
    
    var items = [AnyObject]() {
        didSet {
            dataSource?.items = items as Array<AnyObject>
        }
    }
    
    // MARK: View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTransformers()
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = DataManager.sharedInstance.getListOfTransformers() as [AnyObject]
        self.setupTableView()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Navigation
    
    private func presentCreateVC(withTransformer transformer: Transformer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let createVC = storyBoard.instantiateViewController(withIdentifier: "CreateTransformerViewController") as? CreateTransformerViewController else {return}
        createVC.currentInvade = transformer
        createVC.editableInvade = true
        self.show(createVC, sender: self)
    }
    
    
    // MARK: - Private
    
    private func deleteRowAtIndex(index: Int) {
        guard let transformer = items[index] as? Transformer else { return }
        DataManager.sharedInstance.deleteTransformer(withID: transformer.id)
        self.deleteTransformer(id: transformer.id)
        self.tableView.beginUpdates()
        self.items.remove(at: index)
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
        self.tableView.endUpdates()
    }
    
    
    // MARK: - Actions

    @IBAction func warAction(_ sender: Any) {
        guard let items = items as? [Transformer] else { return }
        let result = battle.battle(list: items)
        switch result {
        case .GameEnd:
            self.showAlert(title: "Battle Result", message: "Game End")
            
        case .TeamA(let numberOfBattles,let aTeamSurvivors,let dTeamSurvivors):
            self.showAlert(title: "Battle Result", message: "\(numberOfBattles) Battle \n Winning team (Autobots): \(aTeamSurvivors.joined(separator: ",")) \n Survivors from the losing team (Decepticons): \(dTeamSurvivors.joined(separator: ","))")
            
        case .TeamD(let numberOfBattles,let aTeamSurvivors,let dTeamSurvivors):
            self.showAlert(title: "Battle Result", message: "\(numberOfBattles) Battle \n Winning team (Decepticons): \(dTeamSurvivors.joined(separator: ",")) \n Survivors from the losing team (Autobots): \(aTeamSurvivors.joined(separator: ","))")
            
        case .GameTie(let numberOfBattles):
            self.showAlert(title: "Battle Result", message: "\(numberOfBattles) Battle \n Game Tie")

        }
    }
}


// MARK: - API

extension ListViewController {
    
    private func getTransformers() {
        APIManager.sharedInstance.opertationWithRequest(withApi: API.GetTransformers) { [weak self] (response) in
            switch response {
            case .Success(let transformers):
                guard let transformers = transformers as? Transformers else {
                    return
                }
                self?.items = transformers.transformers as [AnyObject]
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                    if self?.items.count == 0 {
                        self?.tableView.isHidden = true
                    } else {
                        self?.tableView.isHidden = false
                    }
                }
            case .Failure(let error):
                self?.showAlert(message: error ?? "")
            }
        }
    }
    
    
    private func deleteTransformer(id: String) {
        APIManager.sharedInstance.opertationWithRequest(withApi: API.DeleteTransformer(transformerID: id)) { [weak self] (response) in
            switch response {
            case .Success(_): break
            case .Failure(let error):
                self?.showAlert(message: error ?? "")
            }
        }
    }
    
}


//MARK: TableView

extension ListViewController {
    
    //init the datasource class
    private func setupTableView() {
        dataSource = TableDataSource(items: items as Array<AnyObject>, height: 170.0, tableView: tableView, cellIdentifier: "ListTableViewCell", configureCellBlock: { (cell, item, index) in
            self.configureTableCell(cell: cell, item: item,index: index)
        }, aRowSelectedListener: { (indexPath) in
            self.clickHandler(indexPath: indexPath)
        }, aRowDeletedListener: {(index) in
            self.deleteRowAtIndex(index: index.row)
        })
    }
    
    //This function called up whenever user clicks any cell of UITableView.
    private func clickHandler(indexPath: IndexPath) {
        guard let transformer = items[indexPath.row] as? Transformer else { return }
        self.presentCreateVC(withTransformer: transformer)
    }
    
    
    //This function is called up to populate data in tableView cell.
    private func configureTableCell(cell: AnyObject?,item: AnyObject?,index: IndexPath?) {
        guard let cell = cell as? ListTableViewCell, let transformer = item as? Transformer else {
            return
        }
        cell.transformer = transformer
    }

}

