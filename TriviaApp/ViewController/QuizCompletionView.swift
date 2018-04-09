//
//  QuizCompletionView.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 28/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class QuizCompletionView: UIViewController {
@IBOutlet weak var progressBar: UIProgressView!
@IBOutlet weak var scoreText: UILabel!
@IBOutlet weak var correctAnswer: UILabel!
var transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 6.0)
var score_text: Int!
@IBOutlet weak var retakeQuiz: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBar.transform = transform
        self.progressBar.progress = Float(score_text)/Float(15)
        self.progressBar.trackTintColor = .red
        self.progressBar.progressTintColor = .green
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.retakeQuiz.setCornerRadius()
        self.setUpView()
    }
    
    @IBAction func retakeQuiz(_ sender: UIButton) {
        self.navigateToScreen()
    }
    
    func setUpView(){
        self.navigationItem.hidesBackButton = true
        self.title = "Level Finished..!!"
        self.scoreText.text = "Score: \(score_text.description)"
        self.correctAnswer.text = "\(score_text.description)/15"
    }
}

extension QuizCompletionView{
    func navigateToScreen(){
        let appDelegate = UIApplication.shared.delegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let prepareView = storyboard.instantiateViewController(withIdentifier: "QuizNavigationView") as? UINavigationController{
            prepareView.popToRootViewController(animated: true)
            appDelegate?.window??.rootViewController = prepareView
    }
        
    }
}


