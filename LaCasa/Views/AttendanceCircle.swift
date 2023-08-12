//
//  AttendanceCircle.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 8/8/23.
//

import SwiftUI

struct AttendanceCircle: View {
    var status: AttendanceStatus
    
    var width: CGFloat = 65
    
    var body: some View {
        switch status {
        case .present:
            Image(systemName: "checkmark.circle.fill").resizable().scaledToFit().foregroundColor(.green).frame(width: width)
        case .late:
            Image(systemName: "exclamationmark.circle.fill").resizable().scaledToFit().foregroundColor(.yellow).frame(width: width)
        case .absent:
            Image(systemName: "x.circle.fill").resizable().foregroundColor(Color("LoginButtonColor")).frame(width: 65)
        case .none:
            Circle().fill(.gray).opacity(0.4).frame(width: 65)
        }
    }
}

struct AttendanceCircle_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceCircle(status: .present)
    }
}
