import SwiftUI


struct ContentView: View {
    @StateObject var api = ClientApi()
    var body: some View {
        // loading state
        if self.api.loading {
            ProgressView()
        }
        
        // error state
        // error message to display
        else if self.api.error != nil {
            Text(self.api.error ?? "").font(.body)
            Button(action: {
                self.api.error = nil
            }) {
                Text("OK")
            }
        }
        
        // main View layout
        else {
            WidgetsView(api: self.api).navigationTitle("WristHome")
        }
    }
}
