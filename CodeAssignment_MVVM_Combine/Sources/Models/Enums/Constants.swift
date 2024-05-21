//
//  Constants.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/17.
//

import Foundation
import UIKit

enum Constants {
    /// collectionViewCellで使うleftPadding
    static let leftPadding: CGFloat = 20
    /// collectionViewCellで使うRightPadding
    static let rightPadding: CGFloat = 35
    /// 該当リポジトリをお気に入りした数値を短縮表示する基準
    static let numberFormatThreshold: Int = 10000
    /// starsに関するString型の説明文(スペース入り)
    static let starsExplainString: String = " stars"
    /// watchersに関するString型の説明文
    static let watchersExplainString: String = " watchers"
    /// forksに関するString型の説明文
    static let forksExplainString: String = " forks"
    /// openIssuesに関するString型の説明文
    static let openIssuesExplainString: String = " issues"
    /// DetailViewControllerで表すLanguageColorViewのheight サイズ
    static let colorViewHeightSize: CGFloat = 20
}
