import Rainbow
import Foundation
import SwiftSoup

extension SofarEvent {
    
    static public func number(in document: Document, select query: String) throws -> Int {
        let element = try document.select(query).first().requiredIfValidHTML()
        return try element.text().requiredNumber()
    }
    
    static public func number(in children: [Element], index: Int) throws -> Int {
        let child = children[index]
        let deeper = child.children().first().requiredIfValidHTML()
        return try deeper.text().requiredNumber()
    }
    
    static public func eventName(in document: Document) throws -> String {
        let ahref = try document.select("a[href]")
        let eventNameElement = try ahref.first(where: { try $0.attr("href").hasPrefix("/cities/kharkiv/events/") }).requiredIfValidHTML()
        return try eventNameElement.text()
    }
    
    static public func checkStatus(from classAttr: String) -> SofarEvent.Check.Status {
        if classAttr.hasSuffix("check") {
            return .check
        } else if classAttr.hasSuffix("times") {
            return .times
        } else {
            preconditionFailure("Invalid check: \(classAttr)".red)
        }
    }
    
    static public func eventChecks(in document: Document) throws -> [SofarEvent.Check] {
        let fas = try document.select("i.fa.fa-check, i.fa.fa-times")
        return try fas.map({ (element) in
            let classAttr = try element.attr("class")
            let status = checkStatus(from: classAttr)
            let text = try element.parent()!.text().components(separatedBy: CharacterSet.whitespaces).joined(separator: " ")
            return SofarEvent.Check(text: text, status: status)
        })
    }
    
    static public func event(from document: Document, eventID: Int) throws -> SofarEvent {
        let goingCountElement = try document.select("span#going-count").first().requiredIfValidHTML()
        let going = try goingCountElement.text().requiredNumber()
        
        let vips = try number(in: document, select: "span#vip-count")
        let expected = try number(in: document, select: "span#expected-count")
        
        let parent = goingCountElement.parent().requiredIfValidHTML().parent().requiredIfValidHTML().parent().requiredIfValidHTML()
        
        var children = parent.children().array()
        children.removeFirst()
        
        let venueCap = try number(in: children, index: 0)
        let applied = try number(in: children, index: 1)
        let invited = try number(in: children, index: 2)
        let confirmedNo = try number(in: children, index: 3)
        let notConfirmed = try number(in: children, index: 4)
        let confirmedYes = try number(in: children, index: 5)
        let ticketsSold = try number(in: children, index: 6)
        
        let id = eventID
        let name = try eventName(in: document)
        
        let checks = try eventChecks(in: document)
        
        let event = SofarEvent(code: id, name: name, going: going, vips: vips, expected: expected, venueCap: venueCap, applied: applied, invited: invited, confirmedNo: confirmedNo, notConfirmed: notConfirmed, confirmedYes: confirmedYes, ticketsSold: ticketsSold, checks: checks)
        return event
    }
    
    static public func checkDescription(_ check: SofarEvent.Check) -> String {
        switch check.status {
        case .check:
            return "✅ \(check.text)"
        case .times:
            return "❌ \(check.text)"
        }
    }
    
    static public func eventDescription(_ event: SofarEvent, withChecks: Bool) -> String {
        let main = """
        
        \(event.name.bold)
        going: \(event.going)
        vips: \(event.vips)
        expected: \(event.expected.description.yellow)
        
        venue cap: \(event.venueCap.description.yellow)
        applied: \(event.applied)
        invited: \(event.invited)
        confirmed no: \(event.confirmedNo.description.red)
        not confirmed: \(event.notConfirmed.description.yellow)
        confirmed yes: \(event.confirmedYes.description.green)
        tickets sold: \(event.ticketsSold)
        
        """
        
        let checks = event.checks.map(checkDescription(_:)).joined(separator: "\n")
        
        if withChecks {
            return main + "\n" + checks
        } else {
            return main
        }
    }
    
}
