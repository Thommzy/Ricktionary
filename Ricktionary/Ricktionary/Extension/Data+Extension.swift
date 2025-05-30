//
//  Data+Extension.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/28/25.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                  return nil
              }
        return prettyPrintedString
    }
}
