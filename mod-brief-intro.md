# 各模块概览

## SQL解析与语义检查
当用户把SQL语句发送到服务端后，服务端首先要做的就是SQL语句的解析工作。与传统的解析程序一样，Blastoise的SQL解析工作分成词法分析和语法分析两个阶段。分成两个阶段的好处是可以把生成单词和根据单词序列生成解析树解耦。另外，虽然对于服务端来说，有可能一条SQL语句会被分段接收到，虽然也有流式对SQL语句同时进行词法分析和语法分析的算法，但一方面这会大大增加解析SQL语句的复杂程度，另一方面解析SQL语句不可能是查询流程的性能瓶颈，因此这里就不采用这种流式的解析方法。
在词法分析上可以使用传统的有限自动机实现，但是同时也会遇到一些问题，文本会在详解部分给出这些问题并提供解决方案。
在文法上，SQL语句本身的设计在考虑到易于理解（类似于自然语言）的同时也兼顾了易于解析。SQL语句本身的大部分文法都是SLL(1)，对于这部分的文法解析起来会特别容易，它可以使用不少自顶向下和自底向上的解析方法。然而解析SQL语句最复杂的地方在于WHERE子句中的逻辑表达式，这并不是简单的SLL(1)。Blastoise整体上还是采用自顶向下中的递归下降法，然而这种方法还是有不少缺陷，本文会在语法分析部分给出这些缺陷还有对递归下降做的变种来解决这些问题。

## 执行计划
在SQL语句被转化成解析树的之后，解析树会被转换成执行计划，接着执行计划运行就会把SQL语句的查询操作完成。在《数据库的设计与实现》[ref tag]中，执行计划被分为逻辑执行计划和物理执行计划。SQL语句首先会被转换为逻辑执行计划，接着逻辑执行计划再被转换成真正可被计算机执行的物理执行计划。在逻辑执行计划和物理执行计划中，会分别有一些定律被应用于逻辑执行计划，使一个执行计划（这里指逻辑执行计划或物理执行计划）被转换成另一个具有同等语义但效率更高的执行计划。
而物理执行计划可由数个迭代器组装而成。比如扫描表的操作就是一个不断返回表元组的迭代器，而过滤操作则是一个不断返回经过过滤元组的迭代器。在相关部分将详细说明迭代器在实现物理执行计划时的妙用。
为了精简，Blastoise没有实现优化执行计划，也没有生成逻辑执行计划这个环节。在Blastoise中，SQL的解析树会直接被转换为物理执行计划。此外，Blastoise只实现了一趟算法[ref tag]。

## 持久化
关系型数据库的主要功能还是对数据持久化。对表进行持久化的一种重点问题是对数据存储格式的设计。对于定长数据和变长数据，存储格式设计的方法也不一样。如果需要支持NULL数据，存储格式也会有相应的策略。为了简化问题，Blastoise仅支持整型、浮点型、定长字符串三种定长数据类型，并且不支持NULL。在相关部分会给出完整的存储格式描述。