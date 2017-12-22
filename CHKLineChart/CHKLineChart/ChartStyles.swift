//
//  ChartStyles.swift
//  CHKLineChart
//
//  Created by Chance on 2017/6/12.
//  Copyright © 2017年 bitbank. All rights reserved.
//

import UIKit

// MARK: - 扩展样式
public extension CHKLineChartStyle {
    
    //实现一个自定义的明亮风格样式，开发者可以自由扩展配置样式
    public static var customLight: CHKLineChartStyle {
        
        /*** 明亮风格 ***/
        
        let style = CHKLineChartStyle()
        //字体大小
        style.labelFont = UIFont.systemFont(ofSize: 10)
        //分区框线颜色
        style.lineColor = UIColor.clear
        //Y轴上虚线颜色
        style.dashColor = UIColor.clear
        //选中价格显示的背景颜色
        style.selectedBGColor = UIColor(white: 0.4, alpha: 1)
        //文字颜色
        style.textColor = UIColor(white: 0.5, alpha: 1)
        //背景颜色
        style.backgroundColor = UIColor.white
        //选中点的显示的文字颜色
        style.selectedTextColor = UIColor(white: 0.8, alpha: 1)
        //整个图表的内边距
        style.padding = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        //Y轴是否内嵌式
        style.isInnerYAxis = true
        //显示X轴坐标内容在哪个分区仲
        style.showXAxisOnSection = 0
        //Y轴显示在右边
        style.showYLabel = .right
        
        
        //配置图表处理算法
        style.algorithms = [
            CHChartAlgorithm.timeline,
            CHChartAlgorithm.ma(5),
            CHChartAlgorithm.ma(10),
            CHChartAlgorithm.ma(30),
            CHChartAlgorithm.ema(5),
            CHChartAlgorithm.ema(10),
            CHChartAlgorithm.ema(12),       //计算MACD，必须先计算到同周期的EMA
            CHChartAlgorithm.ema(26),       //计算MACD，必须先计算到同周期的EMA
            CHChartAlgorithm.ema(30),
            CHChartAlgorithm.macd(12, 26, 9),
            CHChartAlgorithm.kdj(9, 3, 3),
            CHChartAlgorithm.boll(12, 26, 9),

        ]
        
        //分区点线样式
        //表示上涨的颜色
        let upcolor = UIColor.ch_hex(0x5BA267)
        //表示下跌的颜色
        let downcolor = UIColor.ch_hex(0xB1414C)
        let priceSection = CHSection()
        priceSection.backgroundColor = style.backgroundColor
        //分区上显示选中点的数据文字是否在分区外显示
        priceSection.titleShowOutSide = false
        //是否显示选中点的数据文字
        priceSection.showTitle = false
        //分区的数值类型
        priceSection.valueType = .price
        //是否隐藏分区
        priceSection.hidden = false
        //分区所占图表的比重，0代表不使用比重，采用固定高度
        priceSection.ratios = 0
        //分区采用固定高度
        priceSection.fixHeight = 176
        //分区内边距
        priceSection.padding = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        /// 时分线
        let timelineSeries = CHSeries.getTimelinePrice(
            color: UIColor.ch_hex(0xAE475C),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .circle(UIColor.ch_hex(0xAE475C), true),
            lineWidth: 2)
        
        timelineSeries.hidden = true
        
        
        let maColor = [
            UIColor.ch_hex(0x4E9CC1),
            UIColor.ch_hex(0xF7A23B),
            UIColor.ch_hex(0xF600FF),
            ]
        
        /// 蜡烛线
        let priceSeries = CHSeries.getCandlePrice(
            upColor: upcolor,
            downColor: downcolor,
            titleColor: UIColor(white: 0.5, alpha: 1),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .arrow(UIColor(white: 0.5, alpha: 1)))
        
        //MA线
        let priceMASeries = CHSeries.getMA(
            isEMA: false,
            num: [5,10,30],
            colors:maColor,
            section: priceSection)
        
        priceMASeries.hidden = false
        
        //EMA线
        let priceEMASeries = CHSeries.getMA(
            isEMA: true,
            num: [5,10,30],
            colors: maColor,
            section: priceSection)
        
        priceEMASeries.hidden = true
        priceSection.series = [timelineSeries, priceSeries, priceMASeries, priceEMASeries]
        
        //交易量柱形线
        let volumeSection = CHSection()
        volumeSection.backgroundColor = style.backgroundColor
        volumeSection.valueType = .volume
        volumeSection.hidden = false
        volumeSection.showTitle = false
        volumeSection.ratios = 1
        volumeSection.yAxis.tickInterval = 2
        volumeSection.padding = UIEdgeInsets(top: 10, left: 0, bottom: 4, right: 0)
        let volumeSeries = CHSeries.getDefaultVolume(upColor: upcolor, downColor: downcolor, section: volumeSection)
        let volumeMASeries = CHSeries.getMA(
            isEMA: false,
            num: [5,10,30],
            colors: maColor, section:
            volumeSection)
        
        let volumeEMASeries = CHSeries.getMA(
            isEMA: true,
            num: [5,10,30],
            colors: maColor,
            section: volumeSection)
        
        volumeEMASeries.hidden = true
        volumeSection.series = [volumeSeries, volumeMASeries, volumeEMASeries]
        
        let trendSection = CHSection()
        trendSection.backgroundColor = style.backgroundColor
        trendSection.valueType = .analysis
        trendSection.hidden = false
        trendSection.showTitle = false
        trendSection.ratios = 1
        trendSection.paging = true
        trendSection.yAxis.tickInterval = 2
        trendSection.padding = UIEdgeInsets(top: 10, left: 0, bottom: 8, right: 0)
        let kdjSeries = CHSeries.getKDJ(UIColor.ch_hex(0xDDDDDD),
                                        dc: UIColor.ch_hex(0xF9EE30),
                                        jc: UIColor.ch_hex(0xF600FF),
                                        section: trendSection)
        
        kdjSeries.title = "KDJ(9,3,3)"
        
        let macdSeries = CHSeries.getMACD(UIColor.ch_hex(0xDDDDDD),
                                          deac: UIColor.ch_hex(0xF9EE30),
                                          barc: UIColor.ch_hex(0xF600FF),
                                          upColor: upcolor, downColor: downcolor,
                                          section: trendSection)
        macdSeries.title = "MACD(12,26,9)"
        macdSeries.symmetrical = true
        let bollSeries = CHSeries.getBOLL(UIColor.ch_hex(0xDDDDDD),
                                          up: UIColor.ch_hex(0xF9EE30),
                                          dn: UIColor.ch_hex(0xF600FF),
                                          section: trendSection)
        
        bollSeries.title = "MAD(12,26,9)"
        bollSeries.symmetrical = true
        
        
        trendSection.series = [
            kdjSeries,
            macdSeries,
            bollSeries,
        ]
        style.sections = [priceSection, volumeSection, trendSection]
        
        return style
    }
    
    //实现一个暗黑风格的样式，开发者可以自由扩展配置样式
    public static var customDark: CHKLineChartStyle {
        
        /*** 暗黑风格 ***/
        
        let style = CHKLineChartStyle()
        //字体大小
        style.labelFont = UIFont.systemFont(ofSize: 10)
        //分区框线颜色
        style.lineColor = UIColor.clear
        //Y轴上虚线颜色
        style.dashColor = UIColor.clear
        //选中价格显示的背景颜色
        style.selectedBGColor = UIColor(white: 0.4, alpha: 1)
        //文字颜色
        style.textColor = UIColor(white: 0.8, alpha: 1)
        //背景颜色
        style.backgroundColor = UIColor.ch_hex(0x1D1C1C)
        //选中点的显示的文字颜色
        style.selectedTextColor = UIColor(white: 0.8, alpha: 1)
        //整个图表的内边距
        style.padding = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        //Y轴是否内嵌式
        style.isInnerYAxis = true
        //显示X轴坐标内容在哪个分区仲
        style.showXAxisOnSection = 0
        //Y轴显示在右边
        style.showYLabel = .right
        
        
        //配置图表处理算法
        style.algorithms = [
            CHChartAlgorithm.timeline,
            CHChartAlgorithm.ma(5),
            CHChartAlgorithm.ma(10),
            CHChartAlgorithm.ma(30),
            CHChartAlgorithm.ema(5),
            CHChartAlgorithm.ema(10),
            CHChartAlgorithm.ema(12),       //计算MACD，必须先计算到同周期的EMA
            CHChartAlgorithm.ema(26),       //计算MACD，必须先计算到同周期的EMA
            CHChartAlgorithm.ema(30),
            CHChartAlgorithm.macd(12, 26, 9),
            CHChartAlgorithm.kdj(9, 3, 3),
            CHChartAlgorithm.boll(9, 3, 3),

        ]
        
        //分区点线样式
        //表示上涨的颜色
        let upcolor = UIColor.ch_hex(0x5BA267)
        //表示下跌的颜色
        let downcolor = UIColor.ch_hex(0xB1414C)
        let priceSection = CHSection()
        priceSection.backgroundColor = style.backgroundColor
        //分区上显示选中点的数据文字是否在分区外显示
        priceSection.titleShowOutSide = false
        //是否显示选中点的数据文字
        priceSection.showTitle = false
        //分区的数值类型
        priceSection.valueType = .price
        //是否隐藏分区
        priceSection.hidden = false
        //分区所占图表的比重，0代表不使用比重，采用固定高度
        priceSection.ratios = 0
        //分区采用固定高度
        priceSection.fixHeight = 176
        //分区内边距
        priceSection.padding = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        /// 时分线
        let timelineSeries = CHSeries.getTimelinePrice(
            color: UIColor.ch_hex(0xAE475C),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .circle(UIColor.ch_hex(0xAE475C), true),
            lineWidth: 2)
        
        timelineSeries.hidden = true
        
        
        let maColor = [
            UIColor.ch_hex(0xDDDDDD),
            UIColor.ch_hex(0xF9EE30),
            UIColor.ch_hex(0xF600FF),
        ]
        
        /// 蜡烛线
        let priceSeries = CHSeries.getCandlePrice(
            upColor: upcolor,
            downColor: downcolor,
            titleColor: UIColor(white: 0.5, alpha: 1),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .tag(UIColor.white))
        
        //MA线
        let priceMASeries = CHSeries.getMA(
            isEMA: false,
            num: [5,10,30],
            colors:maColor,
            section: priceSection)
        
        priceMASeries.hidden = false
        
        //EMA线
        let priceEMASeries = CHSeries.getMA(
            isEMA: true,
            num: [5,10,30],
            colors: maColor,
            section: priceSection)
        
        priceEMASeries.hidden = true
        priceSection.series = [timelineSeries, priceSeries, priceMASeries, priceEMASeries]
        
        //交易量柱形线
        let volumeSection = CHSection()
        volumeSection.backgroundColor = style.backgroundColor
        volumeSection.valueType = .volume
        volumeSection.hidden = false
        volumeSection.showTitle = false
        volumeSection.ratios = 1
        volumeSection.yAxis.tickInterval = 2
        volumeSection.padding = UIEdgeInsets(top: 10, left: 0, bottom: 4, right: 0)
        let volumeSeries = CHSeries.getDefaultVolume(upColor: upcolor, downColor: downcolor, section: volumeSection)
        let volumeMASeries = CHSeries.getMA(
            isEMA: false,
            num: [5,10,30],
            colors: maColor, section:
            volumeSection)
        
        let volumeEMASeries = CHSeries.getMA(
            isEMA: true,
            num: [5,10,30],
            colors: maColor,
            section: volumeSection)
        
        volumeEMASeries.hidden = true
        volumeSection.series = [volumeSeries, volumeMASeries, volumeEMASeries]
        
        let trendSection = CHSection()
        trendSection.backgroundColor = style.backgroundColor
        trendSection.valueType = .analysis
        trendSection.hidden = false
        trendSection.showTitle = false
        trendSection.ratios = 1
        trendSection.paging = true
        trendSection.yAxis.tickInterval = 2
        trendSection.padding = UIEdgeInsets(top: 10, left: 0, bottom: 8, right: 0)
        let kdjSeries = CHSeries.getKDJ(UIColor.ch_hex(0xDDDDDD),
                                        dc: UIColor.ch_hex(0xF9EE30),
                                        jc: UIColor.ch_hex(0xF600FF),
                                        section: trendSection)
        
        kdjSeries.title = "KDJ(9,3,3)"
        
        let macdSeries = CHSeries.getMACD(UIColor.ch_hex(0xDDDDDD),
                                          deac: UIColor.ch_hex(0xF9EE30),
                                          barc: UIColor.ch_hex(0xF600FF),
                                          upColor: upcolor, downColor: downcolor,
                                          section: trendSection)
        macdSeries.title = "MACD(12,26,9)"
        macdSeries.symmetrical = true
        let bollSeries = CHSeries.getBOLL(UIColor.ch_hex(0xDDDDDD),
                                          up: UIColor.ch_hex(0xF9EE30),
                                          dn: UIColor.ch_hex(0xF600FF),
                                          section: trendSection)
        
        bollSeries.title = "MAC(12,26,9)"
        bollSeries.symmetrical = true
        
        
        trendSection.series = [
            kdjSeries,
            macdSeries,
            bollSeries,
        ]
        
        style.sections = [priceSection, volumeSection, trendSection]
        
        
        return style
    }
    
    
    
    //实现一个暗黑风格的点线简单图表
    public static var simpleLineDark: CHKLineChartStyle {
        
        /*** 暗黑风格 ***/
        
        let style = CHKLineChartStyle()
        //字体大小
        style.labelFont = UIFont.systemFont(ofSize: 10)
        //分区框线颜色
        style.lineColor = UIColor.clear
        //Y轴上虚线颜色
        style.dashColor = UIColor.ch_hex(0x8D7B62, alpha: 0.44)
        //选中价格显示的背景颜色
        style.selectedBGColor = UIColor(white: 0.4, alpha: 1)
        //文字颜色
        style.textColor = UIColor.ch_hex(0x8D7B62, alpha: 0.44)
        //背景颜色
        style.backgroundColor = UIColor.ch_hex(0x383D49)
        //选中点的显示的文字颜色
        style.selectedTextColor = UIColor(white: 0.8, alpha: 1)
        //整个图表的内边距
        style.padding = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        //Y轴是否内嵌式
        style.isInnerYAxis = true
        //显示X轴坐标内容在哪个分区仲
        style.showXAxisOnSection = 0
        //Y轴显示在右边
        style.showYLabel = .left
        //是否把所有点都显示
        style.isShowAll = true
        //禁止所有手势操作
        style.enablePan = false
        style.enableTap = false
        style.enablePinch = false
        
        
        //配置图表处理算法
        style.algorithms = [
            CHChartAlgorithm.timeline
        ]
        
        let priceSection = CHSection()
        priceSection.backgroundColor = style.backgroundColor
        //分区上显示选中点的数据文字是否在分区外显示
        priceSection.titleShowOutSide = false
        //是否显示选中点的数据文字
        priceSection.showTitle = false
        //分区的数值类型
        priceSection.valueType = .price
        //是否隐藏分区
        priceSection.hidden = false
        //分区所占图表的比重，0代表不使用比重，采用固定高度
        priceSection.ratios = 1
        //Y轴隔间数
        priceSection.yAxis.tickInterval = 2
        //分区内边距
        priceSection.padding = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        /// 时分线
        let timelineSeries = CHSeries.getTimelinePrice(
            color: UIColor.ch_hex(0xAE475C),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .circle(UIColor.ch_hex(0xAE475C), true),
            lineWidth: 2)
        
        priceSection.series = [timelineSeries]
        
        style.sections = [priceSection]
        
        
        return style
    }
    
}
