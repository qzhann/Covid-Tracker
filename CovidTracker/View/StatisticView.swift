//
//  StatisticView.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import SwiftUI
import WidgetKit

struct StatisticView: View {
    var number: Double
    var change: Double?
    var risk: RiskLevel
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Spacer(minLength: 0)
            
            VStack(alignment: .trailing) {
                HStack(alignment: .lastTextBaseline) {
                    
                    // primary number
                    Text(number.rounded(.towardZero), format: .number.notation(.compactName))
                        .font(.largeTitle.bold())
                        .foregroundColor(risk.color)
                        .fixedSize(horizontal: true, vertical: false)
                    
                    // change number
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Group {
                            if let change = change {
                                if change >= 0 {
                                    Image(systemName: "arrow.up")
                                } else {
                                    Image(systemName: "arrow.down")
                                }
                                
                                Text(abs(change), format: .number.notation(.compactName))
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }
                        .font(.footnote.weight(.bold))
                        
                    }
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                    
                }
                
            }
            
        }
    }
}


struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(number: 23500, change: 300, risk: .safe)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
