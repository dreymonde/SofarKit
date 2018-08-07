
import SwiftSoup
import Foundation

extension SofarEventHighlight {
    
    public static func sofarEvent(from link: Element) throws -> SofarEventHighlight? {
        let href = try link.attr("href")
        if href.hasPrefix("/events/"), let text = try? link.text(), !text.isEmpty {
            
            //        print(href)
            //        print("Text:", (try? link.text()) ?? "none")
            //        dump(link.parent()!.siblingElements().map({ $0.description }))
            //        print("")
            
            let eventCodeUnicode = href.unicodeScalars.filter({ CharacterSet.decimalDigits.contains($0) })
            let eventCode = String(eventCodeUnicode).requiredNumber()
            
            let name = text
            
            let eventElement = link.parent().requiredIfValidHTML()
            let eventSiblings = eventElement.siblingElements().array()
            
            let statusElement = eventSiblings[1]
            let status = try statusElement.text()
            
            let appliedElement = eventSiblings[2]
            let applied = try appliedElement.text().requiredNumber()
            
            let confirmedElement = eventSiblings[3]
            let confirmed = try confirmedElement.text().requiredNumber()
            
            let cancan = eventSiblings.reversed()[1].children().first().requiredIfValidHTML()
            
            let canConfirmElement = cancan.children().last().requiredIfValidHTML()
                .children().first().requiredIfValidHTML()
            let canConfirmClass = try canConfirmElement.attr("class")
            
            var canConfirm: Bool
            if canConfirmClass.hasSuffix("danger") {
                canConfirm = false
            } else {
                canConfirm = true
            }
            
            let eventHighlight = SofarEventHighlight(code: eventCode, name: name, status: status, applied: applied, confirmed: confirmed, canConfirm: canConfirm)
            return eventHighlight
        } else {
            return nil
        }
    }
    
    public static func sofarEvents(from htmlDocument: Document) throws -> [SofarEventHighlight] {
        let links = try htmlDocument.select("a")
        return try links.compactMap(sofarEvent(from:))
    }
    
}

extension Collection where Element == SofarEventHighlight {
    
    public func relevant() -> [SofarEventHighlight] {
        return self.filter({ $0.canConfirm })
    }
    
}
