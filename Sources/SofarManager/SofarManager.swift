//
// SofarManager.swift
// SofarKit
//

import Foundation
import SofarKit
import Light
import SwiftSoup

extension APIPath {
    
    public static func path(forCity city: String) -> APIPath {
        return "cities" + APIPath(rawValue: city)
    }
    
    public static let manage: APIPath = "manage"
    public static let guestlist: APIPath = "guestlist"
    public static let events: APIPath = "events"
    
}

public enum SofarSounds {
    
    public static let baseURL = URL(string: "https://www.sofarsounds.com/")!
    
    public static func setCookies(sessionID: String, city: String) {
        let sofarCookie = HTTPCookie(properties: [
            .name : "_session_id",
            .value : sessionID,
            .domain : "www.sofarsounds.com",
            .path : "/",
            ]).required(because: "Cookie should be valid")
        let path: APIPath = .path(forCity: city) + .manage
        let sofarSoundsManageURL = SofarSounds.baseURL.appendingPath(path)
        HTTPCookieStorage.shared.setCookies([sofarCookie], for: sofarSoundsManageURL, mainDocumentURL: nil)
    }

}

extension ReadOnlyStorageProtocol where Value == String {
    
    public func mapHTMLDocument() -> ReadOnlyStorage<Key, Document> {
        return mapValues(SwiftSoup.parse(_:))
    }
    
}

public class SofarManager {
    
    public let webAPI: WebAPI
    public let city: String
    public let sessionID: String
    
    public let baseStorage: ReadOnlyStorage<APIPath, Data>
    
    public init(webAPI: WebAPI, city: String, cookieSessionID: String, setCookies: Bool = true) {
        self.webAPI = webAPI
        self.city = city
        self.sessionID = cookieSessionID
        if setCookies {
            SofarSounds.setCookies(sessionID: cookieSessionID, city: city)
        }
        self.baseStorage = self.webAPI.baseURL(SofarSounds.baseURL)
    }
    
    public var reportHTML: ReadOnlyStorage<Void, Document> {
        return baseStorage
            .singleKey(.path(forCity: city) + .manage)
            .mapString()
            .mapHTMLDocument()
    }
    
    public var report: ReadOnlyStorage<Void, [SofarEventHighlight]> {
        return reportHTML
            .mapValues(SofarEventHighlight.sofarEvents(from:))
    }
    
    public typealias EventCode = Int
    
    public var eventsHTML: ReadOnlyStorage<EventCode, Document> {
        return baseStorage
            .mapKeys(to: EventCode.self, { code in .events + .init(rawValue: code.description) + .manage })
            .mapString()
            .mapHTMLDocument()
    }
    
    public func event(withCode code: EventCode) -> ReadOnlyStorage<Void, SofarEvent> {
        return eventsHTML
            .singleKey(code)
            .mapValues({ try SofarEvent.event(from: $0, eventID: code) })
    }
    
}
