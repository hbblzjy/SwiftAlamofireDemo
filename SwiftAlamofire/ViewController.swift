//
//  ViewController.swift
//  SwiftAlamofire
//
//  Created by healthmanage on 16/11/28.
//  Copyright © 2016年 healthmanager. All rights reserved.
//

import UIKit
import Alamofire

//屏幕宽
let SCREEN_W = UIScreen.main.bounds.width
//屏幕高
let SCREEN_H = UIScreen.main.bounds.height

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //创建表格和数组
    var myTableView = UITableView();
    var dataArray = NSMutableArray();
    
    override func viewWillAppear(_ animated: Bool) {
        self.httpRequest();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white;
        self.title = "首页";
        
        dataArray = NSMutableArray.init()
        
        self.myTableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H), style: UITableViewStyle.plain);
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.rowHeight = 80;
        self.myTableView.tableHeaderView = UIView.init();
        self.myTableView.tableFooterView = UIView.init();
        self.view.addSubview(self.myTableView);
        //注册Cell
        self.myTableView.register(MyCellTableViewCell.self, forCellReuseIdentifier: "myCell");
        
    }
    //MARK:------------- UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray.count<=0 {
            return 1;
        }else{
            return dataArray.count;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.dataArray.count<=0 {
            let noCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "noCell");
            noCell.textLabel?.text = "暂无数据，但是可点击";
            noCell.selectionStyle = UITableViewCellSelectionStyle.none;
            return noCell;
        }
        else
        {
            let cell:MyCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! MyCellTableViewCell;
            
            cell.setDataDic(dataDic: dataArray[indexPath.row] as! NSDictionary);
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            return cell;
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneVC = OneViewController();
        self.navigationController?.pushViewController(oneVC, animated: true);
    }
    //MARK:-------------- 数据请求http
    func httpRequest() {
        let urlStr = "http://www.healthmanage.cn/android/hrsBabyAction_loadHrsBabyHealth.action?";
        let paramsDic:[String:Any] = ["userId":"38567","pagesize":"100","pageIndex":"1"];
        
        Alamofire.request(urlStr, method: .post, parameters: paramsDic).responseJSON(completionHandler: { (responseObj) in
            
            switch(responseObj.result) {
            case .success(_):
                if let dataDic = responseObj.result.value as? NSDictionary{
                    print("输出此时的结果数据..........\(dataDic)");
                    
                    let itemArr:NSArray = dataDic.object(forKey: "ITEMS") as! NSArray;
                    self.dataArray = NSMutableArray.init(array: itemArr);
                    self.myTableView.reloadData();
                }
                break
                
            case .failure(_):
                print(responseObj.result.error!)
                break
            }
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

