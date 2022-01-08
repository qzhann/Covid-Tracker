//
//  ContentView.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/4/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CountyTrendView(county: .cupertino!, statisticType: .avarageCases)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
