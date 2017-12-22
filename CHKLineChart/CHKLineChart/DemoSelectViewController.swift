//
//  ViewController.swift
//  CHKLineChart
//
//  Created by Chance on 16/8/31.
//  Copyright © 2016年 Chance. All rights reserved.
//

import UIKit

class DemoSelectViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    let demo: [Int: (String, String)] = [
        0: ("K线一般功能演示", "ChartDemoViewController"),
        1: ("K线风格设置演示", "CustomStyleViewController"),
        2: ("K线商业定制例子", "ChartCustomDesignViewController"),
        3: ("K线简单线段例子", "ChartFullViewController"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let name = "ChartDemoViewController"
        let vc = story.instantiateViewController(withIdentifier: name)
        self.present(vc, animated: true, completion: nil)

    }
}

extension DemoSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "DemoCell")
        }
        cell?.textLabel?.text = self.demo[indexPath.row]!.0
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let name = self.demo[indexPath.row]!.1
        let vc = story.instantiateViewController(withIdentifier: name)
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
