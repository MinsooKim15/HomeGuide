//
//  Grid.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/07/01.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item:Identifiable, ItemView : View{
    private var items: [Item]
    private var viewForItem: (Item)-> ItemView
    var columnCount: Int
    // @escaping은 지금 들어온 함수가 지금 init에서 안 쓰이고, 나중에 쓰일 거에요. 라는 말임.
    init(items: [Item], columnCount :Int ,viewForItem: @escaping (Item)-> ItemView){
        self.items = items
        self.viewForItem = viewForItem
        self.columnCount = columnCount
    }
    var body: some View {
        GeometryReader {geometry in
            self.body(for: GridLayout(itemCount: self.items.count,columnPoint:self.columnCount, in: geometry.size))
        }
    }
    private func body(for layout: GridLayout) -> some View{
        ForEach(items){item in
            self.body(for:item, in:layout)
        }
    }
    private func body(for item: Item, in layout: GridLayout) -> some View{
        let index = items.firstIndex(matching: item)
                return viewForItem(item)
                    .frame(width: layout.itemSize.width, height:layout.itemSize.height)
                    .position(layout.location(ofItemAt:index!))
    }
}
struct GridLayout {
    private(set) var size: CGSize
    private(set) var rowCount: Int = 0
    private(set) var columnCount: Int = 0
    
    init(itemCount: Int, columnPoint:Int, nearAspectRatio desiredAspectRatio: Double = 1, in size: CGSize) {
        self.size = size
        // if our size is zero width or height or the itemCount is not > 0
        // then we have no work to do (because our rowCount & columnCount will be zero)
        guard size.width != 0, size.height != 0, itemCount > 0 else { return }
        // find the bestLayout
        // i.e., one which results in cells whose aspectRatio
        // has the smallestVariance from desiredAspectRatio
        // not necessarily most optimal code to do this, but easy to follow (hopefully)
//        var bestLayout: (rowCount: Int, columnCount: Int) = (1, itemCount)
//        var smallestVariance: Double?
//        let sizeAspectRatio = abs(Double(size.width/size.height))
//        for rows in 1...itemCount {
//            let columns = (itemCount / rows) + (itemCount % rows > 0 ? 1 : 0)
//            if (rows - 1) * columns < itemCount {
//                let itemAspectRatio = sizeAspectRatio * (Double(rows)/Double(columns))
//                let variance = abs(itemAspectRatio - desiredAspectRatio)
//                if smallestVariance == nil || variance < smallestVariance! {
//                    smallestVariance = variance
//                    bestLayout = (rowCount: rows, columnCount: columns)
//                }
//            }
//        }
        //아래 주석은 row가 한 줄 일때 전체 칼럼 개수를 아이템 개수와 맞추는 값
//        var columnPoint_ = columnPoint
//        if itemCount < columnPoint{
//            columnPoint_ = itemCount
//        }

        let bestLayout:(rowCount: Int, columnCount: Int) = (Int(ceil(Double(itemCount)/Double(columnPoint))), columnPoint)
        rowCount = bestLayout.rowCount
        columnCount = bestLayout.columnCount
    }
    var itemSize: CGSize {
        if rowCount == 0 || columnCount == 0 {
            return CGSize.zero
        } else {
            return CGSize(
                width: size.width / CGFloat(columnCount),
                height: size.height / CGFloat(rowCount)
            )
        }
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero
        } else {
            return CGPoint(
                x: (CGFloat(index % columnCount) + 0.5) * itemSize.width,
                y: (CGFloat(index / columnCount) + 0.5) * itemSize.height
            )
        }
    }
}

