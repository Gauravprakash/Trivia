//
//  QuizCategory.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 26/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class QuizCategory: UIViewController {
    public var callback : ((TriviaCategory) -> ())?
    let disposeBag = DisposeBag()
    var triviaCategory:[TriviaCategory] = [TriviaCategory]()
    var tintedActivityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    let numberOfCellsPerRow:CGFloat = 3
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTintedActivityIndicatorView()
         APIProvider.rx.request(Quizzler.CATEGORY).subscribe({[weak self] event in
            switch event{
            case .success(let response):
                if let json = try? response.mapJSON() {
                    if let dictionary = (json as? [String:Any]){
                       let data = Question(fromDictionary: dictionary)
                        self?.triviaCategory = data.triviaCategories.map({$0})
                        let nib = UINib(nibName: "CategoryCell", bundle: nil)
                        self?.collectionView.register(nib, forCellWithReuseIdentifier: "CategoryCell")
                        self?.tintedActivityIndicatorView.stopAnimating()
                        self?.collectionView.reloadData()
                    }
                    
                }
              case .error(let error):
                print(error.localizedDescription)
                
            }
            
        }).disposed(by: disposeBag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.title = "Select Any Category"
    }

    private func configureTintedActivityIndicatorView() {
        tintedActivityIndicatorView.activityIndicatorViewStyle = .whiteLarge
        tintedActivityIndicatorView.color = UIColor.red
        tintedActivityIndicatorView.center = self.view.center
        view.addSubview(tintedActivityIndicatorView)
        tintedActivityIndicatorView.startAnimating()
    }

}

extension QuizCategory:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return triviaCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.setUpData(data:triviaCategory[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let horizontalSpacing = flowLayout?.scrollDirection == .vertical ? flowLayout?.minimumInteritemSpacing : flowLayout?.minimumLineSpacing
        let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing!)/numberOfCellsPerRow
        flowLayout?.itemSize = CGSize(width: cellWidth, height: cellWidth)
        return (flowLayout?.itemSize)!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callback?(triviaCategory[indexPath.row])
    }
    
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
