//
//  String+Extension.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/15/22.
//  Copyright © 2022 Marc Esperas. All rights reserved.
//

import Foundation

extension String {
    func trimWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
