//
//  Extensions.swift
//  Figsty
//
//  Created by Dmitriy Petrusevich on 1/13/20.
//  Copyright © 2020 Dmitriy Petrusevich. All rights reserved.
//

import Foundation

extension File {
    func findColor(styleID: String) -> Color? {
        let node = document.nodeWith(styleID: styleID)
        return node?.fills?.first?.fixedOpacityColor
    }

    func findFont(styleID: String) -> TypeStyle? {
        let node = document.nodeWith(styleID: styleID)
        return node?.style
    }
}

extension Node {
    func nodeWith(styleID id: String) -> Node? {
        if styles?.values.contains(id) == true {
            return self
        } else {
            var result: Node?
            for ch in children ?? [] {
                result = ch.nodeWith(styleID: id)
                if result != nil {
                    break
                }
            }
            return result
        }
    }
}

extension Paint {
    var fixedOpacityColor: Color? {
        guard let color = color, let opacity = opacity else {
            return self.color
        }
        return Color(r: color.r, g: color.g, b: color.b, a: color.a * opacity)
    }
}

extension Color {
    var androidHexColor: String {
        let r = Int(min(255, max(0, round(self.r * 255))))
        let g = Int(min(255, max(0, round(self.g * 255))))
        let b = Int(min(255, max(0, round(self.b * 255))))
        let a = Int(min(255, max(0, round(self.a * 255))))
        return String(format:"#%02X%02X%02X%02X", a, r, g, b)
    }

    var rgba255: String {
        let r = Int(min(255, max(0, round(self.r * 255))))
        let g = Int(min(255, max(0, round(self.g * 255))))
        let b = Int(min(255, max(0, round(self.b * 255))))
        let a = Int(min(255, max(0, round(self.a * 255))))
        return "\(r), \(g), \(b), \(a)"
    }

    var rgba: String {
        return "\(r), \(g), \(b), \(a)"
    }

    var uiColor: String {
        return "UIColor(cgColor: CGColor(colorSpace: CGColorSpace(name: CGColorSpace.extendedSRGB) ?? CGColorSpace(iccData: CGColorSpace.adobeRGB1998), components: [\(Float(r)), \(Float(g)), \(Float(b)), \(Float(a))]) ?? UIColor.red.cgColor)"
//        return "UIColor(red: \(Float(r)), green: \(Float(g)), blue: \(Float(b)), alpha: \(Float(a)))"
    }
}

extension TypeStyle {
    enum Weight: Int {
        case thin = 100 // Thin (Hairline)
        case extraLight = 200 // Extra Light (Ultra Light)
        case light = 300 // Light
        case normal = 400 // Normal (Regular)
        case medium = 500 // Medium
        case semiBold = 600 // Semi Bold (Demi Bold)
        case bold = 700 // Bold
        case extraBold = 800 // Extra Bold (Ultra Bold)
        case black = 900 // Black (Heavy)

        var iosName: String {
            switch self {
            case .thin: return "ultraLight"
            case .extraLight: return "thin"
            case .light: return "light"
            case .normal: return "regular"
            case .medium: return "medium"
            case .semiBold: return "semibold"
            case .bold: return "bold"
            case .extraBold: return "heavy"
            case .black: return "black"
            }
        }
    }

    var estimatedWeight: Weight {
        return Weight(rawValue: Int(fontWeight))!
    }

    var uiFontSystem: String {
        return "UIFont.systemFont(ofSize: \(fontSize), weight: .\(estimatedWeight.iosName))"
    }
}

// MARK: -

extension String {
    func absoluteFileURL(baseURL: URL) -> URL {
        if hasPrefix("./") {
            return baseURL.appendingPathComponent(String(self.dropFirst().dropFirst()))
        } else {
            return URL(fileURLWithPath: self)
        }
    }

    static let trimSet = CharacterSet.punctuationCharacters.union(.decimalDigits).union(.whitespacesAndNewlines)

    var escaped: String {
        let edited  = self + "S"
        return edited.trimmingCharacters(in: String.trimSet).dropLast().filter { $0.isLetter || $0.isNumber || $0 == "_" }
    }

    var capitalizedFirstLetter: String {
        guard self.isEmpty == false else { return self }
        return self.prefix(1).uppercased() + self.dropFirst()
    }

    var loweredFirstLetter: String {
        guard self.isEmpty == false else { return self }
        return self.prefix(1).lowercased() + self.dropFirst()
    }
}
