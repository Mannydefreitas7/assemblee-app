//
//  Extension.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import SwiftUI
import Combine

extension View {
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
}

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
}

extension ViewModifier {
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
}

extension View {
    
    /// Sets the text color for a navigation bar title.
       /// - Parameter color: Color the title should be
       ///
       /// Supports both regular and large titles.
       @available(iOS 14, *)
       func navigationBarTitleTextColor(_ color: Color) -> some View {
           let uiColor = UIColor(color)
       
           // Set appearance for both normal and large sizes.
           UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
           UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
       
           return self
       }
    
  func tabViewStyle(backgroundColor: Color? = nil,
                    itemColor: Color? = nil,
                    selectedItemColor: Color? = nil,
                    badgeColor: Color? = nil) -> some View {
    onAppear {
      let itemAppearance = UITabBarItemAppearance()
        
        if let uiItemColor = itemColor?.cgColor {
            itemAppearance.normal.iconColor = UIColor(cgColor: uiItemColor)
        itemAppearance.normal.titleTextAttributes = [
          .foregroundColor: uiItemColor
        ]
      }
      if let uiSelectedItemColor = selectedItemColor?.cgColor {
          itemAppearance.selected.iconColor = UIColor(cgColor:uiSelectedItemColor)
        itemAppearance.selected.titleTextAttributes = [
          .foregroundColor: uiSelectedItemColor
        ]
      }
      if let uiBadgeColor = badgeColor?.cgColor {
          itemAppearance.normal.badgeBackgroundColor = UIColor(cgColor:uiBadgeColor)
          itemAppearance.selected.badgeBackgroundColor = UIColor(cgColor:uiBadgeColor)
      }

      let appearance = UITabBarAppearance()
      if let uiBackgroundColor = backgroundColor?.cgColor {
          appearance.backgroundColor = UIColor(cgColor:uiBackgroundColor)
          
      }

      appearance.stackedLayoutAppearance = itemAppearance
      appearance.inlineLayoutAppearance = itemAppearance
      appearance.compactInlineLayoutAppearance = itemAppearance
      UITabBar.appearance().standardAppearance = appearance
        
      if #available(iOS 15.0, *) {
        UITabBar.appearance().scrollEdgeAppearance = appearance
      }
    }
  }
}


extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
    func asyncForEach(
         _ operation: (Element) async throws -> Void
     ) async rethrows {
         for element in self {
             try await operation(element)
         }
     }
    func concurrentForEach(
        _ operation: @escaping (Element) async -> Void
    ) async {
        // A task group automatically waits for all of its
        // sub-tasks to complete, while also performing those
        // tasks in parallel:
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    await operation(element)
                }
            }
        }
    }
}

enum AsyncError: Error {
    case finishedWithoutValue
}

extension Publisher {
  /// Executes an asyncronous call and returns its result to the downstream subscriber.
  ///
  /// - Parameter transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
  /// - Returns: A publisher that transforms elements from an upstream  publisher into a publisher of that element's type.
    ///
    
   @MainActor
  func `await`<T>(_ transform: @escaping (Output) async -> T) -> AnyPublisher<T, Failure> {
    flatMap { value -> Future<T, Failure> in
      Future { promise in
        Task {
          let result = await transform(value)
          promise(.success(result))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

extension UserDefaults {
    @objc var user: String {
        get {
            return string(forKey: "user") ?? ""
        }
        set {
            set(newValue, forKey: "user")
        }
    }
}
