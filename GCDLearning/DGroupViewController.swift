//
//  DGroupViewController.swift
//  GCDLearning
//
//  Created by Ratheesh on 04/10/19.
//  Copyright © 2019 Ratheesh. All rights reserved.
//

import UIKit

class DGroupViewController: UIViewController {

    let groupA = ["Image 1", "Image 2"]
    let groupB = ["Image 3", "Image 4", "Image 5"]
    let groupC = ["Image 6", "Image 7"]
    let groupD = ["Image 8", "Image 9"]

    var items = [String]()
    
    let dispatchGroup = DispatchGroup()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Dispatch Goup"
        // Do any additional setup after loading the view.
    }
    
    func getGoupA() {
        run(after: 2) { [weak self] in
            guard self != nil else { return }

            print("Group A added")
            self?.items += self?.groupA ?? [""]

        }
    }
    
    func getGoupB() {
        run(after: 4) { [weak self] in
            guard self != nil else { return }

            print("Group B added")
            self?.items += self?.groupB ?? [""]

        }
    }

    func getGoupC() {
        run(after: 6) { [weak self] in
            guard self != nil else { return }

            print("Group C added")
            
            self?.items += self?.groupC ?? [""]
        }
    }

    func getGroupD() {
        
        let deadline = DispatchTime.now()
        
        dispatchGroup.enter()
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            self.dispatchGroup.leave()
            print("Group D added")
            
            self.items += self.groupD

        }

    }
    
    func displayItems() {
        print("TableView reloaded")
        tableView.reloadData()
    }
    
    func run(after seconds: Int, completion:  @escaping () -> ()) {
        
        let deadline = DispatchTime.now() + .seconds(seconds)
        
        dispatchGroup.enter()
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            completion()
            self.dispatchGroup.leave()
        }
    }
    
    @IBAction func downloadTapped() {
        
        getGoupA()
        getGoupB()
        getGoupC()
        self.dispatchGroup.wait()

        getGroupD()
        
        dispatchGroup.notify(qos: .default, flags: .barrier, queue: .main) {
            self.displayItems()
        }
        
        dispatchGroup.notify(queue: .global()) {
            print("noti")
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        print("Dispatch group deallocated")
    }

}


extension DGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    
}
