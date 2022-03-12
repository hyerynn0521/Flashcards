//
//  ViewController.swift
//  Flashcards
//
//  Created by Hyerin Lee on 3/4/22.
//

import UIKit

class ViewController: UIViewController {
    //front = answer, back = question
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        frontLabel.isHidden = true;
        backLabel.isHidden = false;
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashCardsController = self
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        if frontLabel.isHidden == true{
            frontLabel.isHidden = false;
            backLabel.isHidden = true;
        } else{
            backLabel.isHidden = false;
            frontLabel.isHidden = true;
        }
       
    }
    func updateFlashCard(question: String, answer: String){
        let alert = UIAlertController(title: "Missing text", message: "You need both question and answer", preferredStyle: UIAlertController.Style.alert);
        if !question.trimmingCharacters(in: .whitespaces).isEmpty &&
            !answer.trimmingCharacters(in: .whitespaces).isEmpty{
            frontLabel.text = answer;
            backLabel.text = question;
        } else{
            present(alert, animated: true)
        }
        
    }
    
}

