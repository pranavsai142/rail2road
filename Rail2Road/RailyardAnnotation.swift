//
//  RailyardAnnotation.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/5/22.
//

import SwiftUI

struct RailyardAnnotation: View {
    var railyard: Railyard
    var body: some View {
        HStack(spacing: 0) {
            Text(railyard.waittimeToMinutes())
                .foregroundColor(Color.white)
                .frame(width: 42, height: 60)
                .background(Color.green.opacity(0.9))
            Text(railyard.name)
                .foregroundColor(Color.white)
                .frame(width: 100, height: 60)
                .background(Color.black.opacity(0.9))
        }
            .offset(y: -4)
            .clipShape(Marker())
    }
}

struct Marker: Shape {
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath()
        let curveXDelta = (rect.maxX - rect.midX)/4
        let curveYDelta = (rect.maxY - rect.midY)/4
        path.move(to: CGPoint(x: rect.minX + curveXDelta, y: rect.maxY - curveYDelta))
        path.addLine(to: CGPoint(x: rect.midX - curveXDelta, y: rect.maxY - curveYDelta))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + curveXDelta, y: rect.maxY - curveYDelta))
        path.addLine(to: CGPoint(x: rect.maxX - curveXDelta, y: rect.maxY - curveYDelta))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - (curveYDelta * 2)), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY - curveYDelta))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + curveYDelta))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - curveXDelta, y: rect.minY), controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + curveXDelta, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY + curveYDelta), controlPoint: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - (curveYDelta * 2)))
        path.addQuadCurve(to: CGPoint(x: rect.minX + curveXDelta, y: rect.maxY - curveYDelta), controlPoint: CGPoint(x: rect.minX, y: rect.maxY - curveYDelta))
        
        return Path(path.cgPath)
    }
}
