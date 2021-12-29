//
//  QuestionsViewController.swift
//  PersonalityQuiz
//
//  Created by  BoDim on 29.12.2021.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var progressViewQuestion: UIProgressView!
    
    @IBOutlet weak var stackSingle: UIStackView!
    @IBOutlet var buttonsSingle: [UIButton]!
    
    @IBOutlet weak var stackMultiple: UIStackView!
    @IBOutlet var labelsMultiple: [UILabel]!
    @IBOutlet var switchesMultiple: [UISwitch]!
    
    @IBOutlet weak var stackRanged: UIStackView!
    @IBOutlet var labelsRanged: [UILabel]!
    @IBOutlet weak var sliderRanged: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            sliderRanged.maximumValue = answerCount
            sliderRanged.value = answerCount / 2
        }
    }
    
    private let questions = Question.getQuestions()
    private var answersChosen: [Answer] = []
    private var questionIndex = 0
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        resultVC.answersChosen = answersChosen
    }
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = buttonsSingle.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (switchMultiple, answer) in zip(switchesMultiple, currentAnswers) {
            if switchMultiple.isOn {
                answersChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(sliderRanged.value)
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
}

//MARK: - Private Methods
extension QuestionsViewController {
    
    private func updateUI() {
        for stackView in [stackSingle, stackMultiple, stackRanged] {
            stackView?.isHidden = true
        }
        
        let currentQuestion = questions[questionIndex]
        
        labelQuestion.text = currentQuestion.title
        
        let totalProgress = Float(questionIndex) / Float(questions.count)
        progressViewQuestion.setProgress(totalProgress, animated: true)
        
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .ranged: showRangedStackView(with: currentAnswers)
        }
    }
    
    private func showSingleStackView(with answers: [Answer]) {
        stackSingle.isHidden.toggle()
        
        for (button, answer) in zip(buttonsSingle, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        stackMultiple.isHidden.toggle()
        
        for (label, answer) in zip(labelsMultiple, answers) {
            label.text = answer.title
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        stackRanged.isHidden.toggle()
        
        labelsRanged.first?.text = answers.first?.title
        labelsRanged.last?.text = answers.last?.title
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}
