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

import Foundation

/*:
 ## Encoding and Decoding Types
 ### Challenge 1
 Given the structures below:

 ```swift
 struct Spaceship {
   var name: String
   var crew: [Spaceman]
 }

 struct Spaceman {
   var name: String
   var race: String
 }
 ```

 Make the necessary modifications to make `Spaceship` codable. */

struct Spaceship: Codable {
  var name: String
  var crew: [Spaceman]
}

struct Spaceman: Codable {
  var name: String
  var race: String
}

/*:
 ### Challenge 2
It appears that the spaceship's interface is different than that of the outpost on Mars. The Mars outpost expects to get the spaceship's name as **spaceship_name**. Make the necessary modifications so encoding the structure would return the JSON in the correct format.
*/

extension Spaceship {
  enum CodingKeys: String, CodingKey {
    case name = "spaceship_name"
    case crew
  }
}

/*:
 ### Challenge 3
 You received a transmission from planet Earth about a new spaceship. This is the incoming message:

 ```
 {"spaceship_name":"USS Enterprise", "captain":{"name":"Spock", "race":"Human"}, "officer":{"name": "Worf", "race":"Klingon"}}
 ```

 Write a custom decoder to convert this JSON into a `Spaceship`.
*/

extension Spaceship {
  /*
   Note that the automatic encoder will always use the `CodingKeys` enum.
   This `CrewKeys` enum is only used by our custom decoder.
   */
  enum CrewKeys: String, CodingKey {
    case captain
    case officer
  }
}

extension Spaceship {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    let crewValues = try decoder.container(keyedBy: CrewKeys.self)
    let captain = try crewValues.decode(Spaceman.self, forKey: .captain)
    let officer = try crewValues.decode(Spaceman.self, forKey: .officer)
    crew = [captain, officer]
  }
}

let incoming = "{\"spaceship_name\": \"USS Enterprise\", \"captain\":{\"name\":\"Spock\", \"race\":\"Human\"}, \"officer\":{\"name\": \"Worf\", \"race\":\"Klingon\"}}"

let newSpaceship = try JSONDecoder().decode(Spaceship.self, from: incoming.data(using: .utf8)!)

print(newSpaceship)
