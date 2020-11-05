# css笔记

- 目标。利用所学知识能独立完成静态页面制作。
- 重点。选择器、盒子模型、定位、布局、文本样式化等。
- 参考。MDN、菜鸟教程、CSS参考手册等。

***

## 一、选择器

* 元素选择器。

  * *通配选择符，表示选取所有元素对象。

  * E类型选择符（元素选择符）。
  * E#myid选择符。
  * E.myclass选择符。表示以class属性包含myclass的E对象作为选择符。

* 关系选择器。

  * E F 包含选择符。表示选择所有被E元素包含的F元素。
  * E > F 子选择符。表示选择所有作为E元素的子元素F。
  * E + F 相邻选择符。选择紧贴在E元素之后的F元素。
  * E ~ F 兄弟选择符。选择E元素所有兄弟元素（也就是和E同一节点的元素）。

* 属性选择器。

  * E[att]。选择具有att属性的E元素。

  * E[att="val"]。选择具有att属性且属性值等val的E元素。

  * E[att~="val"]。选择具有att属性且属性值为用空格分隔的字词列表，其中一个等于val的E元素（包含只有一个值且该值等于val的情况）。 

    ```html
    <!-- HTML代码 -->
    
    <div class="a">1</div>
    <div class="b">2</div>
    <div class="a b">3</div>
    
    ```

    ```css
    //css代码
    
    a[class~="a"] {
        color: red;
    }
    
    //将会命中1,3两个div，因为匹配到了class属性，且属性值中有一个值为a。
    ```

  * E[att^="val"]。选择具有att属性且属性值以val开头的字符串的E元素。

  * E[att$="val"]。选择具有att属性且属性值为以val结尾的字符串的E元素。

  * E[att*="val"]。选择具有att属性且属性值为包含val的字符串的E元素。

  * E[att|="val"]。选择具有att属性，其值是以[val]开头并用连接符"-"分隔的字符串的E元素；如果值仅为[val]，也将被选择。如果元素E拥有att属性，并且值为[val]，或者值是以[val-]开头的，那么E将被选择。

* 伪类选择器。

  * E:focus。设置对象在成为输入焦点（该对象的onfocus事情发生）时的样式。备注：webkit内核浏览器会默认给:focus状态的元素加上ontline的样式。该选择符主要用于表单输入框。
  * E:last-child。匹配父元素的最后一个子元素E。要使该属性生效，E元素必须是某个元素的子元素，E的父元素最高是body，即E可以是body的子元素。E:first-child恰好与之相反，它匹配的是第一个子元素。
  * E:only-child。匹配父元素仅有的一个子元素E。
  * E:checked。匹配用户界面上处于选中状态的元素E，主要用于文本框和表单表样式。

* 伪对象选择器。主要包括E::first-letter，E::first-line，E::before，E::after，E::placeholder，E::selection

  * ::first-letter。设置对象内的第一个字符的样式。
  * ::first-line。设置对象内的第一行的样式。
  * ::before。设置在对象前（依据对象村的逻辑结构）发生的内容，用来和content属性一起使用。
  * ::after。与::before相反。
  * ::placeholder。设置对象文字点位符的样式。主要用于input文本框。
  * ::selection。设置对象被选择时的颜色。

## 二、盒子模型

当对一个文本进行布局时，浏览器渲染引擎会根据标准之一的CSS基础框盒模型，将所有元素表示为一个个距形盒子。CSS决定这些盒子的大小、位置以及属性等。每个盒子有四个边界，分别为：内容边界（Content Edge）、内边距边界（Padding Edge）、边框边界（Boder Edge）、外边框边界（Marrgin Edge）。

1. 内容区域。由内容边界限制，容纳着元素的真实内容。如文本、图像、视频等。它的尺寸为内容宽高度（content-box宽度）。通常包含有一个背景颜色（默认为透明）或背景图像。***如果box-sizing为border-box(默认),则内容区域的大小可明确地通过width、min-width、max-width、height、min-height和max-height控制。***

2. 内边距区域。内容到边框的空白区或，由上右下左四个值控制。padding值不能取负数。

3. 边框。由border-box的宽高度决定其粗细大小。

4. 相领两个元素之间的距离。

   ***对于行内元素来说，尽管内容周围存在内边距与边框，但其占用空间（每一行文字的高度）则由Line-height属性决定，即使边框和内边距仍会显示在内容周围。***

* 标准盒子。W3C标准盒子的大小由内容宽高度、内边距和边框组成，虽然外边距也决定盒子所占空间位置，但它并不是盒子大小的组成部分，我们平时定义盒子的大小是内容盒子的大小，一个盒子在网页中所占的总宽度为:内容宽度+左右内边距+左右边框，但非标准盒子则涵盖了上述这个属性的宽度。上下块级盒子的外边距会产生合并，即小从大，定位的盒子的外边距并不会产生外边距合并。
* 非准盒子。以IE6.7.8浏览器为代表的盒子的宽度不是内容的宽度，而是内容、内边距和边框的宽度。
* 使用建议。不要给元素添加具有指定宽度的内边距，而是偿试将内边距或外边距添加到元素的父元素和子元素。或者把box-sizing的值设为border-box， 这样做可以把盒子的宽度控制在边框范围内。有两点值得注意。一W3C标准盒子（content-box），border，padding的设置会破坏元素的宽高，必须得重新计算；二IE盒子（border-box），border，paddnig的设置不会影响元素的宽高，当设置了box-sizing为border-box时，增加了内边距和边框的大小，其内容宽度会减小。

## 三、文本样式

font简写顺序：font-style|font-variant|font-weight|font-stretch|font-size|line-height|font-family。

```css
font: intalic normal bold normal 3rem / 1.6 Helvetica Arial, sans-serif;
```

* 字体引用。可以通过font-family属性进行文本样式设置。下列几种字体为默认字体：

  * serif。有衬线的字体，衬线是指字体笔画末端的小装饰，存在于某些印刷字体中。

  * sans-serif。没有衬线的字体。

  * monospace。每个字符具有相同宽度的字体，通常用于代码列表。

  * cursive。用于模拟笔迹的字体，具有流动的连接笔画。

  * fantasy。用来装饰的字体。

    ***多种字体同时引用时，字体间用逗号分隔，如不是默认字体，字体名称需要加双引号，浏览器会从列表的第一个开始，从当前机器中开始查找引用。***

* 字体大小。可以通过百分比、px、em和rem作为单位进行设置字体的大小。元素的font-size属性会从元素的父元素继承，浏览器的标准字体大小为1rem即16px。

  * 使用建议。当调整文本大小时，可以将文档的基础font-size设置为10px，这样方便计算，所需的(r)em值就是想得到的像素的值除以10，而不是16，在样式表的指定区域列出所有font-size的规则集。

    ```css
    html {
        font-size: 10px;
    }
    
    h1 {
        font-size: 2.6rem;
    }
    
    p {
        font-family: Arial,sans-serif:
        font-size: 1.4rem;
        color: $priamry-color;
        
    }
    ```

* 字体样式（font-style）。包括字体风格式样（即是否斜体等）。常有的属性值有normal、italic。

* 字体粗细（font-weight）。bold（加粗）或者取100-900范围的数值，一般来说标题字体为粗体。

* 字体转换（text-transform）。主要针对大小写转换。本属性值有uppercase、lowcase。

* 字体装饰（text-decoration）。属性值有none、underline、overline(上划线)、line-through。

* 文字阴影（text-shadow）。正偏移值可以向右移动阴影，但也可以使用负偏移值来左右移动阴影。可以同时使用多种阴影，每一组值之间用逗号分隔。

  ```css
  text-shadow: 4px 4px 5px #eee;  
  
//第一个值表示阴影与原始文本的水平偏移，可以使用其他CSS单位，但是使用px比较适合，这个值必须指定。
  //第二个值表示阴影与原始文本的垂直偏移；效果基本上就像水平偏移，除了它向上或向下移动阴影，而不是向左或向右。这个值必须指定。
  //模糊半径。更高的值意味着阴影分散得更广泛。默认为0，表示没有模糊。
  ```
  
* 文本对齐（text-align）。本属性用来控制文本如何和它所有在的内容盒子对齐。取值包括:left、right、center、justify（使文本展开，改变单词之间的差距，使所有文本行的宽度相同。）

* 文本行高。设置文本每行之间的高。无单位的值乘以font-size来获得行高。推荐的行高大约是1.5-2（双倍间距）。

* 字母和单词间距。分别是letter-spacing和word-spacing两个属性，取值以像素为单位。

* 定义字体并引用。通过CSS3的@font-face规则自定义字体并引用，推荐使用阿里巴巴图标库的免费字体。字体之间以逗号分隔。

  ```css
  <style>
  @font-face {
     font-family: myfirstFont;
      src: url(sansation_light.woff);
  }
  
  div {
      font-family: myfirstFont;
  }
  
  </style>
  ```

* 链接虚类规则集。

  ```css
  a {
  
  }
  
  a:link {
  
  }
  
  a:visited {
  
  }
  
  a:focus {
  
  }
  
  a:hover {
  
  }
  
  a:active {
  
  }
  ```

  

## 四、背景属性

## 五、内外边距

* 内边距（padding）。
* 外边距(margin)。

## 六、边框属性



## 七、盒子阴影

## 八、动画

## 九、布局

## 十、sass

## 十一、命名规范

## 十二、CSS规划



