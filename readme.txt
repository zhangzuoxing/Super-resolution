超分辨率重建程序说明
SRICSM1.0
1 简介
程序原理是基于凸集中间映射(ICSM)的超分辨率重建，是在POCS上的改进算法，具体原理见小论文。按照执行的先后顺序，共分为四个部分：点扩散函数的获取，图像配准，ICSM算法重建，图像质量评价。第一步执行完需手动裁出点扩散函数序列，其他步骤有参数可调节，也可使用默认参数。该程序属于SRMCSM1.0版本的半自动程序。具体执行方法main.m函数中也有介绍,共有2个主函数main.m和cut800.m，19个子函数。
2 执行步骤
其中2.1节需独立编写，2.2及以下执行步骤均在main主函数中操作即可，输入图片格式不限，但不要有黑边。
2.1 点扩散函数
目的：求解模糊矩阵。
表1：点扩散函数执行步骤
输入：序列图片文件夹
输出：点扩散函数序列
可调节参数：放大倍数factor，通常为2倍 
说明：
裁图： 取原图片序列，双线性插值扩大原来n倍，程序自动以中心为原点裁成800*800大小图像；
点扩散函数：将图片逐个输入deblur软件，得到序列点扩散函数（人工）。
算法：裁图+deblur_software
      裁图用cut800.m函数
             cut.m是它的子文件 

2.2 图像配准
目的：求解几何形变矩阵，并检查序列是否精确到亚像素级配准，若配准成功，则可执行2.2;若配准失败则程序执行失败，在双线性验证处可做接口方便人眼判断，在程序自动运行出错时方便查找。若将来有更优秀的配准算法，可将这部分替换掉。
表2：图像配准执行步骤
输入：序列图片文件夹
输出：配准后的图片序列（选择性输出）
      配准后的图片序列与原图的差值（选择性输出）
可调节参数：disRatio（0.3～0.9）；alpha（0.2～1.5）；放大倍数factor，默认2
            Jy=4000(1000~10000)
说明：
将八帧图片放入一个文件夹内，运行程序，直接选择文件夹。
通过调节参数，控制特征点数量，默认disRatio=0.49，alpha=0.3；
算法： 读图readimage.m
       SIFT+BBF+角度阈值+RANSAC+双线性验证+奇异帧检测与移除
       SIFT见ysift.m是原作者提供的代码；
       BBF特征点初匹配rymatch.m;
       角度阈值yangle.m;和yoptIndex.m
       RANSAC是rac2.m
       双线性插值，可看配准后纠正回来的图像是否准确，可做图像输出接口，yytwo2.m
       奇异帧检测，一小段代码，在主函数里。
2.3 ICSM重建
目的：重建超分辨率图像 
表三：MCSM重建执行步骤
输入：序列图片文件夹
      几何形变矩阵T
      点扩散函数序列
输出：高分辨率图像
可调节参数：迭代次数iters，默认为3
            残差derta（0.5～3）
说明：
    残差derta约束解集的范围，通常设置为1.5；
算法：ICSM
      用到了matlab自带的deconvblind函数
      其他见pocsbilinear.m函数
2.4 图像质量评价
目的：对重建图像进行客观评价 
表三：MCSM重建执行步骤
输入：原图
双线性插值图像
单帧去卷积图像
超分辨率重建图像 
输出：客观评价指标
说明：
      无需人工输入，不想输出可以屏蔽
算法：信息熵+标准差+空间频率+灰度平均梯度
      信息熵Entropy.m
      标准差StandardDeviation.m
      空间频率frequency.m
      灰度平均梯度GrayMeanGrads.m
    总体而言，需人工输入的有两步，一是输入图片，二是结合其他软件输入点扩散函数序列。可调参数可按默认要求设置或选择合适参数。
3 总体流程图
 
4 demo
设置参数：全部选为默认参数
单击matlab运行
先输入：origin文件夹（8帧）
提示后输入：psf文件夹（8帧）（已经由软件获得）
输出：重建图像finally.bmp
