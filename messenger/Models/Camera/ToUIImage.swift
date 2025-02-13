//
//  ToUIImage.swift
//  messenger
//
//  Created by NGUELE Steve  on 12/02/2025.
//

import Foundation
import SwiftUI

extension Image {
    @MainActor func toUIImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }
}
