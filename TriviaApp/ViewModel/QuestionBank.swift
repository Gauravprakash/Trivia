//
//  QuestionBank.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 15/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
class QuestionBank{
var responseCode : Int!
var results : [Result]!
init(fromDictionary dictionary: [String:Any]){
            responseCode = dictionary["response_code"] as? Int
            results = [Result]()
            if let resultsArray = dictionary["results"] as? [[String:Any]]{
                for dic in resultsArray{
                    let value = Result(fromDictionary: dic)
                    results.append(value)
                }
            }
        }
}

class Result{
    var category : String!
    var correctAnswer : String!
    var difficulty : String!
    var incorrectAnswers : [String]!
    var question : String!
    var type : String!
    var options: [String]!

    init(fromDictionary dictionary: [String:Any]){
        category = dictionary["category"] as? String
        correctAnswer = dictionary["correct_answer"] as? String
        difficulty = dictionary["difficulty"] as? String
        incorrectAnswers = dictionary["incorrect_answers"] as? [String]
        question = dictionary["question"] as? String
        type = dictionary["type"] as? String
        options = mixedResposeTogether()
    }
    
    func mixedResposeTogether() -> [String]{
     var response:[String]! = []
        for item in incorrectAnswers{
            response.append(item)
        }
       response.insert(correctAnswer, at: Int(arc4random_uniform(UInt32(response.count))))
       return response
    }
    
}


