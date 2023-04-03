//
//  CustomAppearance.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 4/2/23.
//

import SwiftUI

struct CustomAppearance {
    
    static func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        // Apply a red background.
        customNavBarAppearance.configureWithTransparentBackground()
        customNavBarAppearance.backgroundColor = .systemRed
        
        
        // Apply white colored normal and large titles.
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if let largeFont = UIFont(name: "Optima-ExtraBlack", size: 30),
           let regularFont = UIFont(name: "Optima-ExtraBlack", size: 24),
           let buttonFont = UIFont(name: "Optima-ExtraBlack", size: 14) {
            customNavBarAppearance.titleTextAttributes[.font] = regularFont
            customNavBarAppearance.largeTitleTextAttributes[.font] = largeFont
            
            barButtonItemAppearance.normal.titleTextAttributes[.font] = buttonFont
            barButtonItemAppearance.disabled.titleTextAttributes[.font] = buttonFont
            barButtonItemAppearance.highlighted.titleTextAttributes[.font] = buttonFont
            barButtonItemAppearance.focused.titleTextAttributes[.font] = buttonFont
        }

        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance

        return customNavBarAppearance
    }
    
    static func customTabBarAppearance() -> UITabBarAppearance {
        let customTabBarAppearance = UITabBarAppearance()
        
        customTabBarAppearance.configureWithTransparentBackground()
        customTabBarAppearance.backgroundColor = .systemRed

        let barButtonItemAppearance = UITabBarItemAppearance(style: .stacked)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        

//        if let regularFont = UIFont(name: "HoeflerText-Regular", size: 12) {
//            barButtonItemAppearance.normal.titleTextAttributes[.font] = regularFont
//            barButtonItemAppearance.disabled.titleTextAttributes[.font] = regularFont
//            barButtonItemAppearance.selected.titleTextAttributes[.font] = regularFont
//            barButtonItemAppearance.focused.titleTextAttributes[.font] = regularFont
//        }
        customTabBarAppearance.inlineLayoutAppearance = barButtonItemAppearance
        customTabBarAppearance.compactInlineLayoutAppearance = barButtonItemAppearance
        customTabBarAppearance.stackedLayoutAppearance = barButtonItemAppearance
        

        return customTabBarAppearance
    }
    
    static func setup() {
        
        let newNavBarAppearance = customNavBarAppearance()
        
        let appearance = UINavigationBar.appearance()
        appearance.scrollEdgeAppearance = newNavBarAppearance
        appearance.compactAppearance = newNavBarAppearance
        appearance.standardAppearance = newNavBarAppearance
        appearance.compactScrollEdgeAppearance = newNavBarAppearance
        
        
        let newTabBarAppearance = customTabBarAppearance()
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.scrollEdgeAppearance = newTabBarAppearance
        tabBarAppearance.standardAppearance = newTabBarAppearance
        

    }
}
