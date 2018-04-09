//
//  QuestionView.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 27/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import Moya
import RxSwift


//https://opentdb.com/api_category.php

class QuestionView: UIViewController {
static let sharedInstance = QuestionView()
@IBOutlet weak var tableView: UITableView!
@IBOutlet weak var timerLabel: UILabel!
    var tintedActivityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var correctResponse = 0
    var question: Questions!
    var arrdata:[String] = []
    var result:[Result] = [Result]()
    var disposeBag = DisposeBag()
    var currentQuestionNumber = 1
    var totalTime = 10
    var timer = Timer()

override func viewDidLoad() {
        super.viewDidLoad()
        configureTintedActivityIndicatorView()
        hitRequestToAccessQuestionData()
        self.registerTableView()
    }
 override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    
      }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
func hitRequestToAccessQuestionData(){
APIProvider.rx.request(Quizzler.OPENDB(question.toDictionary())).subscribe({[weak self] event in
        switch event{
            case .success(let response):
                if let json = try? response.mapJSON(){
                    if let dictionary = (json as? [String:Any]){
                    let data = QuestionBank(fromDictionary: dictionary)
                       self?.result = data.results
                        DispatchQueue.main.async {
                        self?.tintedActivityIndicatorView.stopAnimating()
                        self?.tableView.reloadData()
                        
                }
                     }
                    }
        case .error(let error):
               print(error.localizedDescription)
            }
            
        }).disposed(by: disposeBag)
    }
    
    func registerTableView(){
        let nib:UINib = UINib.init(nibName: "questioncell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "questioncell")
        self.tableView.tableFooterView = UIView(frame: .zero)
        }
    
    func nextQuestion() {
        if currentQuestionNumber < self.result.count {
            currentQuestionNumber = currentQuestionNumber + 1
            //startTimer()
        }
        else{
            if let completionView = self.storyboard?.instantiateViewController(withIdentifier: "QuizCompletionView") as? QuizCompletionView{
                completionView.score_text = correctResponse
                self.navigationController?.pushViewController(completionView, animated: true)
            }
        }
    }
    
    private func configureTintedActivityIndicatorView() {
        tintedActivityIndicatorView.activityIndicatorViewStyle = .white
        tintedActivityIndicatorView.color = UIColor.red
        tintedActivityIndicatorView.center = self.view.center
        view.addSubview(tintedActivityIndicatorView)
        tintedActivityIndicatorView.startAnimating()
    }
}
    
extension QuestionView: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int{
        if self.result.count>0{
        return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 1
        case 1:
            return 1+result[currentQuestionNumber-1].incorrectAnswers.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "questioncell", for: indexPath) as? questioncell{
        return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        switch indexPath.section{
        case 0:
            if let cell = cell as? questioncell{
                cell.setUpData(text: result[currentQuestionNumber-1].question.htmlToString)
            }
        case 1:
            if let cell = cell as? questioncell{
            cell.setUpData(text:result[currentQuestionNumber-1].options[indexPath.row].htmlToString)
            }
        default:
            print("No cell")
    }
    
    }
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 66
        case 1:
            return 50
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Question \(currentQuestionNumber)"
        case 1...:
            return "Options"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
           let text = self.result[currentQuestionNumber-1].options[indexPath.row]
            if text == self.result[currentQuestionNumber-1].correctAnswer{
                if correctResponse<=15{
                    correctResponse = correctResponse+1
                }
                DispatchQueue.main.async{
                    ProgressHUD.showSuccess("Correct!")
                }
               
            }
            else{
                DispatchQueue.main.async {
                  ProgressHUD.showError("Wrong!")
                }
                
            }
            self.nextQuestion()
            self.tableView.reloadData()
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
 
    @objc func updateTimer(){
        self.timerLabel.text = timeString(10)
        if totalTime != 0 {
            totalTime -= 1
        }else{
            stopTimer()
            nextQuestion()
        }
        
    }
    func stopTimer(){
        timer.invalidate()
    }
    
    fileprivate func timeString(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    
}


