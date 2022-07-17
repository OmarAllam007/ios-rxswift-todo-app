//
//  ViewController.swift
//  TodoAppRx
//
//  Created by Omar Khaled on 16/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
class TaskListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    
    @IBAction func segmentedControlChanged(segmented: UISegmentedControl) {
        let priority = Priority(rawValue: segmented.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController, let addTVC = navController.viewControllers.first as? AddTaskViewController else {
            fatalError("Big Errorrrr")
        }
        
        addTVC.taskObservable.subscribe { [unowned self] task in
            let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
            
            var currentTasks = self.tasks.value
            currentTasks.append(task)
            self.tasks.accept(currentTasks)
            
            
            self.filterTasks(by: priority)
            print(filteredTasks)
            self.updateTableView()
        }.disposed(by: disposeBag)
    }
    
    private func updateTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority:Priority?){
        if priority == nil {
            self.filteredTasks = self.tasks.value
        }else{
            self.tasks.map { tasks in
                return tasks.filter({ $0.priority == priority })
            }.subscribe { [weak self] tasks in
                self?.filteredTasks = tasks
            }
        }
        self.updateTableView()
        print(self.filteredTasks.count)
    }

}

extension TaskListViewController: UITableViewDelegate {
    
}

extension TaskListViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
    

    
}
