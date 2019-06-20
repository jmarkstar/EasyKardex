//
//  Request.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Vapor
import Lingo

extension Request {
    
    public func localizedString(_ tag: String) -> String {
        
        let lingo: Lingo
        
        do {
            lingo = try self.make(Lingo.self)
        }catch {
            return ""
        }
        
        guard let language = self.http.headers.firstValue(name: .acceptLanguage) else {
            
            return lingo.localize(tag, locale: "en")//default `en`
        }
        
        return lingo.localize(tag, locale: language)
    }
}
