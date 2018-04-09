//
//  Question.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 15/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
class Question{
    var triviaCategories : [TriviaCategory]!
    init(fromDictionary dictionary: [String:Any]){
            triviaCategories = [TriviaCategory]()
            if let triviaCategoriesArray = dictionary["trivia_categories"] as? [[String:Any]]{
                for dic in triviaCategoriesArray{
                    let value = TriviaCategory(fromDictionary: dic)
                    triviaCategories.append(value)
                }
            }
        }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if triviaCategories != nil{
            var dictionaryElements = [[String:Any]]()
            for triviaCategoriesElement in triviaCategories {
                dictionaryElements.append(triviaCategoriesElement.toDictionary())
            }
            dictionary["trivia_categories"] = dictionaryElements
        }
        return dictionary
    }
}

class TriviaCategory:NSObject{
    
    var id : Int!
    var name : String!
   
    override init(){}
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
}

struct Questions{
    var amount:String!
    var questionType: String!
    var difficultLevel: String!
    var questionCategory:TriviaCategory!
    var encoding:String!
    
    init(amount: String, type:String,level:String,category:TriviaCategory,coding:String) {
        self.amount = amount
        self.questionType = type
        self.difficultLevel = level
        self.questionCategory = category
        self.encoding = coding
    }
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
         if self.amount != nil {
            dictionary["amount"] = self.amount
        }
        if self.questionType != nil && self.questionType != "Any Type"{
           dictionary["type"] = QuestionAttribute.setAttributeValue(status: self.questionType)
        }
        if self.difficultLevel != nil && self.difficultLevel != "Any Difficulty"{
            dictionary["difficulty"] = QuestionAttribute.setAttributeValue(status: self.difficultLevel)
        }
        if self.questionCategory != nil{
            dictionary["category"] = self.questionCategory.id.description
        }
        if self.encoding != nil && self.encoding != "Default Encoding" {
            dictionary["encode"] = QuestionAttribute.setAttributeValue(status: self.encoding)
        }
        
      return dictionary
    }
    

}

class QuestionAttribute {
    class func setAttributeValue(status:String) -> String {
        var statuValue:String! = ""
        switch status {
        case "Multiple Choice":
            statuValue = "multiple"
        case "True/False":
            statuValue = "boolean"
        case "Easy":
            statuValue = "easy"
        case "Medium":
            statuValue = "medium"
        case "Hard":
            statuValue = "hard"
        case "Legacy URL Encoding":
            statuValue = ""
        case "URL Encoding(RFC 3986)":
            statuValue = "url3986"
        case "Base64 Encoding":
            statuValue = "base64"
        default:break
        }
        return statuValue
}
    
  
}


