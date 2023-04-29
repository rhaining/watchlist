//
//  AnimatedGradientView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 4/29/23.
//

import SwiftUI

//https://www.appcoda.com/animate-gradient-swiftui/

struct AnimatableGradientModifier: AnimatableModifier {
    let fromGradient: Gradient
    let toGradient: Gradient
    var progress: CGFloat = 0.0
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        var gradientColors = [Color]()
        
        for i in 0..<fromGradient.stops.count {
            let fromColor = UIColor(fromGradient.stops[i].color)
            let toColor = UIColor(toGradient.stops[i].color)
            
            gradientColors.append(colorMixer(fromColor: fromColor, toColor: toColor, progress: progress))
        }
        
        return LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    func colorMixer(fromColor: UIColor, toColor: UIColor, progress: CGFloat) -> Color {
        guard let fromColor = fromColor.cgColor.components else { return Color(fromColor) }
        guard let toColor = toColor.cgColor.components else { return Color(toColor) }
        
        let red = fromColor[0] + (toColor[0] - fromColor[0]) * progress
        let green = fromColor[1] + (toColor[1] - fromColor[1]) * progress
        let blue = fromColor[2] + (toColor[2] - fromColor[2]) * progress
        
        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
}

extension View {
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
}

extension Color {
    private static func color(red: Int, green: Int, blue: Int) -> Color {
        return Color(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0)
    }
    
    static let daytime = color(red: 164, green: 221, blue: 250)
    static let nighttime = color(red: 19, green: 24, blue: 98)
    
    static let jacquiCobaltBlue = color(red: 0, green: 71, blue: 171)
    static let cesarMagenta = color(red: 255, green: 0, blue: 255)
    static let clintLilac = color(red: 200, green: 162, blue: 200)
    static let clintRoyal = color(red: 65, green: 105, blue: 225)
    static let melissaMustard = color(red: 255, green: 219, blue: 88)
    static let melissaDaffodil = color(red: 251, green: 232, blue: 112)
    static let adamPurple = color(red: 102, green: 51, blue: 153)
    static let timFuschia = cesarMagenta
    static let meganDark = color(red: 44, green: 4, blue: 28)
    static let janeNewLeafGreen = color(red: 154, green: 211, blue: 117)
    static let janeMMTan = color(red: 166, green: 124, blue: 82)
    static let janeFrenchBlue = color(red: 49, green: 140, blue: 231)
    static let janeCornflowerBlue = color(red: 100, green: 149, blue: 237)
    static let janeAshesOfRoses = color(red: 184, green: 142, blue: 144)
    static let janeDoveGrey = color(red: 191, green: 196, blue: 192)
    static let janeButtercupYellow = color(red: 249, green: 246, blue: 141)
    static let janeDustyLavender = color(red: 171, green: 144, blue: 153)
    static let jesseBlurple = color(red: 114, green: 137, blue: 218)
    static let alexIcy1970sOldsmobileBlue = color(red: 173, green: 201, blue: 224)
    static let timCookiPhonePurple = color(red: 235, green: 223, blue: 255)
    static let doverNorwayAqua = color(red: 86, green: 160, blue: 167)
    
    static func random() -> Color {
        return [daytime, nighttime, jacquiCobaltBlue, cesarMagenta, clintLilac, clintRoyal, melissaMustard, melissaDaffodil, adamPurple, timFuschia, meganDark, janeNewLeafGreen, janeMMTan, janeFrenchBlue, janeCornflowerBlue, janeAshesOfRoses, janeDoveGrey, janeButtercupYellow, janeDustyLavender, jesseBlurple, alexIcy1970sOldsmobileBlue, timCookiPhonePurple, doverNorwayAqua].randomElement()!
    }
}

struct AnimatedGradientView: View {
    @State private var progress: CGFloat = 0
    let gradient1 = Gradient(colors: [.random(), .random()])
    let gradient2 = Gradient(colors: [.random(), .random()])
    
    var body: some View {
        
        Rectangle()
            .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.linear(duration: 2.0)) {
                    self.progress = 1.0
                }
            }
    }
}
struct AnimatedGradientView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedGradientView()
    }
}
