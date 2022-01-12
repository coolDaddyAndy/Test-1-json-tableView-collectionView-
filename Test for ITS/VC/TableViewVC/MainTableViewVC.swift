//
//  MainTableViewVC.swift
//  Test for ITS
//
//  Created by Andrey Sushkov on 7.01.22.
//

import UIKit

class MainTableViewVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var usersForSegmentControl = users
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAndParse()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(reload(sender:)),
                                            for: .valueChanged)
        
        segmentedControl.addTarget(self,
                                   action: #selector(segmentChange),
                                   for: .valueChanged)
    }
    
    @objc func reload(sender: UIRefreshControl) {
        getAndParse()
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    @objc func segmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            usersForSegmentControl = users
        case 1:
            usersForSegmentControl = users.filter({$0.gender.hasPrefix("male")})
        case 2:
            usersForSegmentControl = users.filter({$0.gender.hasPrefix("female")})
        default:
            usersForSegmentControl = users
        }
        tableView.reloadData()
    }
    
    @IBAction func colViewTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "collectionViewVC") as? CollectionViewVC else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortUsers(_ sender: Any) {
        usersForSegmentControl = usersForSegmentControl.sorted(by: {$0.age < $1.age})
        tableView.reloadData()
    }
    
    @IBAction func reversUsers(_ sender: Any) {
        usersForSegmentControl = usersForSegmentControl.sorted(by: {$0.age > $1.age})
        tableView.reloadData()
    }
}


extension MainTableViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersForSegmentControl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.nameLabel.text = usersForSegmentControl[indexPath.row].name
        cell.genderLabel.text = usersForSegmentControl[indexPath.row].gender
        cell.ageLabel.text = "\(usersForSegmentControl[indexPath.row].age)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "userDetailsVC") as? UserDetailsVC else {
            return
        }
        _ = vc.view
        vc.userNameLabel.text = usersForSegmentControl[indexPath.row].name
        vc.genderLabel.text = usersForSegmentControl[indexPath.row].gender
        vc.ageLabel.text = "\(usersForSegmentControl[indexPath.row].age)"
        navigationController?.pushViewController(vc, animated: true)
    }
}
