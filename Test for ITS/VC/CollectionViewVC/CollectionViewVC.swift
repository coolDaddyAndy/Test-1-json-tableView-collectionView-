//
//  CollectionViewVC.swift
//  Test for ITS
//
//  Created by Andrey Sushkov on 7.01.22.
//

import UIKit

class CollectionViewVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var usersForCollectionView = users
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self,
                                                 action: #selector (reload(sender:)),
                                                 for: .valueChanged)
        
        segmentedControl.addTarget(self,
                                   action: #selector(segmentChange),
                                   for: .valueChanged)
    }
    
    @objc func reload(sender: UIRefreshControl) {
        getAndParse()
        collectionView.reloadData()
        sender.endRefreshing()
    }
    
    @objc func segmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            usersForCollectionView = users
        case 1:
            usersForCollectionView = users.filter({$0.gender.hasPrefix("male")})
        case 2:
            usersForCollectionView = users.filter({$0.gender.hasPrefix("female")})
        default:
            usersForCollectionView = users
        }
        collectionView.reloadData()
    }
    
    @IBAction func sortUp(_ sender: Any) {
        usersForCollectionView = usersForCollectionView.sorted(by: {$0.age < $1.age})
        collectionView.reloadData()
    }
    
    @IBAction func sortDown(_ sender: Any) {
        usersForCollectionView = usersForCollectionView.sorted(by: {$0.age > $1.age})
        collectionView.reloadData()
    }
}


extension CollectionViewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersForCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell
        cell?.nameLabel.text = usersForCollectionView[indexPath.row].name
        cell?.genderLabel.text = usersForCollectionView[indexPath.row].gender
        cell?.ageLabel.text = "\(usersForCollectionView[indexPath.row].age)"
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "userDetailsVC") as? UserDetailsVC else {
            return
        }
        _ = vc.view
        vc.userNameLabel.text = usersForCollectionView[indexPath.row].name
        vc.genderLabel.text = usersForCollectionView[indexPath.row].gender
        vc.ageLabel.text = "\(usersForCollectionView[indexPath.row].age)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
