////
//  EntryManager.swift
//  HealthApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import SwiftEntryKit

class EntryManager {
    
    var vc: UIViewController
    
    init(viewController: UIViewController) {
        self.vc = viewController
    }
    
    /*
     
     Palette
     
 
    */
    

    /*
 
     em.toast.message(title: "this is the title", desc: "description here")
     em.toast.notify(title: "this is the title", desc: "description here")
     
     em.note.notify(title: "This is the title", desc: "Description")
     
     em.float.message(title: "this is the title", desc: "description here")
     
     em.alert.inquire(title: "this is the title", desc: "description here")
     
     em.form.inquire(title: "this is the title", desc: "description here")
 
    */
    
    func showNotificationMessage(attributes: EKAttributes, title: String, desc: String, textColor: UIColor, imageName: String? = nil, backgroundColor: UIColor? = nil, haptic: EKAttributes.NotificationHapticFeedback? = nil) {
        let title = EKProperty.LabelContent(text: title,
                                            style: EKProperty.LabelStyle(font: MainFont.medium.with(size: 16),
                                                                         color: textColor))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: MainFont.light.with(size: 14), color: textColor))
        
        var attributes = attributes
        if let color = backgroundColor {
            attributes.entryBackground = .color(color: color)
        }
        
        if let haptic = haptic {
            attributes.hapticFeedbackType = haptic
        }
        
        var image: EKProperty.ImageContent?
        if let imageName = imageName {
            image = .init(image: UIImage(named: imageName)!, size: CGSize(width: 35, height: 35))
        }
        
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    func showButtonBarMessage(attributes: EKAttributes, titleText: String, desc: String, imageName: String? = nil) {
        
        // Generate textual content
        let title = EKProperty.LabelContent(text: titleText, style: .init(font: MainFont.medium.with(size: 15), color: .black))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: MainFont.light.with(size: 13), color: .black))
        
        var image: EKProperty.ImageContent? = nil
        
        if let imgName = imageName {
            image = EKProperty.ImageContent(imageName: "ic_books", size: CGSize(width: 35, height: 35), contentMode: .scaleAspectFit)
        }
        
        var simpleMessage: EKSimpleMessage
        if image != nil {
            simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        } else {
            simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        }
        
        // Generate buttons content
        let buttonFont = MainFont.medium.with(size: 16)
        
        // Close button - Just dismiss entry when the button is tapped
        let closeButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color: EKColor.Gray.a800)
        let closeButtonLabel = EKProperty.LabelContent(text: "NOT NOW", style: closeButtonLabelStyle)
        let closeButton = EKProperty.ButtonContent(label: closeButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Gray.a800.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
        }
        
        // Ok Button - Make transition to a new entry when the button is tapped
        let okButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color: EKColor.Teal.a600)
        let okButtonLabel = EKProperty.LabelContent(text: "WHY NOT! LET ME HAVE IT NOW", style: okButtonLabelStyle)
        let okButton = EKProperty.ButtonContent(label: okButtonLabel,
                                                backgroundColor: .clear,
                                                highlightedBackgroundColor: EKColor.Teal.a600.withAlphaComponent(0.05)) { [unowned self] in
            var attributes = self.bottomFloat
            attributes.entryBackground = .color(color: EKColor.Teal.a600)
            attributes.entranceAnimation = .init(translate: .init(duration: 0.65, spring: .init(damping: 0.8, initialVelocity: 0)))
            let title = "Congratz!"
            let description = "Your book coupon is 5w1ft3ntr1k1t"
            self.showNotificationMessage(attributes: attributes, title: title, desc: description, textColor: .white)
        }
        let buttonsBarContent = EKProperty.ButtonBarContent(with: closeButton, okButton, separatorColor: EKColor.Gray.light, buttonHeight: 60, expandAnimatedly: true)
        
        // Generate the content
        let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, imagePosition: .left, buttonBarContent: buttonsBarContent)
        
        let contentView = EKAlertMessageView(with: alertMessage)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    func showAlertView(attributes: EKAttributes) {
        
        // Generate textual content
        let title = EKProperty.LabelContent(text: "Hopa!", style: .init(font: MainFont.medium.with(size: 15), color: .black, alignment: .center))
        let description = EKProperty.LabelContent(text: "This is a system-like alert, with several buttons. You can display even more buttons if you want. Click on one of them to dismiss it.", style: .init(font: MainFont.light.with(size: 13), color: .black, alignment: .center))
//        let image = EKProperty.ImageContent(imageName: "ic_apple", size: CGSize(width: 25, height: 25), contentMode: .scaleAspectFit)
        let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        
        // Generate buttons content
        let buttonFont = MainFont.medium.with(size: 16)
        
        // Close button
        let closeButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color: EKColor.Gray.a800)
        let closeButtonLabel = EKProperty.LabelContent(text: "NOT NOW", style: closeButtonLabelStyle)
        let closeButton = EKProperty.ButtonContent(label: closeButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Gray.a800.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
        }
        
        // Remind me later Button
        let laterButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color: EKColor.Teal.a600)
        let laterButtonLabel = EKProperty.LabelContent(text: "MAYBE LATER", style: laterButtonLabelStyle)
        let laterButton = EKProperty.ButtonContent(label: laterButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Teal.a600.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
        }
        
        // Ok Button
        let okButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color: EKColor.Teal.a600)
        let okButtonLabel = EKProperty.LabelContent(text: "SHOW ME", style: okButtonLabelStyle)
        let okButton = EKProperty.ButtonContent(label: okButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Teal.a600.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
        }
        
        // Generate the content
        let buttonsBarContent = EKProperty.ButtonBarContent(with: okButton, laterButton, closeButton, separatorColor: EKColor.Gray.light, expandAnimatedly: true)
        
        let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, buttonBarContent: buttonsBarContent)
        
        // Setup the view itself
        let contentView = EKAlertMessageView(with: alertMessage)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    func showProcessingNote(attributes: EKAttributes, title: String) {
        let text = title
        let style = EKProperty.LabelStyle(font: MainFont.light.with(size: 14), color: .white, alignment: .center)
        let labelContent = EKProperty.LabelContent(text: text, style: style)
        
        let contentView = EKProcessingNoteMessageView(with: labelContent, activityIndicator: .white)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    func showProcessingNote(title: String, completion: ()->()) {
        var attributes = EKAttributes.topNote
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = EKAttributes.DisplayDuration.infinity
        attributes.popBehavior = .animated(animation: .translation)
        attributes.entryBackground = .color(color: EKColor.Mooch.lightBlue)
        attributes.statusBar = .light
        
        let text = title
        let style = EKProperty.LabelStyle(font: MainFont.light.with(size: 14), color: .white, alignment: .center)
        let labelContent = EKProperty.LabelContent(text: text, style: style)
        
        let contentView = EKProcessingNoteMessageView(with: labelContent, activityIndicator: .white)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
        
        completion()
    }
    
    func dismissEntry() {
        SwiftEntryKit.dismiss()
    }
    
    // MARK: - Attributes
    var topToast: EKAttributes = {
        var attr = EKAttributes.topToast
        attr.hapticFeedbackType = .success
        attr.entryBackground = .color(color: EKColor.Mooch.lightBlue)
        attr.entranceAnimation = .init(translate: .init(duration: 0.3), scale: .init(from: 1.07, to: 1, duration: 0.3))
        attr.exitAnimation = .init(translate: .init(duration: 0.3))
        attr.statusBar = .hidden
        attr.scroll = .edgeCrossingDisabled(swipeable: false)
        
        return attr
    }()
    
    var bottomToast: EKAttributes = {
        var attributes = EKAttributes.bottomToast
        attributes.hapticFeedbackType = .success
        attributes.entryBackground = .color(color: EKColor.Mooch.lightBlue)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.3),
                                             scale: .init(from: 1.07, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(translate: .init(duration: 0.3))
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.statusBar = .dark
        
        return attributes
    }()
    
    var topFloat: EKAttributes = {
       var attributes = EKAttributes.topFloat
        attributes.hapticFeedbackType = .success
        attributes.entryBackground = .color(color: EKColor.Mooch.lightBlue)
//            .gradient(gradient: .init(colors: [.amber, .pinky], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        return attributes
    }()
    
    var bottomFloat: EKAttributes = {
        var attributes: EKAttributes = .bottomFloat
        
        attributes = .bottomFloat
        attributes.hapticFeedbackType = .success
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor.BlueGradient.dark, EKColor.BlueGradient.light], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.entryInteraction = .delayExit(by: 3)
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.statusBar = .dark
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        return attributes
    }()
    
    var topAlert: EKAttributes = {
        var attributes: EKAttributes = .topFloat
        attributes = .topFloat
        attributes.hapticFeedbackType = .success
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.screenBackground = .color(color: .dimmedLightBackground)
        attributes.entryBackground = .color(color: .white)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.7, spring: .init(damping: 1, initialVelocity: 0)), scale: .init(from: 0.6, to: 1, duration: 0.7), fade: .init(from: 0.8, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(scale: .init(from: 1, to: 0.7, duration: 0.3), fade: .init(from: 1, to: 0, duration: 0.3))
        attributes.displayDuration = .infinity
        attributes.border = .value(color: .black, width: 0.5)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 5))
        attributes.statusBar = .dark
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        return attributes
    }()
    
    var centerAlert: EKAttributes = {
        var attributes = EKAttributes.centerFloat
        attributes = .centerFloat
        attributes.windowLevel = .alerts
        attributes.hapticFeedbackType = .success
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.screenBackground = .color(color: .dimmedLightBackground)
        attributes.entryBackground = .color(color: .white)
        attributes.entranceAnimation = .init(scale: .init(from: 0.9, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)), fade: .init(from: 0, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(fade: .init(from: 1, to: 0, duration: 0.2))
        attributes.displayDuration = .infinity
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 5))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        return attributes
    }()
    
    var topNote: EKAttributes = {
        var attributes = EKAttributes.topNote
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = EKAttributes.DisplayDuration(exactly: 4)!
        attributes.popBehavior = .animated(animation: .translation)
        attributes.entryBackground = .color(color: .blue)
        attributes.statusBar = .light
        
        return attributes
    }()
    
}
