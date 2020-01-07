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
        gameController.verifyValues()
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        gameController.moveDown()
        gameController.verifyValues()
    }
    
    
    @IBAction func swipeLeft(_ sender: Any) {
        gameController.moveLeft()
        gameController.verifyValues()
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        gameController.moveRight()
        gameController.verifyValues()
    }
    @IBAction func click(_ sender: Any) {
        gameController.moveRight()
        gameController.verifyValues()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        
        gameView = GameView(frame: CGRect(x: 2.3, y: 175, width: 0, height: 0))
        
        self.gameController = GameController(gameView: gameView)
        view.addSubview(gameView)
        
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
    
    
    func moveCells(by mtr: [[(Int, Int)]], type: Int) {
        UIView.animate(withDuration: 0.3, animations: {
          
            // 0 - right
            // 1 - left
            // 2 - up
            // 3 - down
            
            
            
            let I = (0...3)
            let J = (0...3)
            
            
            
            if type == 1 {
                for i in I {
                    for j in J {
                        if mtr[i][j] != (0, 0) {
                            if let cell = self.gameCells[i][j] {
                                
                                cell.transform = cell.transform.translatedBy(x: CGFloat(mtr[i][j].1 * 94), y: CGFloat(mtr[i][j].0 * 94))
                                
                                self.gameCells[i + mtr[i][j].0][j + mtr[i][j].1]?.removeFromSuperview()
                                self.gameCells[i + mtr[i][j].0][j + mtr[i][j].1] = cell
                            }
                            self.gameCells[i][j] = nil
                        }
                    }
                }
            } else if type == 3 {
                for j in J {
                    for i in I.reversed() {
                        if mtr[i][j] != (0, 0) {
                            if let cell = self.gameCells[i][j] {
                                
                                cell.transform = cell.transform.translatedBy(x: CGFloat(mtr[i][j].1 * 94), y: CGFloat(mtr[i][j].0 * 94))
                                
                                self.gameCells[i + mtr[i][j].0][j + mtr[i][j].1]?.removeFromSuperview()
                                self.gameCells[i + mtr[i][j].0][j + mtr[i][j].1] = cell
                            }
                            self.gameCells[i][j] = nil
                        }
                    }
                }
            } else if type == 0 {
                for i in I {
                    for j in J.reversed() {
                        if mtr[i][j] != (0, 0) {
                            if let cell = self.gameCells[i][j] {
                                
                                cell.transform = cell.transform.translatedBy(x: CGFloat(mtr[i][j].1 * 94), y: CGFloat(mtr[i][j].0 * 94))
                                
                                self.gameCells[i + mtr[i][j].0][j + mtr[i][j].1]?.removeFromSuperview()
                                self.gameCells[i + mtr[i][j].0][j + mtr[i][j].1] = cell
                            }
                            self.gameCells[i][j] = nil
                        }
                    }
                }
            } else {
                for j in J{
                    for i in I {
                        if mtr[i][j] != (0, 0) {
                            if let cell = self.gameCells[i][j] {
                                
                                cell.transform = cell.transform.translatedBy(x: CGFloat(mtr[i][j].1 * 94), y: CGFloat(mtr[i][j].0 * 94))
                                
                                self.gameCells[i + mtr[i][j].0][j + mtr[i][j].1]?.removeFromSuperview()
                                self.gameCells[i + mtr[i][j].0][j + mtr[i][j].1] = cell
                            }
                            self.gameCells[i][j] = nil
                        }
                    }
                }
            }
        })
        
    }
    
    func addNewElement(at: (Int, Int), value: Int) {
        let cell = GameCell(frame: CGRect(x: at.1 * 94, y: at.0 * 94, width: 89, height: 89))
        cell.labelView.text = String(value)
        mainView.addSubview(cell)
        gameCells[at.0][at.1] = cell
    }
    
    
    var mainView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var labelView: UILabel = {
        var label = UILabel()
        
        return label
    }()
    
    var backViews: [UIView] = {
        var views: [UIView] = []
        for _ in 1...16 {
            var view = UIView()
            view.layer.cornerRadius = 15
            view.backgroundColor = .red
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
