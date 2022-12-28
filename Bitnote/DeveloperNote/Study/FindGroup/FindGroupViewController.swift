//
//  FindGroupViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2021/03/19.
//  Copyright © 2021 Tomatoma. All rights reserved.
//

import UIKit

class FindGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {


    private let tableView = UITableView()
    private let viewModel = FindGroupViewModel()
    
    public var handleSelection: ((Group) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "lesson_find_group".localized()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        setupViews()
    }


    
    private func setupViews(){
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self

        let navItem = UINavigationItem()
        navItem.title = "lesson_find_group".localized()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "button_close".localized(), style: .plain, target: self, action: #selector(touchedCloseButton))

        navbar.items = [navItem]

        view.addSubview(navbar)
        view.addSubview(tableView)
        self.tableView.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
            
    }
    
    @objc func touchedCloseButton(){
        self.dismiss(animated: true, completion: nil)
    }
 

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupDataList.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.groupDataList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let group = self.viewModel.groupDataList[indexPath.row]
        self.dismiss(animated: true) { [weak self] in
            self?.handleSelection(group)
        }
    }
}
