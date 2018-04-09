//
//  QuizPrepareView.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 26/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class QuizPrepareView: UIViewController {
    @IBOutlet weak var txt_category: UITextField!
    @IBOutlet weak var txt_lvl: UITextField!
    @IBOutlet weak var txt_type: UITextField!
    @IBOutlet weak var txt_encoding: UITextField!
    @IBOutlet weak var start_button: UIButton!
    var category = TriviaCategory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpView(){
        txt_lvl.delegate = self
        txt_type.delegate = self
        txt_category.delegate = self
        txt_encoding.delegate = self
        txt_category.addTarget(self, action: #selector(TextBoxOn(_:)),for: .editingDidBegin)
        txt_lvl.addTarget(self, action: #selector(TextBoxOn(_:)),for: .editingDidBegin)
        txt_type.addTarget(self, action: #selector(TextBoxOn(_:)),for: .editingDidBegin)
        txt_encoding.addTarget(self, action: #selector(TextBoxOn(_:)),for: .editingDidBegin)
        self.start_button.setCornerRadius()
       }
    
    @objc func TextBoxOn(_ textField: UITextField) {
        switch textField.tag {
        case 1: if let category_view = self.storyboard?.instantiateViewController(withIdentifier: "QuizCategory") as? QuizCategory{
            category_view.callback = {(trivia) in
                category_view.dismiss(animated: true, completion: {
                    self.category = trivia
                    textField.text = trivia.name
                })
                }
            self.present(category_view, animated: true, completion: nil)
            }
        case 2: self.showActionSheet(title: "Choose Difficulty Level", params: ["Any Difficulty","Easy","Medium","Hard"], onAction:  {
            (action) in
            textField.text = action
        })
          case 3:
            self.showActionSheet(title: "Choose Question Type", params: ["Any Type","Multiple Choice","True/False",],onAction: {
                (action) in
                textField.text = action
            })
          case 4:
            self.showActionSheet(title: "Select Encoding Type", params: ["Default Encoding","Legacy URL Encoding","URL Encoding(RFC 3986)","Base64 Encoding"],onAction: {(action) in
                textField.text = action
           })
            default:
            print("success")
        }
       
    }
    
    @IBAction func startQuiz(_ sender: UIButton) {
        if let text = txt_category.text, text.isEmpty{
            self.showAlertController(message: "please select question category!")
        }
        else if let text = txt_lvl.text,text.isEmpty{
            self.showAlertController(message: "please select question level!")
        }
        else if let text = txt_type.text , text.isEmpty{
            self.showAlertController(message: "please select question type!")
        }
        else if let text = txt_encoding.text, text.isEmpty{
            self.showAlertController(message: "please select encoding format!")
        }
        else{
            if let questionView = self.storyboard?.instantiateViewController(withIdentifier: "QuestionView") as? QuestionView{
                let question =  Questions(amount:"15", type:self.txt_type.text!, level:self.txt_lvl.text!, category: self.category, coding: self.txt_encoding.text!)
                    questionView.question = question
                    self.navigationController?.pushViewController(questionView, animated: true)
            }
            
        }
        
    }
    
    func showAlertController(message: String){
        let alertController = UIAlertController(title: "Error!", message:message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

extension QuizPrepareView:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1...4:
            TextBoxOn(textField)
        default:
            break
        }
       return false
    }
}








