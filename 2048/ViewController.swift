//
//  ViewController.swift
//  2048
//
//  Created by Nikolay Yarlychenko on 02.01.2020.
//  Copyright © 2020 Nikolay Yarlychenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var gameView: GameView! = nil
    var gameController: GameController! = nil
    
    @IBAction func swipeUp(_ sender: Any) {
        gameController.moveUp()
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        gameController.moveDown()
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        gameController.moveLeft()
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        gameController.moveRight()
    }
    
    @objc func click(_ sender: Any) {
        gameController.startGame()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameController.startGame()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1)
        gameView = GameView(frame: CGRect(x: 2.3, y: 145, width: 0, height: 0))
        
        self.gameController = GameController(gameView: gameView)
        view.addSubview(gameView)
        let btn = Button(frame: CGRect(x: 70, y: 600, width: 250, height: 40))
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    
}


class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .allowUserInteraction, animations: {
            if down {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } else {
                self.transform = .identity
            }
        }, completion: nil)
    }
    
    override var isHighlighted: Bool {
        didSet {
            shrink(down: isHighlighted)
        }
    }
    
    func setupView() {
        
//        addSubview(buttonView)
        backgroundColor = .white
        layer.cornerRadius = 10
        addSubview(labelView)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
    }
    
    
    var labelView: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.contentMode = .scaleToFill
        label.textColor = .black
        label.text = "Попробовать ещё раз"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    var buttonView: UIButton = {
        var button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
//        frame = CGRect(x: 65, y: 600, width: bounds.width, height: bounds.height)
        labelView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
}



class GameView: UIView {
    
    var gameCells: [[GameCell?]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.gameCells = [[nil, nil, nil, nil],
                          [nil, nil, nil, nil],
                          [nil, nil, nil, nil],
                          [nil, nil, nil, nil]]
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(mainView)
        
        for i in 0..<backViews.count {
            mainView.addSubview(backViews[i])
        }
    }
    
    #warning("Fix algorithm, and removing from superView for cellViews")
    func moveCells(by mtr: [[(Int, Int)]], gameState: [[Int]], completion: @escaping (_ success: Bool) -> Void) {
        UIView.animate(withDuration: 0.15, animations: {
            
            for i in 0...3 {
                for j in 0...3 {
                    if mtr[i][j] != (0, 0) {
                        if let cell = self.gameCells[i][j] {
                            cell.transform = cell.transform.translatedBy(x: CGFloat(mtr[i][j].1 * 94), y: CGFloat(mtr[i][j].0 * 94))
                            
                        }
                    }
                }
            }
        }, completion: {_ in
            
            for i in 0...3 {
                for j in 0...3 {
                    self.gameCells[i][j]?.removeFromSuperview()
                    self.gameCells[i][j] = nil
                    
                    
                    if gameState[i][j] != 0 {
                        let value = gameState[i][j]
                        let cell = GameCell(frame: CGRect(x: j * 94, y: i * 94, width: 89, height: 89))
                        cell.backView.backgroundColor = UIColor.getColorByValue(gameState[i][j])
                        if value <= 32 {
                            cell.labelView.textColor = .black
                        } else {
                            cell.labelView.textColor = .white
                        }
                        cell.labelView.text = String(gameState[i][j])
                        self.mainView.addSubview(cell)
                        self.gameCells[i][j] = cell
                        UIView.animate(withDuration: 0.1, animations: {
                            cell.backView.backgroundColor = UIColor.getColorByValue(gameState[i][j])
                        })
                    }
                }
            }
            
            completion(true)
        })
        
    }
    
    func addNewElement(at: (Int, Int), value: Int) {
        let cell = GameCell(frame: CGRect(x: at.1 * 94, y: at.0 * 94, width: 89, height: 89))
        cell.labelView.text = String(value)
        if value <= 32 {
            cell.labelView.textColor = .black
        } else {
            cell.labelView.textColor = .white
        }
        cell.backView.backgroundColor = UIColor.getColorByValue(value)
        cell.alpha = 0
        
        mainView.addSubview(cell)
        gameCells[at.0][at.1] = cell
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = .identity
            cell.alpha = 1
        })
    }
    
    
    var mainView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1)
        return view
    }()
    
    
    
    var backViews: [UIView] = {
        var views: [UIView] = []
        for _ in 1...16 {
            var view = UIView()
            view.layer.cornerRadius = 15
            view.backgroundColor = UIColor(red: 186/255, green: 193/255, blue: 204/255, alpha: 1)
            views.append(view)
        }
        return views
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.frame = CGRect(x: 0, y: 0, width: 371, height: 371)
        
        for i in 0..<4 {
            for j in 0..<4 {
                let pos = i * 4 + j
                backViews[pos].frame = CGRect(x: (j * 94), y: (i * 94), width: 89, height: 89)
            }
        }
        
    
        
    }
}


class GameCell: UIView {
    
    func setNumber(_ number: Int) {
        labelView.text = String(number)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(backView)
        backView.addSubview(labelView)
    }
    
    var backView: UIView = {
        var view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 15
        return view
    }()
    
    var labelView: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.contentMode = .scaleToFill
        label.textColor = .white
        label.text = "2"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.frame = CGRect(x: 0, y: 0, width: 89, height: 89)
        labelView.frame = CGRect(x: 0, y: 5, width: bounds.width, height: bounds.height - 10)
    }
}


extension UIColor {
    static func getColorByValue(_ value: Int) -> UIColor{
        switch value {
        case 2:
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        case 4:
            return UIColor(red: 226/255, green: 227/255, blue: 231/255, alpha: 1)
        case 8:
            return UIColor(red: 153/255, green: 222/255, blue: 255/255, alpha: 1)
        case 16:
            return UIColor(red: 92/255, green: 179/255, blue: 255/255, alpha: 1)
        case 32:
            return UIColor(red: 28/255, green: 139/255, blue: 235/255, alpha: 1)
        case 64:
            return UIColor(red: 0/255, green: 100/255, blue: 214/255, alpha: 1)
        case 128:
            return UIColor(red: 0/255, green: 74/255, blue: 128/255, alpha: 1)
        case 256:
            return UIColor(red: 29/255, green: 62/255, blue: 134/255, alpha: 1)
        case 512:
            return UIColor(red: 11/255, green: 44/255, blue: 132/255, alpha: 1)
        case 1024:
            return UIColor(red: 0/255, green: 23/255, blue: 178/255, alpha: 1)
        case 2048:
            return UIColor(red: 15/255, green: 6/255, blue: 108/255, alpha: 1)
        default:
            return .black
        }
    }
}
