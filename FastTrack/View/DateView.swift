import SwiftUI

struct DateView: View {
    var date: Date

    var body: some View {
        VStack {
            Text(dayString)
                .font(.system(size: 50, weight: .bold, design: .default))
            
            Text(monthString)
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundColor(.gray)
        }
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
}

#Preview {
    DateView(date: Date())
}
