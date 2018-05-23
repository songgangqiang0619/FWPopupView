//
//  FWDemoViewController.swift
//  FWPopupView
//
//  Created by xfg on 2018/3/26.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit

class FWDemoViewController: UITableViewController {
    
    var alertImage: FWAlertView!
    var menuView: FWMenuView!
    
    
    /// 注意：这边不同的示例可能还附加演示了一些特性（比如：遮罩层是否能够点击、遮罩层的背景颜色等等），有用到时可以参考
    var titleArray = ["Alert - 单个按钮", "Alert - 两个按钮", "Alert - 两个按钮（修改参数）", "Alert - 多个按钮", "Alert - 带输入框", "Alert - 带自定义视图", "Sheet - 少量Item", "Sheet - 大量Item", "Date - 自定义日期选择", "Menu - 自定义菜单"]
    
    let block: FWPopupItemClickedBlock = { (popupView, index) in
        print("AlertView：点击了第\(index)个按钮")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "FWPopupView"
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        // 设置弹窗外部可点击
        // FWPopupWindow.sharedInstance.touchWildToHide = true
    }
}

extension FWDemoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let alertView = FWAlertView.alert(title: "标题", detail: "描述描述描述描述") { (popupView, index) in
                print("点击了确定")
            }
            alertView.show()
            break
        case 1:
            let alertView = FWAlertView.alert(title: "标题", detail: "描述描述描述描述描述描述描述描述描述描述", confirmBlock: { (popupView, index) in
                print("点击了确定")
            }, cancelBlock: { (popupView, index) in
                print("点击了取消")
            })
            // 设置AlertView外部背景色
            alertView.attachedView?.fwMaskViewColor = UIColor(white: 0, alpha: 0.2)
            alertView.show { (popupView, isShow) in
                if !isShow {
                    // 隐藏时把背景色改回来（这个非必要，我这边只是一个演示）
                    alertView.attachedView?.fwMaskViewColor = UIColor(white: 0, alpha: 0.5)
                }
            }
            break
        case 2:
            // 注意：此时“确定”按钮是不让按钮自己隐藏的
            let items = [FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemTitleColor: kPV_RGBA(r: 141, g: 151, b: 163, a: 1.0), itemBackgroundColor: nil, itemClickedBlock: block),
                         FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: true, itemTitleColor: kPV_RGBA(r: 29, g: 150, b: 227, a: 1.0), itemBackgroundColor: nil, itemClickedBlock: block)]
            
            // 主要演示修改参数
            let vProperty = FWAlertViewProperty()
            vProperty.alertViewWidth = max(UIScreen.main.bounds.width * 0.65, 275)
            vProperty.titleFontSize = 17.0
            vProperty.detailFontSize = 14.0
            vProperty.detailColor = kPV_RGBA(r: 141, g: 151, b: 163, a: 1.0)
            vProperty.buttonFontSize = 14.0
            vProperty.maskViewColor = UIColor(white: 0, alpha: 0.8)
            vProperty.touchWildToHide = "1"
            // 还有很多参数可设置...
            
            let alertView = FWAlertView.alert(title: "标题", detail: "描述描述描述描述描述描述描述描述描述描述", inputPlaceholder: nil, keyboardType: .default, customView: nil, items: items, vProperty: vProperty)
            
            alertView.show()
            break
        case 3:
            let items = [FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemClickedBlock: block),
                         FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: true, itemClickedBlock: block),
                         FWPopupItem(title: "其他", itemType: .normal, isCancel: false, canAutoHide: true, itemClickedBlock: block)]
            
            let alertView = FWAlertView.alert(title: "标题", detail: "描述描述描述描述描述描述描述描述描述描述", inputPlaceholder: nil, keyboardType: .default, customView: nil, items: items)
            alertView.show()
            break
        case 4:
            let items = [FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemClickedBlock: block),
                         FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: true, itemClickedBlock: block)]
            
            let alertView = FWAlertView.alert(title: "标题", detail: "带输入框", inputPlaceholder: "请输入...", keyboardType: .default, customView: nil, items: items)
            alertView.show()
            break
        case 5:
            if self.alertImage == nil {
                
                let block2: FWPopupItemClickedBlock = { [weak self] (popupView, index) in
                    
                    if index == 1 {
                        // 这边演示了如何手动去调用隐藏
                        self?.alertImage.hide()
                    }
                }
                
                // 注意：此时“确定”按钮是不让按钮自己隐藏的
                let items = [FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemClickedBlock: block2),
                             FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: false, itemClickedBlock: block2)]
                // 注意：添加自定义的视图，需要设置确定的Frame值
                let customImageView = UIImageView(image: UIImage(named: "audio_bgm_4"))
                
                let vProperty = FWAlertViewProperty()
                vProperty.touchWildToHide = "1"
                
                self.alertImage = FWAlertView.alert(title: "标题", detail: "带自定义视图", inputPlaceholder: nil, keyboardType: .default, customView: customImageView, items: items, vProperty: vProperty)
            }
            
            self.alertImage.show()
            break
        case 6:
            let items = ["Sheet0", "Sheet1", "Sheet2", "Sheet3"]
            
            let sheetView = FWSheetView.sheet(title: "标题", itemTitles: items, itemBlock: { (popupView, index) in
                print("Sheet：点击了第\(index)个按钮")
            }, cancenlBlock: {
                print("点击了取消")
            })
            sheetView.show()
            break
        case 7:
            let items = ["Sheet0", "Sheet1", "Sheet2", "Sheet3", "Sheet4", "Sheet5", "Sheet6", "Sheet7", "Sheet8", "Sheet9", "Sheet10", "Sheet11", "Sheet12", "Sheet13", "Sheet14"]
            
            let sheetView = FWSheetView.sheet(title: "标题", itemTitles: items, itemBlock: { (popupView, index) in
                print("Sheet：点击了第\(index)个按钮")
            }, cancenlBlock: {
                print("点击了取消")
            })
            sheetView.show()
            break
        case 8:
            let dateView = FWDateView.date(confirmBlock: { (datePicker) in
                print("点击了 FWDateView 的确定")
            }, cancelBlock: {
                print("点击了 FWDateView 的取消")
            })
            dateView.show()
            break
        case 9:
            if self.menuView == nil {
                let titles = ["发起多人聊天", "加好友", "扫一扫", "面对面快传", "付款"]
                let images = [UIImage(named: "right_menu_multichat"),
                              UIImage(named: "right_menu_addFri"),
                              UIImage(named: "right_menu_QR"),
                              UIImage(named: "right_menu_facetoface"),
                              UIImage(named: "right_menu_payMoney")]
                
                let vProperty = FWMenuViewProperty()
                vProperty.maskViewColor = UIColor.clear
                vProperty.touchWildToHide = "1"
                vProperty.popupCustomAlignment = .topCenter
                vProperty.popupViewEdgeInsets = UIEdgeInsetsMake(64, 0, 0, 0)
                //            vProperty.popupViewSize = CGSize(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height)
                vProperty.topBottomMargin = 0
                
                menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: images as? [UIImage], itemBlock: { (popupView, index) in
                    print("Menu：点击了第\(index)个按钮")
                }, property: vProperty)
//                menuView.attachedView = self.view
            }
            
            menuView.show()
            break
            
        default:
            break
        }
    }
}
