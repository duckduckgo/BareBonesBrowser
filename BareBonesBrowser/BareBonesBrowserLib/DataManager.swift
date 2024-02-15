//
//  DataManager.swift
//  BareBonesMobileBrowser
//
//  Created by Chris Brind on 24/08/2021.
//

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
