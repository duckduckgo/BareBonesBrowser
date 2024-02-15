//
//  DataManager.swift
//  BareBonesMobileBrowser
//
//  Created by Federico Cappelli on 06/02/2024.
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import Combine

public class DataManager: ObservableObject {

    @Published var trackerBlockerData: Data?

    func load() {
        DispatchQueue.global(qos: .utility).async {
            self.trackerBlockerData = try? Data(contentsOf: URL(string: "https://staticcdn.duckduckgo.com/trackerblocking/v2.1/tds.json")!)
        }
    }

}
