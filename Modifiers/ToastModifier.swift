//
//  ToastModifier.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/30/22.
//

import Foundation
import SwiftUI
import AlertToast

struct ToastModifier: ViewModifier {
    @ObservedObject var logManager: LogManager
    func body(content: Content) -> some View {
        content
            .toast(isPresenting: $logManager.isPresented, duration: 2.0, tapToDismiss: true) {
                
                switch logManager.toastItem.type {
                    case .success:
                    return AlertToast(displayMode: .alert, type: .complete(.accentColor), title: logManager.toastItem.title, subTitle: logManager.toastItem.message)
                    case .error:
                    return AlertToast(displayMode: .banner(.pop), type: .error(Color(.systemRed)), title: logManager.toastItem.title, subTitle: logManager.toastItem.message)
                    case .info:
                    return AlertToast(displayMode: .banner(.pop), type: .systemImage("exclamationmark.circle.fill", Color(.systemBlue)), title: logManager.toastItem.title, subTitle: logManager.toastItem.message)
                    case .warning:
                    return AlertToast(displayMode: .hud, type: .systemImage("exclamationmark.triangle.fill", Color(.systemYellow)), title: logManager.toastItem.title, subTitle: logManager.toastItem.message)
                    }
            }
        }
}
