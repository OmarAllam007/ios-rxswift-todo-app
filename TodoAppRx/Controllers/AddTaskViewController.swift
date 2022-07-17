//
//  AddTaskViewController.swift
//  TodoAppRx
//
//  Created by Omar Khaled on 16/07/2022.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedControl:UISegmentedControl!
    @IBOutlet weak var taskTitleTextField:UITextField!
    
    

    private let taskPublishSubject = PublishSubject<Task>()
    
    var taskObservable:Observable<Task>  {
        return taskPublishSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    @IBAction func save(){
        guard let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex), let title = self.taskTitleTextField.text else { return }
        
        let task = Task(title: title, priority: priority)
        
        taskPublishSubject.onNext(task)
        
        self.dismiss(animated: true)
    }

}
