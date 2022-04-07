//
//  ViewController.swift
//  Flashcards
//
//  Created by Hyerin Lee on 3/4/22.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    //front = answer, back = question
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    //Array to hold our flashcards
    var flashcards = [Flashcard]()
    //current flashcard index
    var currentIndex = 0
    
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        if currentIndex > 0 {
            currentIndex = currentIndex - 1
        }
        //updateLabels()
        updateNextPrevButtons()
        animateCardOut2()
        
    }
    @IBAction func didTapOnNext(_ sender: Any) {
        //increase current index
        if currentIndex < flashcards.count - 1 {
            currentIndex = currentIndex + 1
        }
        
        
        //update labels
        
        
        //update buttons
        updateNextPrevButtons()
        animateCardOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        frontLabel.isHidden = true;
        backLabel.isHidden = false;
        
        //read saved flashcards
        readSavedFlashcards()
        
        // Do any additional setup after loading the view.
        if flashcards.count == 0{
            updateFlashCard(question: "When is my birthday?", answer: "May 21st")
        } else{
            updateLabels()
            updateNextPrevButtons()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashCardsController = self
    }

   
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard();
       
       
    }
    func flipFlashcard(){
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.frontLabel.isHidden == true{
                self.frontLabel.isHidden = false;
                self.backLabel.isHidden = true;
            } else{
                self.backLabel.isHidden = false;
                self.frontLabel.isHidden = true;
            }
        })
    
    }
    func updateFlashCard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        flashcards.append(flashcard)
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        //update buttons
        updateNextPrevButtons()
        
        //update labels
        updateLabels()
        let alert = UIAlertController(title: "Missing text", message: "You need both question and answer", preferredStyle: UIAlertController.Style.alert);
        if !question.trimmingCharacters(in: .whitespaces).isEmpty &&
            !answer.trimmingCharacters(in: .whitespaces).isEmpty{
            frontLabel.text = answer;
            backLabel.text = question;
        } else{
            present(alert, animated: true)
        }
        saveAllFlashcardsToDisk()
        
    }
    func updateNextPrevButtons(){
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        }; if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
            prevButton.isEnabled = true
        }
        //Disable prev button if at the beginning
    }
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        
        //update labels
        frontLabel.text = currentFlashcard.answer
        backLabel.text = currentFlashcard.question
    }
    func saveAllFlashcardsToDisk(){
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer] }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("Woohoo, Flashcards saved to UserDefaults")
        
    }
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            flashcards.append(contentsOf: savedCards)
        }
        
    
    }
    func animateCardOut(){
        UIView.animate(withDuration: 0.3, animations:{
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0)
        }, completion: {finished in
            self.updateLabels()
            self.animateCardIn()})
    }
    func animateCardIn(){
        card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0)
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity;
        }
    }
    func animateCardOut2(){
        UIView.animate(withDuration: 0.3, animations:{
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0)
        }, completion: {finished in
            self.updateLabels()
            self.animateCardIn2()})
    }
    func animateCardIn2(){
        card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0)
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity;
        }
    }
}

