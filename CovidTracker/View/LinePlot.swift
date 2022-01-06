//
//  LinePlot.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import SwiftUI
import WidgetKit

struct LinePlot: View {
    var strokeWidth = 3.0
    var color: Color
    var normalizedValues: [Double]
    
    init(values: [Double], color: Color) {
        self.color = color
        guard !values.isEmpty else {
            self.normalizedValues = []
            return
        }
        let range = values.min()!...values.max()!
        self.normalizedValues = values.map { 1 - $0.normalized(in: range) }
    }
    
    var body: some View {
        ZStack {
            // lines
            LinePlotPath(normalizedValues: normalizedValues)
                .stroke(color, lineWidth: strokeWidth)
            
            LinePlotPath(normalizedValues: normalizedValues, closedFromBelow: true)
                .fill(LinearGradient(colors: [color, color.opacity(0)], startPoint: .top, endPoint: .bottom))
        }
        
    }
    
}

struct LinePlotPath: Shape {
    var normalizedValues: [Double]
    var closedFromBelow: Bool = false
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            // move to start
            if closedFromBelow {
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0, y: normalizedValues[0] * height))
            } else {
                path.move(to: CGPoint(x: 0, y: normalizedValues[0] * height))
            }
            
            // add line to every new point
            for index in normalizedValues.indices {
                let normalizedX = Double(index) / Double(normalizedValues.count - 1)
                path.addLine(to: CGPoint(x: normalizedX * width, y: normalizedValues[index] * height))
            }
            
            // move to end
            if closedFromBelow {
                path.addLine(to: CGPoint(x: width, y: height))
                path.closeSubpath()
            }
        }
    }
}

struct LinePlot_Previews: PreviewProvider {
    static var previews: some View {
        LinePlot(values: [0.5, 0.2, 0.4, 0.3], color: .red)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
