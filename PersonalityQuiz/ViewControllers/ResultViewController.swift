//
//  ResultViewController.swift
//  PersonalityQuiz
//
//  Created by  BoDim on 29.12.2021.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var labelTypeAnimal: UILabel!
    @IBOutlet weak var labelDescriptionAnimal: UILabel!
    
    var answersChosen: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        showResults()
    }

}

extension ResultViewController {
    
    private func showResults() {
        let mostPopularAnimal = Dictionary(grouping: answersChosen) { $0.animal }
            .sorted { $0.value.count > $1.value.count }
        updateUI(with: mostPopularAnimal.first?.key)
    }
    
    private func updateUI(with animal: Animal?) {
        labelTypeAnimal.text = "Вы - \(animal?.rawValue ?? Animal.dog.rawValue)!"
        labelDescriptionAnimal.text = animal?.definition ?? Animal.dog.definition
    }
    
}
