
import SwiftSoup
import Foundation

extension EventHighlight {
    
    public static func highlight(from link: Element) throws -> EventHighlight? {
        let href = try link.attr("href")
        if href.hasPrefix("/events/"), let text = try? link.text(), !text.isEmpty {
            
            //        print(href)
            //        print("Text:", (try? link.text()) ?? "none")
            //        dump(link.parent()!.siblingElements().map({ $0.description }))
            //        print("")
            
            let eventCodeUnicode = href.unicodeScalars.filter({ CharacterSet.decimalDigits.contains($0) })
            let eventCode = try String(eventCodeUnicode).requiredNumber()
            
            let name = text
            
            let eventElement = try link.parent().requiredIfValidHTML()
            let eventSiblings = eventElement.siblingElements().array()
            
            let statusElement = eventSiblings[1]
            let status = try statusElement.text()
            
            let appliedElement = eventSiblings[2]
            let applied = try appliedElement.text().requiredNumber()
            
            let confirmedElement = eventSiblings[3]
            let confirmed = try confirmedElement.text().requiredNumber()
            
            let cancan = try eventSiblings.reversed()[1].children().first().requiredIfValidHTML()
            
            let canConfirmElement = try cancan.children().last().requiredIfValidHTML()
                .children().first().requiredIfValidHTML()
            let canConfirmClass = try canConfirmElement.attr("class")
            
            var canConfirm: Bool
            if canConfirmClass.hasSuffix("danger") {
                canConfirm = false
            } else {
                canConfirm = true
            }
            
            let eventHighlight = EventHighlight(code: eventCode, name: name, status: status, applied: applied, confirmed: confirmed, canConfirm: canConfirm)
            return eventHighlight
        } else {
            return nil
        }
    }
    
    public static func highlights(from htmlDocument: Document) throws -> [EventHighlight] {
        let links = try htmlDocument.select("a")
        return try links.compactMap(highlight(from:))
    }
    
}

extension Collection where Element == EventHighlight {
    
    public func relevant() -> [EventHighlight] {
        return self.filter({ $0.canConfirm })
    }
    
}
