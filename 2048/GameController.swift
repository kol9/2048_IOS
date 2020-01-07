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
        }
        
    }
  
    func verifyValues() {
        
        for i in 0...3 {
            for j in 0...3 {
                if gameState[i][j] != 0 {
                    if let gameCell = gameView.gameCells[i][j] {
                        gameCell.labelView.text = String(gameState[i][j])
                    }
                }
            }
        }
    }
    
    func moveRight() {
        var moveMatrix = [[(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)]]
        
        
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
                        break
                    } else if gameState[i][k + 1] == 0 {
                        moveMatrix[i][j] = (moveMatrix[i][j].0, moveMatrix[i][j].1 + 1)
                        gameState[i].swapAt(k, k + 1)
                    }
                    k += 1
                }
            }
        }
        
        gameView.moveCells(by: moveMatrix, type: 0)
    }
    
    func moveLeft() {
        var moveMatrix = [[(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)]]
        
        
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
                        break
                    } else if gameState[i][k - 1] == 0 {
                        moveMatrix[i][j] = (moveMatrix[i][j].0, moveMatrix[i][j].1 - 1)
                        gameState[i].swapAt(k, k - 1)
                    }
                    k -= 1
                }
            }
        }
        
        gameView.moveCells(by: moveMatrix, type: 1)
    }
    
    func moveUp() {
        var moveMatrix = [[(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)]]
        
        
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
                        break
                    } else if gameState[k - 1][j] == 0 {
                        moveMatrix[i][j] = (moveMatrix[i][j].0 - 1, moveMatrix[i][j].1)
                        gameState[k - 1][j] = gameState[k][j]
                        gameState[k][j] = 0
                    }
                    k -= 1
                }
            }
        }
        
        gameView.moveCells(by: moveMatrix, type: 2)
    }
    
    func moveDown() {
        var moveMatrix = [[(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)],
                          [(0, 0), (0, 0), (0, 0), (0, 0)]]
        
        
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
                        break
                    } else if gameState[k + 1][j] == 0 {
                        moveMatrix[i][j] = (moveMatrix[i][j].0 + 1, moveMatrix[i][j].1)
                        gameState[k + 1][j] = gameState[k][j]
                        gameState[k][j] = 0
                    }
                    k += 1
                }
            }
        }
        
        gameView.moveCells(by: moveMatrix, type: 3)
    }
    
    
    
}

