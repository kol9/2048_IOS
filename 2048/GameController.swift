//
//  GameController.swift
//  2048
//
//  Created by Nikolay Yarlychenko on 04.01.2020.
//  Copyright © 2020 Nikolay Yarlychenko. All rights reserved.
//


import UIKit

class GameController {
    var gameState: [[Int]]
    var gameView: GameView
        
    func emptyCells() ->  [(Int, Int)] {
        var cells: [(Int,Int)] = []
        for i in 0 ..< 4 {
            for j in 0 ..< 4 {
                if gameState[i][j] == 0 {
                    cells.append((i, j))
                }
            }
        }
        return cells
    }
    
    
    init(gameView: GameView) {
        self.gameView = gameView
        self.gameState = [[0, 0, 0, 0],
                          [0, 0, 0, 0],
                          [0, 0, 0, 0],
                          [0, 0, 0, 0]]
    }
    
    func startGame() {
        clearField()
        addNewElement()
        addNewElement()
    }
    
    func clearField() {
        self.gameState = [[0, 0, 0, 0],
                          [0, 0, 0, 0],
                          [0, 0, 0, 0],
                          [0, 0, 0, 0]]
        for i in 0...3 {
            for j in 0...3 {
                if let cell = gameView.gameCells[i][j] {
                    UIView.animate(withDuration: 0.15, animations: {
                        cell.alpha = 0
                    }, completion: {_ in
                        cell.removeFromSuperview()
                    })
                }
                
                gameView.gameCells[i][j] = nil
            }
        }
    }
    
    func addNewElement() {
        let randRes = arc4random() % 10
        var newElement = 2
        if randRes == 0 {
            newElement = 4
        }
        
        if let newElementPos: (Int, Int) = emptyCells().randomElement() {
            print(newElementPos.0)
            print(newElementPos.1)
            gameState[newElementPos.0][newElementPos.1] = newElement
            gameView.addNewElement(at: newElementPos, value: newElement)
            print("Added element at \(newElementPos.0)  \(newElementPos.1)")
        }
        
        
        print(gameState[0])
        print(gameState[1])
        print(gameState[2])
        print(gameState[3])
        
    }
  
    func moveRight() {
        var moveMatrix = [[(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)]]
        
        var didMoved = false
        
        
        for i in 0...3 {
            for j in (0...2).reversed() {
                var k = j
                if gameState[i][j] == 0 {
                    continue
                }
                while k <= 2 {
                    if gameState[i][k] == gameState[i][k + 1] {
                        gameState[i][k + 1] = 2 * gameState[i][k]
                        gameState[i][k] = 0
                        moveMatrix[i][j] = (moveMatrix[i][j].0, moveMatrix[i][j].1 + 1)
                        didMoved = true
                        break
                    } else if gameState[i][k + 1] == 0 {
                        moveMatrix[i][j] = (moveMatrix[i][j].0, moveMatrix[i][j].1 + 1)
                        gameState[i].swapAt(k, k + 1)
                        didMoved = true
                        k += 1
                    } else {
                        break
                    }
                }
            }
        }
    
        if didMoved {
            gameView.moveCells(by: moveMatrix, gameState: gameState, completion: {_ in
                self.addNewElement()
            })
        }
    }
    
    func moveLeft() {
        var moveMatrix = [[(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)]]
        
        var didMoved = false
        for i in 0...3 {
            for j in 1...3 {
                var k = j
                if gameState[i][j] == 0 {
                    continue
                }
                while k >= 1 {
                    if gameState[i][k] == gameState[i][k - 1] {
                        gameState[i][k - 1] = 2 * gameState[i][k]
                        gameState[i][k] = 0
                        moveMatrix[i][j] = (moveMatrix[i][j].0, moveMatrix[i][j].1 - 1)
                        didMoved = true
                        break
                    } else if gameState[i][k - 1] == 0 {
                        moveMatrix[i][j] = (moveMatrix[i][j].0, moveMatrix[i][j].1 - 1)
                        gameState[i].swapAt(k, k - 1)
                        didMoved = true
                        k -= 1
                    } else {
                        break
                    }
                }
            }
        }
        
        
        if didMoved {
             gameView.moveCells(by: moveMatrix, gameState: gameState, completion: {_ in
                self.addNewElement()
             })
        }
    }
    
    func moveUp() {
        var moveMatrix = [[(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)]]
        
        var didMoved = false
        for j in 0...3 {
            for i in (1...3) {
                var k = i
                if gameState[i][j] == 0 {
                    continue
                }
                while k >= 1 {
                    if gameState[k][j] == gameState[k - 1][j] {
                        gameState[k - 1][j] = 2 * gameState[k][j]
                        gameState[k][j] = 0
                        moveMatrix[i][j] = (moveMatrix[i][j].0 - 1, moveMatrix[i][j].1)
                        didMoved = true
                        break
                    } else if gameState[k - 1][j] == 0 {
                        moveMatrix[i][j] = (moveMatrix[i][j].0 - 1, moveMatrix[i][j].1)
                        gameState[k - 1][j] = gameState[k][j]
                        gameState[k][j] = 0
                        didMoved = true
                        k -= 1
                    } else {
                        break
                    }
                    
                }
            }
        }
        
        if didMoved {
            gameView.moveCells(by: moveMatrix, gameState: gameState, completion: {_ in
                self.addNewElement()
            })
        }
    }
    
    func moveDown() {
        var moveMatrix = [[(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)]]
        
        
        var didMoved = false
        for j in 0...3 {
            for i in (0...2).reversed() {
                var k = i
                if gameState[i][j] == 0 {
                    continue
                }
                while k <= 2 {
                    if gameState[k][j] == gameState[k + 1][j] {
                        gameState[k + 1][j] = 2 * gameState[k][j]
                        gameState[k][j] = 0
                        moveMatrix[i][j] = (moveMatrix[i][j].0 + 1, moveMatrix[i][j].1)
                        didMoved = true
                        break
                    } else if gameState[k + 1][j] == 0 {
                        moveMatrix[i][j] = (moveMatrix[i][j].0 + 1, moveMatrix[i][j].1)
                        gameState[k + 1][j] = gameState[k][j]
                        gameState[k][j] = 0
                        didMoved = true
                        k += 1
                    } else {
                        break
                    }
                }
            }
        }
        
            
        if didMoved {
            gameView.moveCells(by: moveMatrix, gameState: gameState, completion: {_ in
                self.addNewElement()
            })
        }
    }
    
    
    
}

