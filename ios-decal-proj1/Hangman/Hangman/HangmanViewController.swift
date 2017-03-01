//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {

    @IBOutlet weak var hangingMan: UIImageView!
    @IBOutlet weak var incorrectGuesses: UILabel!
    @IBOutlet weak var currentGuess: UILabel!
    @IBOutlet weak var emptyLetterArea: UILabel!
    @IBOutlet weak var currentGuessText: UITextField!
    @IBAction func GuessButton(_ sender: UIButton) {
        guessPressed()
    }
    
    @IBAction func StartOver(_ sender: UIButton) {
        startOver()
    }
    
    var answer: String?
    var knownString: String?
    var rip: Bool = false
    var winner: Bool = false
    var numLetters: Int = 0
    //var wordToGuess: String?
    var image: Int = 0
    var wordToGuess = [String] ()
    var currentState = [String]()
    var incorrectList = [String]()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        let phrase: String = hangmanPhrases.getRandomPhrase()
        numLetters = phrase.characters.count
        print(phrase)
    
        for letter in phrase.characters {
            if letter == " " {
                wordToGuess.append(" ")
                currentState.append(" ")
            } else {
                wordToGuess.append(String(letter))
                currentState.append("_")
            }
        }
        emptyLetterArea.text = getCurrState()
    }
    
    func getCurrState()->String {
        return currentState.joined(separator: " ")
    }
    
    func getGuesses()-> String{
        return incorrectList.joined(separator: " ")
    }
    
    func changePic() {
        image += 1
        hangingMan.image = UIImage(named: "hangman" + String(image))
        if (image > 6) {
            let alert = UIAlertController(title: "YOU SUCK", message: "Play again?", preferredStyle: .alert)
            //let yes = UIAlertAction(title: "Yes", style: .default, handler: resetAlert(alert: ))
            let yes = UIAlertAction(title: "Yes", style: .default) {
                action in self.startOver()
            }
            let no = UIAlertAction(title: "No", style: .default) {
                action in self.tooBad()
            }
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true, completion: nil)
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func startOver() {
        wordToGuess.removeAll()
        image = 0
        currentState.removeAll()
        incorrectList.removeAll()
        incorrectGuesses.text = getGuesses()
        viewDidLoad()
        changePic()
    }
    
    func tooBad() {
        let sucka = UIAlertController(title: "Too bad!", message: "You have to start over!", preferredStyle: .alert)
        let startingOver = UIAlertAction(title: "OK", style: .default) {
            action in self.startOver()
        }
        sucka.addAction(startingOver)
        self.present(sucka, animated: true, completion:nil)
    }
    
    func weHaveAWinner() {
        let winner = UIAlertController(title: "Winner", message: "Winner, Winner, Chicken Dinner!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            action in self.startOver()
        }
        
        winner.addAction(OKAction)
        self.present(winner, animated: true, completion:nil)

    }
    

    
    func guessPressed() {
        if !(rip) {
            let guess = currentGuessText.text?.uppercased()
            if (incorrectList.contains(guess!)) {
                currentGuessText.text = ""
                return
            }
            if ((guess?.characters.count)! > 1) {
                currentGuessText.text = ""
                return
            }
            else if wordToGuess.contains(guess!) {
                incorrectList.append(guess!)
                incorrectGuesses.text = getGuesses()
                for i in 0..<wordToGuess.count {
                    if (wordToGuess[i] == guess) {
                        currentState[i] = guess!
                        emptyLetterArea.text = getCurrState()
                        currentGuessText.text = ""
                        if (currentState == wordToGuess) {
                            weHaveAWinner();
                        }
                        
                    }
                }
            
            } else {
                incorrectList.append(guess!)
                incorrectGuesses.text = getGuesses()
                currentGuessText.text = ""
                changePic()
                }
        }

    }
}
