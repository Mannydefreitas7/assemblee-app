//
//  Extension+View.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/30/22.
//

import Foundation
import SwiftUI
import Combine

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    
    func getSafeArea() -> UIEdgeInsets {
        let null = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return null
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return null
        }
        return safeArea
    }
    func toastAlert(logManager: LogManager) -> some View {
        modifier(ToastModifier(logManager: logManager))
    }
    
    func addScheduleSheet(isPresented: Binding<Bool>) -> some View {
        modifier(CalendarModifier(isPresented: isPresented))
    }

}
