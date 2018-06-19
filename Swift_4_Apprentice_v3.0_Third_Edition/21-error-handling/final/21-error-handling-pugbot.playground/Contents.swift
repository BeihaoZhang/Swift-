/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

enum Direction {
  case left
  case right
  case forward
}

enum PugBotError: Error {
  case invalidMove(found: Direction, expected: Direction)
  case endOfPath
}

class PugBot {
  let name: String
  let correctPath: [Direction]
  private var currentStepInPath = 0
    
  init(name: String, correctPath: [Direction]) {
    self.correctPath = correctPath
    self.name = name
  }
    
  func turnLeft() throws {
    guard currentStepInPath < correctPath.count else {
            throw PugBotError.endOfPath
    }
    let nextDirection = correctPath[currentStepInPath]
    guard nextDirection == .left else {
            throw PugBotError.invalidMove(found: .left,
                                          expected: nextDirection)
    }
    currentStepInPath += 1
  }
    
  func turnRight() throws {
    guard currentStepInPath < correctPath.count else {
            throw PugBotError.endOfPath
    }
    let nextDirection = correctPath[currentStepInPath]
    guard nextDirection == .right else {
            throw PugBotError.invalidMove(found: .right,
                                          expected: nextDirection)
    }
    currentStepInPath += 1
  }
    
  func moveForward() throws {
    guard currentStepInPath < correctPath.count else {
            throw PugBotError.endOfPath
    }
    let nextDirection = correctPath[currentStepInPath]
    guard nextDirection == .forward else {
            throw PugBotError.invalidMove(found: .forward,
                                          expected: nextDirection)
    }
    currentStepInPath += 1
  }
  
  func reset() {
    currentStepInPath = 0
  }
}

let pug = PugBot(name: "Pug", correctPath: [.forward, .left, .forward, .right])

func goHome() throws {
  try pug.moveForward()
  try pug.turnLeft()
  try pug.moveForward()
  try pug.turnRight()
}

do {
  try goHome()
} catch {
  print("PugBot failed to get home.")
}

func moveSafely(_ movement: () throws -> ()) -> String {
  do {
    try movement()
    return "Completed operation successfully."
  } catch PugBotError.invalidMove(let found, let expected) {
    return "The PugBot was supposed to move \(expected), but moved \(found) instead."
  } catch PugBotError.endOfPath {
    return "The PugBot tried to move past the end of the path."
  } catch {
    return "An unknown error occurred"
  }
}

pug.reset()
moveSafely(goHome)

pug.reset()
moveSafely {
  try pug.moveForward()
  try pug.turnLeft()
  try pug.moveForward()
  try pug.turnRight()
}

func perform(times: Int, movement: () throws -> ()) rethrows {
  for _ in 1...times {
    try movement()
  }
}
