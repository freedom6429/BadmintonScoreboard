//
//  ViewController.swift
//  BadmintonScoreboard
//
//  Created by Wen Luo on 2022/1/6.
//

import UIKit

class ViewController: UIViewController {
    
    
    var counter = 0
    var timer = Timer()
    var roundNumber = 1
    //紀錄每回合的winner，才能知道下一局哪方發球還有rewind時應該哪方分數要調整
    var roundWinner: [String] = []
    //預設發球方為player1
    var serveSequence = ["player1"]
    var player1Name = "Player 1"
    var player2Name = "Player 2"
    var player1RoundScore = 0
    var player2RoundScore = 0
    var player1Score = 0
    var player2Score = 0
    var deuce = false
    //deuceType為1時代表第一次deuce(20:20)，2為第2次deuce(29:29)

    @IBOutlet weak var player1NameTextField: UITextField!
    
    @IBOutlet weak var player2NameTextField: UITextField!
    
    @IBOutlet weak var leftPlayerNameLabel: UILabel!
    
    @IBOutlet weak var rightPlayerNameLabel: UILabel!
    
    @IBOutlet weak var player1NameEditButton: UIButton!
    
    @IBOutlet weak var player2NameEditButton: UIButton!
    
    @IBOutlet weak var leftPlayerRoundScoreLabel: UILabel!
    
    @IBOutlet weak var rightPlayerRoundScoreLabel: UILabel!
    
    @IBOutlet weak var leftPlayerScoreLabel: UILabel!
    
    @IBOutlet weak var rightPlayerScoreLabel: UILabel!
    
    @IBOutlet weak var leftPlayerGetPointButton: UIButton!
    
    @IBOutlet weak var leftPlayerMinusPointButton: UIButton!
    
    @IBOutlet weak var rightPlayerGetPointButton: UIButton!
    
    @IBOutlet weak var rightPlayerMinusPointButton: UIButton!
    
    @IBOutlet weak var deuceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var rightPlayerServeLabel: UILabel!
    
    @IBOutlet weak var leftPlayerServeLabel: UILabel!
    
    @IBOutlet weak var changeSideButton: UIButton!
    
    @IBOutlet weak var roundNumberLabel: UILabel!

    @IBOutlet weak var rewindButton: UIButton!
    
    func setPauseButtonTitle() {
        pauseButton.setTitle("RESUME", for: .selected)
        pauseButton.setTitle("PAUSE", for: .normal)
    }
    
    func setChangeNameButtonTitle() {
        player1NameEditButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        player1NameEditButton.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        player2NameEditButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        player2NameEditButton.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
    }
    
    func formatedTime(_ secs: Int) -> String {
        var minString = ""
        var secString = ""
        if secs / 60 == 0 {
            minString = "00"
        } else if (secs / 60 > 0 && secs / 60 < 10) {
            minString = "0\(secs / 60)"
        } else {
            minString = "\(secs / 60)"
        }
        if secs % 60 == 0 {
            secString = "00"
        } else if (secs % 60 > 0 && secs % 60 < 10) {
            secString = "0\(secs % 60)"
        } else {
            secString = "\(secs % 60)"
        }
        return "\(minString):\(secString)"
    }
    
    func canEditName(){
        player1NameTextField.text = player1Name
        player2NameTextField.text = player2Name
        player1NameEditButton.isHidden = false
        player1NameTextField.isHidden = true
        player2NameEditButton.isHidden = false
        player2NameTextField.isHidden = true
    }
    
    func canNotEditName(){
        if player1Name == "" {
            player1Name = "Player 1"
        }
        if player2Name == "" {
            player2Name = "Player 2"
        }
        leftPlayerNameLabel.text = player1Name
        rightPlayerNameLabel.text = player2Name
        player1NameEditButton.isHidden = true
        player1NameTextField.isHidden = true
        player2NameEditButton.isHidden = true
        player2NameTextField.isHidden = true
    }
    
    func disablePointButtons(){
        leftPlayerGetPointButton.isEnabled = false
        leftPlayerMinusPointButton.isEnabled = false
        rightPlayerGetPointButton.isEnabled = false
        rightPlayerMinusPointButton.isEnabled = false
    }
    
    func enablePointButtons(){
        leftPlayerGetPointButton.isEnabled = true
        leftPlayerMinusPointButton.isEnabled = true
        rightPlayerGetPointButton.isEnabled = true
        rightPlayerMinusPointButton.isEnabled = true
    }
    
    func setScoreAndNamesLabels(_ roundNumber: Int) {
        if roundNumber % 2 != 0 {
            leftPlayerScoreLabel.text = String(player1Score)
            rightPlayerScoreLabel.text = String(player2Score)
            leftPlayerRoundScoreLabel.text = String(player1RoundScore)
            rightPlayerRoundScoreLabel.text = String(player2RoundScore)
            leftPlayerNameLabel.text = player1Name
            rightPlayerNameLabel.text = player2Name
        } else {
            leftPlayerScoreLabel.text = String(player2Score)
            rightPlayerScoreLabel.text = String(player1Score)
            leftPlayerRoundScoreLabel.text = String(player2RoundScore)
            rightPlayerRoundScoreLabel.text = String(player1RoundScore)
            leftPlayerNameLabel.text = player2Name
            rightPlayerNameLabel.text = player1Name
        }
    }
    
    func identifyServe(player: String, round: Int) {
        if player == "player1" {
            if round % 2 != 0 {
                leftPlayerServeLabel.isHidden = false
                rightPlayerServeLabel.isHidden = true
            } else {
                leftPlayerServeLabel.isHidden = true
                rightPlayerServeLabel.isHidden = false
            }
        } else if player == "player2" {
            if round % 2 != 0 {
                leftPlayerServeLabel.isHidden = true
                rightPlayerServeLabel.isHidden = false
            } else {
                leftPlayerServeLabel.isHidden = false
                rightPlayerServeLabel.isHidden = true
            }
        }
    }

    
    func roundEnd(roundNumber: inout Int, winner: String){
        disablePointButtons()
        timer.invalidate()
        pauseButton.isSelected = true
        roundWinner.append(winner)
        if roundNumber % 2 != 0 {
            leftPlayerRoundScoreLabel.text = String(player1RoundScore)
            rightPlayerRoundScoreLabel.text = String(player2RoundScore)
        } else {
            leftPlayerRoundScoreLabel.text = String(player2RoundScore)
            rightPlayerRoundScoreLabel.text = String(player1RoundScore)
        }
        if player1RoundScore == 2 {
            roundNumberLabel.text = "\(player1Name) wins!"
            pauseButton.isSelected = false
            pauseButton.isEnabled = false
        } else if player2RoundScore == 2{
            roundNumberLabel.text = "\(player2Name) wins!"
            pauseButton.isSelected = false
            pauseButton.isEnabled = false
        } else {
            changeSideButton.isEnabled = true
        }
        roundNumber += 1
        rewindButton.isEnabled = true
    }
    
    func evaluation() {
        if deuce == false {
            if (player1Score == 20  && player2Score == 20) {
                deuce = true
                deuceLabel.isHidden = false
            } else if (player1Score == 21 || player2Score == 21) || (player1Score == 30 || player2Score == 30)  {
                if player1Score == 21 || player1Score == 30 {
                    player1RoundScore += 1
                    roundEnd(roundNumber: &roundNumber, winner: "player1")
                } else  {
                    player2RoundScore += 1
                    roundEnd(roundNumber: &roundNumber, winner: "player2")
                }
            }
        } else if deuce == true {
            if (player1Score - player2Score == 2) {
                player1RoundScore += 1
                roundEnd(roundNumber: &roundNumber, winner: "player1")
            } else if (player2Score - player1Score == 2) {
                player2RoundScore += 1
                roundEnd(roundNumber: &roundNumber, winner: "player2")
            } else if (player1Score == 29 && player2Score == 29){
                deuce = false
                deuceLabel.isHidden = true
            }
        }
        
    }
    
    
    @objc func updateTime() {
        counter += 1
//        print(counter)
        timeLabel.text = formatedTime(counter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timeLabel.text = formatedTime(counter)
        pauseButton.isEnabled = false
        setPauseButtonTitle()
        setChangeNameButtonTitle()
        canEditName()
        rewindButton.isEnabled = false
        changeSideButton.isEnabled = false
        leftPlayerRoundScoreLabel.text = "0"
        rightPlayerRoundScoreLabel.text = "0"
        leftPlayerGetPointButton.isEnabled = false
        leftPlayerMinusPointButton.isEnabled = false
        rightPlayerGetPointButton.isEnabled = false
        rightPlayerMinusPointButton.isEnabled = false
        leftPlayerServeLabel.isHidden = true
        rightPlayerServeLabel.isHidden = true
        
    }

    
    @IBAction func editPlayer1TextField(_ sender: UITextField) {
        player1NameTextField.isHidden = true
        view.endEditing(true)
    }
    
    @IBAction func pauseGameButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        } else {
            sender.isSelected = true
            timer.invalidate()
        }
    }
    
    @IBAction func startPlayingButton(_ sender: UIButton) {
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        canNotEditName()
//        print(player1Name)
//        print(player2Name)
        changeSideButton.isEnabled = false
        leftPlayerGetPointButton.isEnabled = true
        leftPlayerMinusPointButton.isEnabled = true
        rightPlayerGetPointButton.isEnabled = true
        rightPlayerMinusPointButton.isEnabled = true
        leftPlayerServeLabel.isHidden = false
    }
    
    @IBAction func newMatchButton(_ sender: Any) {
        roundNumber = 1
        roundNumberLabel.text = "Round \(roundNumber)"
        deuce = false
        roundWinner = []
        player1Score = 0
        player2Score = 0
        player1RoundScore = 0
        player2RoundScore = 0
        serveSequence.removeAll()
        serveSequence.append("player1")
        leftPlayerServeLabel.isHidden = false
        rightPlayerServeLabel.isHidden = true
        setScoreAndNamesLabels(roundNumber)
        counter = 0
        timeLabel.text = formatedTime(counter)
        timer.invalidate()
        startButton.isEnabled = true
        pauseButton.isSelected = false
        pauseButton.isEnabled = false
        changeSideButton.isEnabled = false
        canEditName()
    }
    
    @IBAction func editPlayer1NameButton(_ sender: UIButton) {
        if sender.isSelected {
            view.endEditing(true)
            player1NameTextField.isHidden = true
            if player1NameTextField.text == "" {
                player1Name = "Player 1"
            } else {
                player1Name = player1NameTextField.text!
            }
            leftPlayerNameLabel.text = player1Name
            sender.isSelected = false
        } else {
            sender.isSelected = true
            player2NameEditButton.isSelected = false
            player2NameTextField.isHidden = true
            player1NameTextField.isHidden = false
        }
    }
    
    @IBAction func editPlayer2NameButton(_ sender: UIButton) {
        if sender.isSelected {
            view.endEditing(true)
            player2NameTextField.isHidden = true
            if player2NameTextField.text == "" {
                player2Name = "Player 2"
            } else {
                player2Name = player1NameTextField.text!
            }
            sender.isSelected = false
        } else {
            sender.isSelected = true
            player1NameEditButton.isSelected = false
            player1NameTextField.isHidden = true
            player2NameTextField.isHidden = false
        }
    }
    
    @IBAction func leftGetPointButton(_ sender: UIButton) {
        if roundNumber % 2 != 0 {
            player1Score += 1
            leftPlayerScoreLabel.text = String(player1Score)
            evaluation()
            serveSequence.append("player1")
//            print("current round:\(roundNumber)")
//            print("current deuce:\(deuce)")
        } else {
            player2Score += 1
            leftPlayerScoreLabel.text = String(player2Score)
            evaluation()
            serveSequence.append("player2")
//            print("current round:\(roundNumber)")
//            print("current deuce:\(deuce)")
        }
        leftPlayerServeLabel.isHidden = false
        rightPlayerServeLabel.isHidden = true
    }
    
    @IBAction func rightGetPointButton(_ sender: UIButton) {
        if roundNumber % 2 == 0 {
            player1Score += 1
            rightPlayerScoreLabel.text = String(player1Score)
            evaluation()
            serveSequence.append("player1")
//            print("current round:\(roundNumber)")
//            print("current deuce:\(deuce)")
        } else {
            player2Score += 1
            rightPlayerScoreLabel.text = String(player2Score)
            evaluation()
            serveSequence.append("player2")
//            print("current round:\(roundNumber)")
//            print("current deuce:\(deuce)")
        }
        leftPlayerServeLabel.isHidden = true
        rightPlayerServeLabel.isHidden = false
    }
    
    @IBAction func leftMinusPointButton(_ sender: Any) {
        if leftPlayerScoreLabel.text == "0" {
            return
        } else if roundNumber % 2 != 0 {
            player1Score -= 1
            leftPlayerScoreLabel.text = String(player1Score)
            serveSequence.removeLast()
            if serveSequence[serveSequence.count - 1] == "player1" {
                leftPlayerServeLabel.isHidden = false
                rightPlayerServeLabel.isHidden = true
            } else {
                leftPlayerServeLabel.isHidden = true
                rightPlayerServeLabel.isHidden = false
            }
        } else {
            player2Score -= 1
            leftPlayerScoreLabel.text = String(player2Score)
            if serveSequence[serveSequence.count - 1] == "player1" {
                leftPlayerServeLabel.isHidden = true
                rightPlayerServeLabel.isHidden = false
            } else {
                leftPlayerServeLabel.isHidden = false
                rightPlayerServeLabel.isHidden = true
            }
        }
    }
    
    @IBAction func rightMinusPointButton(_ sender: Any) {
        if rightPlayerScoreLabel.text == "0" {
            return
        } else if roundNumber % 2 == 0 {
            player1Score -= 1
            rightPlayerScoreLabel.text = String(player1Score)
            if serveSequence[serveSequence.count - 1] == "player1" {
                leftPlayerServeLabel.isHidden = true
                rightPlayerServeLabel.isHidden = false
            } else {
                leftPlayerServeLabel.isHidden = false
                rightPlayerServeLabel.isHidden = true
            }
        } else {
            player2Score -= 1
            rightPlayerScoreLabel.text = String(player2Score)
            serveSequence.removeLast()
            if serveSequence[serveSequence.count - 1] == "player1" {
                leftPlayerServeLabel.isHidden = false
                rightPlayerServeLabel.isHidden = true
            } else {
                leftPlayerServeLabel.isHidden = true
                rightPlayerServeLabel.isHidden = false
            }
        }
    }
    
    
    @IBAction func changeSideButton(_ sender: UIButton) {
        //重新開始計時
        //該回合得分重置
        //回合比數交換
        //名稱交換
        //重置deuceType
        //更新roundNumberLabel
        //根據前一回合確認發球方
        //重置serveSequence
        player1Score = 0
        player2Score = 0
        deuce = false
        setScoreAndNamesLabels(roundNumber)
        let newRoundServe = serveSequence.popLast()!
        serveSequence.removeAll()
        serveSequence.append(newRoundServe)
        identifyServe(player: newRoundServe, round: roundNumber)
        roundNumberLabel.text = "Round \(roundNumber)"
        enablePointButtons()
        sender.isEnabled = false
        rewindButton.isEnabled = false
    }
    
    @IBAction func rewindRoundButton(_ sender: UIButton) {
        //倒退回前一回合最後一個比分
        roundNumber -= 1
        roundNumberLabel.text = "Round \(roundNumber)"
        let whoGetsTheLastPoint = serveSequence.popLast()!
        if whoGetsTheLastPoint == "player1" {
            player1Score -= 1
            player1RoundScore -= 1
        } else {
            player2Score -= 1
            player2RoundScore -= 1
        }
        identifyServe(player: whoGetsTheLastPoint, round: roundNumber)
        setScoreAndNamesLabels(roundNumber)
        enablePointButtons()
        sender.isEnabled = false
        changeSideButton.isEnabled = false
    }
    
}

