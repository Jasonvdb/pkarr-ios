//
//  ContentView.swift
//  Pkarr
//
//  Created by Jason van den Berg on 2024/02/22.
//

import SwiftUI

struct ContentView: View {
    @State private var publicKey: String = "pk:o88n76daox5y14mk77khke3aien8eufxierkok5ca1ombbm9nc8y"
    @State var record: String? = nil
    @State var isResolving = false
    @State var milliseconds: UInt64? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Text("Public Key:")
                TextField("Enter text", text: $publicKey)
                
                Button("Resolve") {
                    record = nil
                    milliseconds = nil
                    isResolving = true
                    let startTime = DispatchTime.now().uptimeNanoseconds
                    
                    Task {
                        let record = await resolve(publicKey: publicKey)
                        DispatchQueue.main.async {
                            self.record = record
                            isResolving = false
                            milliseconds = (DispatchTime.now().uptimeNanoseconds - startTime)/1000000
                        }
                    }
                }
                .disabled(isResolving)
                
                if isResolving {
                    ProgressView()
                }
                
                if let milliseconds {
                    Text("Resolved in \(milliseconds)ms")
                }
                
                if let record {
                    Text(record)
                        .font(.caption)
                }
            }
            .navigationTitle("Pkarr")
        }
    }
}

#Preview {
    ContentView()
}
