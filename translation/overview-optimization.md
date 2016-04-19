An Overview of Query Optimization in Relational Systems

&&&
关系型数据库查询优化概览
&&&

3. AN EXAMPLE: SYSTEM-R OPTIMIZER
&&&
3. 例子：SYSTEM-R的优化器
&&&
The System-R project significantly advanced the state of query
optimization of relational systems. The ideas in [55] have been
incorporated in many commercial optimizers continue to be
remarkably relevant. I will present a subset of those important
ideas here in the context of Select-Project-Join (SPJ) queries. The
class of SPJ queries is closely related to and encapsulates
conjunctive queries, which are widely studied in Database Theory.
The search space for the System-R optimizer in the context of a
SPJ query consists of operator trees that correspond to linear
sequence of join operations, e.g., the sequence
Join(Join(Join(A,B),C),D) is illustrated in Figure
2(a). Such sequences are logically equivalent because of
associative and commutative properties of joins. A join operator
can use either the nested loop or sort-merge implementation. Each
scan node can use either index scan (using a clustered or nonclustered
index) or sequential scan. Finally, predicates are
evaluated as early as possible.
![fig2](./1fig2.jpg)
&&&
System-R极大地推动了关系型数据库查询优化的研究。[55]中的的想法已经被用于很多商业的优化器。我这里会展示SPJ查询中的一部分重要的思想。SPJ与被数据库理论广泛研究的关联查询有很大的关系并且很好地总结了它。使用SPJ来说，System-R优化器中的的搜索空间由一些对应于一个连接序列的操作符树组成。例如，序列Join(Join(Join(A,B),C),D)可以用Fig2来表述。因为连接操作的结合性和交换性，这样的序列逻辑上与树相同。一个连接操作符可以用一个双层循环或者合并排序来实现。每个扫描结点可以使用索引扫描（使用聚合索引或非聚合索引）或者是顺序扫描。最后，断言被尽早地求值。
&&&
The cost model assigns an estimated cost to any partial or
complete plan in the search space. It also determines the estimated
size of the data stream for output of every operator in the plan. It
relies on:
&&&
耗费模型给出了搜索空间中部分或者整个执行计划的一个估算耗费。它同时决定了在执行计划中每个操作符的数据流的估算大小。它依赖于：
&&&
(a) A set of statistics maintained on relations and indexes, e.g.,
number of data pages in a relation, number of pages in an
index, number of distinct values in a column
&&&
(a)一组对于关系和索引的统计数据。例如关系中的数据页的数量，索引用到的数据页的数量，一列中不同的值的数量。
&&&
(b) Formulas to estimate selectivity of predicates and to project
the size of the output data stream for every operator node.
For example, the size of the output of a join is estimated by
taking the product of the sizes of the two relations and then
applying the joint selectivity of all applicable predicates.
&&&
(b)用于估计每个操作结点筛选率的断言和数据流投影大小的公式。例如，连接操作的输出规模是这样估计的，把两个做连接操作的关系的大小乘起来然后算上所有用到的断言的筛选率。
&&&
(c) Formulas to estimate the CPU and I/O costs of query
execution for every operator. These formulas take into
account the statistical properties of its input data streams,
existing access methods over the input data streams, and any
available order on the data stream (e.g., if a data stream is
ordered, then the cost of a sort-merge join on that stream may
be significantly reduced). In addition, it is also checked if the
output data stream will have any order.
&&&
(c)用于估计查询操作中每个操作符的CPU和IO耗费的公式。这些公式把输入流的统计特性、所有可用的的数据获取方法，还有数据流任何可用的顺序纳入估算中（例如，如果一个数据流是有序的，那么对这个数据流做归并排序的耗费就可以减少很多）。此外，输出流也会被检查是否具有有序性。
&&&
The cost model uses (a)-(c) to compute and associate the
following information in a bottom-up fashion for operators in a
plan: (1) The size of the data stream represented by the output of
the operator node. (2) Any ordering of tuples created or sustained
by the output data stream of the operator node. (3) Estimated
execution cost for the operator (and the cumulative cost of the
partial plan so far).
&&&
耗费模型使用了(a)-(c)以一种自底向上方法来计算执行计划中的操作符和结合下面列到的信息。(1)体现数据流大小的操作符输出数据流规模。(2)任何由一个操作符结点创建或者保持的输出元组有序性。(3)操作符的估算耗费（包括到这个到操作符位置累计的所有部分执行计划的耗费）。
&&&
The enumeration algorithm for System-R optimizer demonstrates
two important techniques: use of dynamic programming and use
of interesting orders.
&&&
System-R查询优化器中的遍历算法说明了两个重要的技术：动态规划的使用和期望的顺序。
&&&
The essence of the dynamic programming approach is based on
the assumption that the cost model satisfies the principle of
optimality. Specifically, it assumes that in order to obtain an
optimal plan for a SPJ query Q consisting of k joins, it suffices to
consider only the optimal plans for subexpressions of Q that
consist of (k-1) joins and extend those plans with an additional
join. In other words, the suboptimal plans for subexpressions of Q
(also called subqueries) consisting of (k-1) joins do not need to be
considered further in determining the optimal plan for Q.
Accordingly, the dynamic programming based enumeration views
a SPJ query Q as a set of relations {R1,..Rn} to be joined. The
enumeration algorithm proceeds bottom-up. At the end of the j-th
step, the algorithm produces the optimal plans for all subqueries
of size j. To obtain an optimal plan for a subquery consisting of
(j+1) relations, we consider all possible ways of constructing a
plan for the subquery by extending the plans constructed in the jth
step. For example, the optimal plan for {R1,R2,R3,R4} is
obtained by picking the plan with the cheapest cost from among
the optimal plans for: (1)Join({R1,R2,R3},R4) (2)
Join({R1,R2,R4},R3) (3) Join ({R1,R3,R4},R2) (4)
Join({R2,R3,R4}, R1). The rest of the plans for
{R1,R2,R3,R4} may be discarded. The dynamic programming
approach is significantly faster than the naïve approach since
instead of O(n!) plans, only O(n2n -1) plans need to be enumerated.
&&&
使用动态规划的本质是基于耗费模型符合优化性质的假设。更确切地说，它假设为了获取SPJ的一个最有的执行计划，这样一个执行计划Q由k个连接符组成，它可以先知考虑所有Q的只有k-1个连接符的子表达式，然后在此基础上扩展多一个连接符。换句话来说，Q子表达式（或者说子查询）的只有k-1个连接符的最优子计划对于Q的整体最优解来说就不用继续考虑。由此，基于动态规划的遍历视一个SPJ查询Q为一组将要被连接的关系{R1,..Rn}。遍历算法自底向上运行。在第j步结束的时候，算法计算除了所有规模为j的子查询的最优解。为了得到涵盖了j+1关系的子查询的最优解，我们考虑所有利用在j步计算出来的子最优解能够组合构造出来的情况。例如对于{R1,R2,R3,R4}的最优解，是在(1)Join({R1,R2,R3},R4) (2)Join({R1,R2,R4},R3) (3) Join ({R1,R3,R4},R2) (4)Join({R2,R3,R4}, R1)中挑选。其余的对于{R1,R2,R3,R4}的执行计划都会被删掉。动态规划比最基础的方法要高效很多，因为遍历的复杂度由O(n!)变成了O(n2n -1)。
&&&
The second important aspect of System R optimizer is the
consideration of interesting orders. Let us now consider a query
that represents the join among {R1,R2,R3} with the predicates
R1.a = R2.a = R3.a. Let us also assume that the cost of the
plans for the subquery {R1,R2} are x and y for nested-loop and
sort-merge join respectively and x < y. In such a case, while
considering the plan for {R1, R2, R3}, we will not consider the
plan where R1 and R2 are joined using sort-merge. However, note
that if sort-merge is used to join R1 and R2, the result of the join is
sorted on a. The sorted order may significantly reduce the cost of
the join with R3. Thus, pruning the plan that represents the sortmerge
&&&
System R优化器第二个重要的方面是期望顺序的考虑。让我们现在考虑这样的查询，{R1,R2,R3}做连接操作然后断言R1.a = R2.a = R3.a。让我们再假设子查询{R1,R2}的耗费对于使用内层循环是归并排序的复杂度分别是x和y，并且x<y。在这种情况，在考虑{R1, R2, R3}整个查询计划的时候，我们不会考虑对R1和R2做归并操作。然而，注意如果R1和R2座归并操作，连接之后的记过就是以字段a来排好序的。这个有序性可能会显著减低跟R3连接操作的耗费。因此，修剪掉表示归并排序的执行计划会导致R1和R2对于全局最优来说的子最优。
&&&
join between R1 and R2 can result in sub-optimality of the
global plan. The problem arises because the result of the sortmerge
join between R1 and R2 has an ordering of tuples in the
output stream that is useful in the subsequent join. However, the
nested-loop join does not have such ordering. Therefore, given a
query, System R identified ordering of tuples that are potentially
consequential to execution plans for the query (hence the name
interesting orders). Furthermore, in the System R optimizer, two
plans are compared only if they represent the same expression as
well as have the same interesting order. The idea of interesting
&&&
问题出现时因为对R1和R2做归并连接的结果顺序在接下来的连接操作中会非常有用。然而，内存循环实现的连接就没有这样的有序性。System R会查出可能会被执行计划用到的有序性（因此是期望顺序这个名字）。此外，在System R优化器中，当两个执行计划同时表示相同表达式和期望顺序时才会被比较。
&&&
order was later generalized to physical properties in [22] and is
used extensively in modern optimizers. Intuitively, a physical
property is any characteristic of a plan that is not shared by all
plans for the same logical expression, but can impact the cost of
subsequent operations. Finally, note that the System-R’s approach
of taking into account physical properties demonstrates a simple
mechanism to handle any violation of the principle of optimality,
not necessarily arising only from physical properties.
Despite the elegance of the System-R approach, the framework
cannot be easily extended to incorporate other logical
transformations (beyond join ordering) that expand the search
space. This led to the development of more extensible
optimization architectures. However, the use of cost-based
optimization, dynamic programming and interesting orders
strongly influenced subsequent developments in optimization.
&&&
期望顺序的思想后面在[22]中被一般化为一个物理属性并被现代优化器广泛使用。直觉上来说，一个物理属性是任何一个计划跟其它具有同等逻辑表达式的特性，并且这个特性会影响到接下来的操作耗费的。最后，注意System R提供了一种简单的机制来把违反最有型原理纳入考虑，不只是用于物理属性。除了System R方法的优雅性，这个框架不能很容易地扩折来跟其它扩展了搜索空间的逻辑变换（在连接有序以外）集成在一起。这导致了更可扩展的优化架构的开发。然而，基于耗费的优化、动态规划和期望顺序都极强地影响了接下来优化工作的发展。
&&&

4. SEARCH SPACE
&&&
4. 搜索空间
&&&
As mentioned in Section 2, the search space for optimization
depends on the set of algebraic transformations that preserve
equivalence and the set of physical operators supported in an
optimizer. In this section, I will discuss a few of the many
important algebraic transformations that have been discovered. It
should be noted that transformations do not necessarily reduce
cost and therefore must be applied in a cost-based manner by the
enumeration algorithm to ensure a positive benefit.
&&&
在第二节中提到，优化中的搜索中间依赖于一组转换定律保证了一组优化器支持的运算符在语义上的一致。在这一届，我会讨论一些很重要的已经被发现的转换定律。需要注意的是这些转换定律不一定会降低消耗因此必须要用基于耗费的遍历算法来保证它们是有用的。
&&&
The optimizer may use several representations of a query during
the lifecycle of optimizing a query. The initial representation is
often the parse tree of the query and the final representation is an
operator tree. An intermediate representation that is also used is
that of logical operator trees (also called query trees) that captures
an algebraic expression. Figure 2 is an example of a query tree.
Often, nodes of the query trees are annotated with additional
information.
&&&
优化器可能会在一个查询的不同优化的生命周期使用不同的表示。一开始的表示一般是查询的解析树还有最后的表示是有一个运算符树。一种描述数学表达式的逻辑运算符树（也叫做查询树）的中间表示同样会被用到。Fig2就是一个查询树的例子。一般查询书的结点还会被标记额外的信息。
&&&

Some systems also use a “calculus-oriented” representation for
analyzing the structure of the query. For SPJ queries, such a
structure is often captured by a query graph where nodes
represent relations (correlation variables) and labeled edges
represent join predicates among the relations (see Figure 3).
Although conceptually simple, such a representation falls short of
representing the structure of arbitrary SQL statements in a number
of ways. First, predicate graphs only represent a set of join
predicates and cannot represent other algebraic operators, e.g.,
union. Next, unlike natural join, operators such as outerjoin are
asymmetric and are sensitive to the order of evaluation. Finally,
such a representation does not capture the fact that SQL
statements may have nested query blocks. In the QGM structure
used in the Starburst system [26], the building block is an
enhanced query graph that is able to represent a simple SQL
statement that has no nesting (“single block” query). Multi block
queries are represented as a set of subgraphs with edges among
subgraphs that represent predicates (and quantifiers) across query
blocks. In contrast, Exodus [22] and its derivatives, uniformly use
query trees and operator trees for all phases of optimization.
![fig3](./1fig3.jpg)
&&&
有些系统同时使用了一种“面向计算”的表示来分析查询的结构。对于SPJ查询，这样的结构一般会被表示成一个查询图，其中结点表示关系（关联变量）还有带标签的边来表示对于关系的连接断言（见Fig3）。尽管概念上很简单，这样的表示在一些方面会不能表达任意的SQL语句。首先，断言图只能表达一组连接断言而不能表达其他操作符，例如并操作。然后，不像自然连接，操作符例如外连接是费堆成的然后也对执行顺序敏感。最后，这样的表示不能表达含有子查询块的SSQL语句。在用于Starburst系统的QGM结构，构建块是一个改良的查询图，并且能够表示一个简单的没有子查询的查询语句。多块的查询是以一组子图加上用于子图的表来表示对于多个查询块的断言。比较起来，Exodus还有它的变体对所有阶段的优化统一地使用了查询书还有运算符树
&&&

4.1 Commuting Between Operators
&&&
4.1 运算符的交换
&&&
A large and important class of transformations exploits
commutativity among operators. In this section, we see examples
of such transformations.
&&&
不少重要的操作符变换利用了运算符的交换律。在这一节，我们会看一些这些变换的例子。
&&&
4.1.1 Generalizing Join Sequencing
&&&
4.1.1 一般化连接操作序列
&&&
In many of the systems, the sequence of join operations is
syntactically restricted to limit search space. For example, in the
System R project, only linear sequences of join operations are
considered and Cartesian product among relations is deferred until
after all the joins.
&&&
在很多系统中，连接操作的序列在语义上被限制来限制搜索空间。例如，在System R，只会考虑线性的连接操作，并且对关系的笛卡尔积会被延迟到所有的连接之后。
&&&
Since join operations are commutative and associative, the
sequence of joins in an operator tree need not be linear. In
particular, the query consisting of join among relations
R1,R2,R3,R4 can be algebraically represented and evaluated as
Join(Join(A,B),Join(C,D)). Such query trees are called
bushy, illustrated in Figure 2(b). Bushy join sequences require
materialization of intermediate relations. While bushy trees may
result in cheaper query plan, they expand the cost of enumerating
the search space considerably1. Although there has been some
studies of merits of exploring the bushy join sequences, by and
large most systems still focus on linear join sequences and only
restricted subsets of bushy join trees.
&&&
因为连接操作是可交换和可结合的，操作符树的连接序列不一定要是线性的。例如，对于关系R1,R2,R3,R4的表示和求值可以是Join(Join(A,B),Join(C,D))。这样的查询书被叫做树形的，可见Fig2。树形的连接序列需要物化和中间表。树形的运算符树可能会得到一个搞笑的执行计划，它们也把遍历搜索空间的花费变大。尽管已经有一些树形连接序列的研究，大部分系统仍然只考虑线性连接序列还有一些树形连接树的子集。
&&&

Deferring Cartesian products may also result in poor performance.
In many decision-support queries where the query graph forms a
star, it has been observed that a Cartesian product among
appropriate nodes (“dimensional” tables in OLAP terminology
[7]) results in a significant reduction in cost.
In an extensible system, the behavior of the join enumerator may
be adapted on a per query basis so as to restrict the “bushy”-ness
of the join trees and to allow or disallow Cartesian products [46].
However, it is nontrivial to determine a priori the effects of such
tuning on the quality and cost of the search.
&&&
延迟笛卡尔积可能会导致很差的性能。在很多决策支持查询中，查询图会形成一个星型，人们已经观察到一个对于适当数量结点做的笛卡尔积（用OLAP术语“维度化”的表）会导致耗费的大量减少。在一个可扩展系统中，连接遍历器的性能可以适应于每个查询，这样就能限制树形的连接树，并且可以允许和不徐云笛卡尔积。然后，根据搜索的质量和耗费来决定这种开关还是不那么容易做的。
&&&

4.1.2 Outerjoin and Join
&&&
4.1.2 外连接和连接
&&&
One-sided outerjoin is an asymmetric operator in SQL that
preserves all of the tuples of one relation. Symmetric outerjoins
preserve both the operand relations. Thus, (R LOJ S), where LOJ
designates left outerjoin between R and S, preserves all tuples of
R. In addition to the tuples from natural join, the above operation
contains all remaining tuples in R that fail to join with S (padded
with NULLs for their S attributes). Unlike natural joins, a
sequence of outerjoins and joins do not freely commute. However,
when the join predicate is between (R,S) and the outerjoin
predicate is between (S,T), the following identity holds:
Join(R, S LOJ T) = Join (R,S) LOJ T
If the above associative rule can be repeatedly applied, we obtain
an equivalent expression where evaluation of the “block of joins”
precedes the “block of outerjoins”. Subsequently, the joins may be
freely reordered among themselves. As with other
transformations, use of this identity needs to be cost-based. The
identities in [53] define a class of queries where joins and
outerjoins may be reordered.
&&&
单边的外连接是SQL中一种非对称的操作符，它会保留一个关系中的所有元组。队员的外连接保留了作为操作数的关系的所有元组。因此(R LOJ S)，这里LOJ是做外链接，保留了R的所有元组。在自然连接得到的元组的基础上，上面的操作包括了所有的R那些被过滤掉的元组（S的属性都变成是NULL）。不像自然连接一组外连接和自然连接不能随意地交换。然而，当如果对于(R,S)的外连接的断言是基于(S,T)的，下面的等式就会成立：
Join(R, S LOJ T) = Join (R,S) LOJ T
如果上面的结合律能够重复使用，我们得到了一个具有相同语义的表达式，这个表达式会在做所有外连接之前做完所有的连接。对于前面那部分，连接就可以很自由地重新排序了。就像其他变换一样，需用这些变化必须基于耗费。在[53]的等式定义了一组查询，这写查询里面，连接和外连接可以重排序。
&&&

4.1.3 Group-By and Join
&&&
4.1.3 Group-By and 连接
&&&
In traditional execution of a SPJ query with group-by, the
evaluation of the SPJ component of the query precedes the groupby.
The set of transformations described in this section enable the
group by operation to precede a join. These transformations are
applicable to queries with SELECT DISTINCT since the latter is
a special case of group-by. Evaluation of a group-by operator can
potentially result in a significant reduction in the number of
tuples, since only one tuple is generated for every partition of the
relation induced by the group-by operator. Therefore, in some
cases, by first doing the group-by, the cost of the join may be
significantly reduced. Moreover, in the presence of an appropriate
index, a group-by operation may be evaluated inexpensively. A
dual of such transformations corresponds to the case where a
group-by operator may be pulled up past a join. These
transformations are described in [5,60,25,6] (see [4] for an
overview).
&&&
在传统的带有group-by的SPJ查询的执行中，SPJ组件中的求值会先于groupby。这节描述的变换能让group by操作先于连接操作。这些变换同样适用于SELECT DISTICT因为后者是一种group-by的特殊情况。group-by操作符可以潜在地大幅度降低元组的数量，因为每个元组的分区最后最会生成一个元组。因此，在一些场景中，首先做group-by，连接的耗费可以减少很多。然而，在有合适的索引的心情宽广下，一个group-by操作也可以耗费很低。一双对应这样情况的转换可能会放在连接前。这些变换在[5,60,25,6]有阐述，（见[4]的概览）。
&&&
![fig4](./1fig4.jpg)
In this section, we briefly discuss specific instances where the
transformation to do an early group-by prior to the join may be
applicable. Consider the query tree in Figure 4(a). Let the join
between R1 and R2 be a foreign key join and let the aggregated
columns of G be from columns in R1 and the set of group-by
columns be a superset of the foreign key columns of R1. For such
a query, let us consider the corresponding operator tree in Fig.
&&&
在这一节，我们会间断地讨论几个特定的group-by可以先于连接座的具体例子。考虑Fig4(a)中的查询树。嘉定R1和R2之间的连接是基于外键的，然后聚合的属性是来自R1的，还有group-by的属性是R1外键属性的超集。对于这样的查询，让我们考虑对应Fig4(b)中的操作符树，其中G1=G。
&&&
4(b), where G1=G. In that tree, the final join with R2 can only
eliminate a set of potential partitions of R1 created by G1 but will
not affect the partitions nor the aggregates computed for the
partitions by G1 since every tuple in R1 will join with at most one
tuple in R2. Therefore, we can push down the group-by, as shown
in Fig. 4(b) and preserve equivalence for arbitrary side-effect free
aggregate functions. Fig. 4(c) illustrates an example where the
&&&
在这棵树中，最后跟R2的连接可以减少位R1的潜在分区数，这组分区由G1创建但不会影响到分袂和聚合计划，因为对于所有的R1中的元组，最多只会和R2中元组连接一次。因此，我们可以把group-by下一，就如Fig4(b)一样。这对于所有没有副作用的聚合函数可以保证语义一直。
&&&
transformation introduces a group-by and represents a class of
useful examples where the group-by operation is done in stages.
For example, assume that in Fig. 4(a), where all the columns on
which aggregated functions are applied are from R1. In these
cases, the introduced group-by operator G1 partitions the relation
on the projection columns of the R1 node and computes the
aggregated values on those partitions. However, the true partitions
in Fig 4(a) may need to combine multiple partitions introduced by
G1 into a single partition (many to one mapping). The group-by
&&&
Fig4(c)阐述了一个变换过程引入多一个group-by的例子，代表了一类很有用的把group-by操作分成做个阶段做的情况。例如，假设在Fig4(a)中，所有聚合函数用到的属性都来自于R1。在这种情况中，新增的group-by操作符G1以R1投影的属性来做分区，然后计算这些分区的聚合值。然而，Fig4(a)中真正的分区可能需要结合G1引入的多个分区成为一个分区（多到一映射）。
&&&
operator G ensures the above. Such staged computation may still
be useful in reducing the cost of the join because of the data
reduction effect of G1. Such staged aggregation requires the
aggregating function to satisfy the property that Agg(S U S’)
can be computed from Agg(S) and Agg(S’). For example, in
order to compute total sales for all products in each division, we
can use the transformation in Fig. 4(c) to do an early aggregation
and obtain the total sales for each product. We then need a
subsequent group-by that sums over all products that belong to
each division.
&&&
G这个group-by操作符保证了这一点。这样的一步计算对于降低连接的耗费可能仍然非常有效，因为G1减少了数据的量。这个阶段的聚合要求聚合函数满足Agg(S U S’)可以由Agg(S)和Agg(S’)计算得到的特性。例如在一次除法中为了计算所有销售额的总量，我们可以使用Fig4(c)中的变换来做早起的聚合来获取每个产品的销售额。我们然后需要进一步的group-by来求和所有对于每个除法的总额。
&&&

4.2 Reducing Multi-Block Queries to Single-Block
&&&
4.2 减少多块查询成为单块查询
&&&
The technique described in this section shows how under some
conditions, it is possible to collapse a multi-block SQL query into
a single block SQL query.
&&&
这节描述的技术展示了在一些情况下，可能可以把多块的SQL查询变成单块的SQL查询。
&&&

4.2.1 Merging Views
&&&
4.2.1 合并试图
&&&
Let us consider a conjunctive query using SELECT ANY. If one
or more relations in the query are views, but each is defined
through a conjunctive query, then the view definitions can simply
be “unfolded” to obtain a single block SQL query. For example, if
a query Q = Join(R,V) and view V = Join(S,T), then the
query Q can be unfolded to Join(R,Join(S,T)) and may be
freely reordered. Such a step may require some renaming of the
variables in the view definitions.
&&&
让我们考虑使用SELECT ANY的连接查询。如果查询中一个或多个关系是试图，但是每一个都通过联合查询来定义，那么试图定义可以很简单地站到到一个单块的SQL查询。例如，如果一个查询Q = Join(R,V)还有试图V = Join(S,T)，然后查询Q可以斩块成Join(R,Join(S,T))然后可以自由地重排序。这样的一步可能需要对视图中的变量做重命名。
&&&
Unfortunately, this simple unfolding fails to work when the views
are more complex than simple SPJ queries. When one or more of
the views contain SELECT DISTINCT, transformations to move
or pull up DISTINCT need to be careful to preserve the number
of duplicates correctly, [49]. More generally, when the view
contains a group by operator, unfolding requires the ability to
pull-up the group-by operator and then to freely reorder not only
the joins but also the group-by operator to ensure optimality. In
particular, we are given a query such as the one in Fig. 4(b) and
we are trying to consider how we can transform it in a form such
as Fig. 4(a) so that R1 and R2 may be freely reordered. While the
transformations in Section 4.1.3 may be used in such cases, it
underscores the complexity of the problem [6].
&&&
不幸的是，当这种视图是比简单SPJ查询更复杂时，这种简单的展开就不能工作了。当一个或多个视图包含SELECT DISTINCT的时候，延后DISTINCT的转换需要很小心地正确保持重复元组，[49]。更一般的，当视图包含了一个group by操作符，展开操作需要提前group-by操作符然后自由地重排连接和group-by操作符的能力以保证能够做优化。更确切的，给定一个Fig4(b)的查询然后我们尝试把它转换成Fig4(a)，这样R1和R2就可能自由地重排序。虽然4.1.3中的转换可以用于这样的情况，但是它会把问题搞复杂。
&&&

4.2.2 Merging Nested Subqueries
&&&
4.2.2 合并内存子查询
&&&
Consider the following example of a nested query from [13]
where Emp# and Dept# are keys of the corresponding relations:
SELECT Emp.Name
FROM Emp
WHERE Emp.Dept# IN
SELECT Dept.Dept# FROM Dept
WHERE Dept.Loc=‘Denver’
AND Emp.Emp# = Dept.Mgr
&&&
考虑这样一个内存子查询的例子，其中Emp#和Dept#是对应关系的属性：
SELECT Emp.Name
FROM Emp
WHERE Emp.Dept# IN
SELECT Dept.Dept# FROM Dept
WHERE Dept.Loc=‘Denver’
AND Emp.Emp# = Dept.Mgr
&&&
If tuple iteration semantics are used to answer the query, then the
inner query is evaluated for each tuple of the Dept relation once.
An obvious optimization applies when the inner query block
contains no variables from the outer query block (uncorrelated).
In such cases, the inner query block needs to be evaluated only
once. However, when there is indeed a variable from the outer
block, we say that the query blocks are correlated. For example,
in the query above, Emp.Emp# acts as the correlated variable.
Kim [35] and subsequently others [16,13,44] have identified
techniques to unnest a correlated nested SQL query and “flatten”
it to a single query. For example, the above nested query reduces
to: SELECT E.Name
FROM Emp E, Dept D
WHERE E.Dept# = D.Dept#
AND D.Loc = ‘Denver’ AND E.Emp# = D.Mgr
&&&
如果以元组的迭代语义用来回答这个查询，那么内层的查询对于每个Dept关系的元组都会求值一次。当内层循环完全不包含外层查询的变量时，可以得到一种很明显的优化（不相关的）。在这种情况，内存查询只需要被求值一次。然而如果内存循环真的有外层循环的变量，我们称之为查询块是相关的。比如，在上面的查询中Emp.Emp#就作为关联变量。Kim [35] 和后面的一些工作 [16,13,44]已经找到了一些技术来解开嵌套的SQL查询然后把它们压扁到单个查询。例如，上面的多层查询可以变成
SELECT E.Name
FROM Emp E, Dept D
WHERE E.Dept# = D.Dept#
AND D.Loc = ‘Denver’ AND E.Emp# = D.Mgr
&&&
Dayal [13] was the first to offer an algebraic view of unnesting.
The complexity of the problem depends on the structure of the
nesting, i.e., whether the nested subquery has quantifiers (e.g.,
ALL, EXISTS), aggregates or neither. In the simplest case, of
which the above query is an example, [13] observed that the tuple
semantics can be modeled as Semijoin(Emp,Dept,
Emp.Dept# = Dept.Dept#)2. Once viewed this way, it is
not hard to see why the query may be merged since:
Semijoin(Emp,Dept,Emp.Dept# = Dept. Dept#) =
Project(Join(Emp,Dept), Emp.*)
&&&
Dayal [13]是第一个提出了解多层循环的公式。问题复杂程度就看嵌套的结构，例如内套子查询是否包含两次（比如ALL,EXISTS），聚合或者都不包含。在最简单的情况，上面的查询就是例子，[13]发现元组的语义可以用Semijoin(Emp,Dept,
Emp.Dept# = Dept.Dept#)2来模拟。一旦以这个方式来看，不容易会发现为什么查询可以这样被合并，因为
Semijoin(Emp,Dept,Emp.Dept# = Dept. Dept#) = Project(Join(Emp,Dept), Emp.*)
&&&
Where Join(Emp,Dept) is on the predicate Emp.Dept# =
Dept. Dept# . The second argument of the Project operator3
indicates that all columns of the relation Emp must be retained.
The problem is more complex when aggregates are present in the
nested subquery, as in the example below from [44] since merging
query blocks now requires pulling up the aggregation without
violating the semantics of the nested query:
SELECT Dept.name
FROM Dept
WHERE Dept.num-of-machines ≥
(SELECT COUNT(Emp.*) FROM Emp
WHERE Dept.name= Emp.Dept_name)
&&&
其中Join(Emp,Dept)是以Emp.Dept# = Dept. Dept#断言做连接。Project操作符3的第二个参数指明了Emp的所有列都需要被保留。当聚合出现在子查询问题会变得更祖发，就如来自[44]中的例子，因为现在合并查询块需要把聚合提出来但又不会违反多层查询的语义。
SELECT Dept.name
FROM Dept
WHERE Dept.num-of-machines ≥
(SELECT COUNT(Emp.*) FROM Emp
WHERE Dept.name= Emp.Dept_name)
&&&
It is especially tricky to preserve duplicates and nulls. To
appreciate the subtlety, observe that if for a specific value of
Dept.name (say d), there are no tuples with a matching
Emp.Dept_name, i.e., even if the predicate Dept.name=
Emp.dept_name fails, then there is still an output tuple for the
Dept tuple d. However, if we were to adopt the transformation
used in the first query of this section, then there will be no output
tuple for the dept d since the join predicate fails. Therefore, in
the presence of aggregation, we must preserve all the tuples of the
outer query block by a left outerjoin. In particular, the above
query can be correctly transformed to:
SELECT Dept.name FROM Dept LEFT OUTER JOIN Emp
ON (Dept.name= Emp.dept_name )
GROUP BY Dept.name
HAVING Dept. num-of-machines < COUNT (Emp.*)
&&&
保留重复的NULL会更加的取巧。为了考察其中精妙之处，假设对于某个Dept.name值（设为d），没有对应的Emp.Dept_name，就是说， 尽管Dept.name = Emp.dept_name的断言没有通过，对于元组d仍然会有一个输出。然而，如果我们使用这节第一个查询用到的变换，这样就不会有d的输出，因为连接的断言没有通过。因此，为了保留聚合，我们必须用一个左外连接保留所有外查询的元组。更确切地说，上面的查询可以被正确地转换为：
SELECT Dept.name FROM Dept LEFT OUTER JOIN Emp
ON (Dept.name= Emp.dept_name )
GROUP BY Dept.name
HAVING Dept. num-of-machines < COUNT (Emp.*)
&&&
Thus, for this class of queries the merged single block query has
outerjoins. If the nesting structure among query blocks is linear,
then this approach is applicable and transformations produce a
single block query that consists of a linear sequence of joins and
outerjoins. It turns out that the sequence of joins and outerjoins is
such that we can use the associative rule described in Section
4.1.2 to compute all the joins first and then do all the outerjoins in
sequence. Another approach to unnesting subqueries is to
transform a query into one that uses table-expressions or views
(and therefore, not a single block query). This was the direction of
Kim’s work [35] and it was subsequently refined in [44].
&&&
因此，对于这种查询，合并出来的单块查询会有外连接。如果内存查询中的查询块是线性的，那么这个方式可以适合并产生一个包含线性连接和外连接的单块查询。这样我们就会发现，这些连接和外连接查询可以用到4.1.2节讲到的利用结合律技巧去先计算所有连接然后再是外连接。另外一种展开子查询的方法是把一个查询转换成一个使用表表达式和试图的查询（也因此不是一个单块查询）。这是Kim的工作[35]然后接下来在[44]得到完善。
&&&

4.3 Using Semijoin Like Techniques for
Optimizing Multi-Block Queries
&&&
43 使用类Semijoin的技术来优化多块查询。
&&&
In the previous section, I presented examples of how multi-block
queries may be collapsed in a single block. In this section, I
discuss a complementary approach. The goal of the approach
described in this section is to exploit the selectivity of predicates
across blocks.4 It is conceptually similar to the idea of using
semijoin to propagate from a site A to a remote site B information
on relevant values of A so that B sends to A no unnecessary
tuples. In the context of multi-block queries, A and B are in
different query blocks but are parts of the same query and
therefore the transmission cost is not an issue. Rather, the
information “received from A” is used to reduce the computation
needed in B as well as to ensure that the results produced by B are
relevant to A as well. This technique requires introducing new
table expressions and views. For example, consider the following
query from [56]:
&&&
在前面的一节，我们展示了一些多块查询如果被折叠成单块的例子。在这一节，我会讨论一种互补的方法。这节讨论得方法的目标是利用不同块中断言的选择性4。概念上着类似于用semijoin来从位置A到远处的位置B传递A相关的信息，这样B向A传了不需要的元组。在多块查询中，A和B是在不同的查询快但是是同一个查询的不同部分，因此传输耗费不是一个问题。然而，来自A的信息用于减少B的计算，同时保证了B产出的结果是跟A相关的。这种技术需要增加新的表表达式和试图。例如考虑来自[56]的这样一个查询
&&&
CREATE VIEW DepAvgSal As (
SELECT E.did, Avg(E.Sal) AS avgsal
FROM Emp E
GROUP BY E.did)
SELECT E.eid, E.sal
FROM Emp E, Dept D, DepAvgSal V
WHERE E.did = D.did AND E.did = V.did
AND E.age < 30 AND D.budget > 100k
AND E.sal > V.avgsal
&&&
CREATE VIEW DepAvgSal As (
SELECT E.did, Avg(E.Sal) AS avgsal
FROM Emp E
GROUP BY E.did)
SELECT E.eid, E.sal
FROM Emp E, Dept D, DepAvgSal V
WHERE E.did = D.did AND E.did = V.did
AND E.age < 30 AND D.budget > 100k
AND E.sal > V.avgsal
&&&
The technique recognizes that we can create the set of relevant
E.did by doing only the join between E and D in the above
query and projecting the unique E.did. This set can be passed to
the view DepAvgSal to restrict its computation. This is
accomplished by the following three views.
&&&
这个技术识别出在上述的查询和对E.did的唯一投影钟，我们可以通过连接E和D来创建E.did的集和。这个集和可以传给DepAvgSal试图来减少计算量。这使用了下面三个视图来完成：
&&&
CREATE VIEW partialresult AS
(SELECT E.id, E.sal, E.did
FROM Emp E, Dept D
WHERE E.did=D.did AND E.age < 30
AND D.budget > 100k)
CREATE VIEW Filter AS
(SELECT DISTINCT P.did FROM PartialResult P)
CREATE VIEW LimitedAvgSal AS
(SELECT E.did, Avg(E.Sal) AS avgsal
FROM Emp E, Filter F
WHERE E.did = F.did GROUP BY E.did)
&&&
CREATE VIEW partialresult AS
(SELECT E.id, E.sal, E.did
FROM Emp E, Dept D
WHERE E.did=D.did AND E.age < 30
AND D.budget > 100k)
CREATE VIEW Filter AS
(SELECT DISTINCT P.did FROM PartialResult P)
CREATE VIEW LimitedAvgSal AS
(SELECT E.did, Avg(E.Sal) AS avgsal
FROM Emp E, Filter F
WHERE E.did = F.did GROUP BY E.did)
&&&

The reformulated query on the next page exploits the above views
to restrict computation.
SELECT P.eid, P.sal
FROM PartialResult P, LimitedDepAvgSal V
WHERE P.did = V.did AND P.sal > V.avgsal
&&&
下页被重写的查询使用了上面的试图来减少计算量。
SELECT P.eid, P.sal
FROM PartialResult P, LimitedDepAvgSal V
WHERE P.did = V.did AND P.sal > V.avgsal
&&&
The above technique can be used in a multi-block query
containing view (including recursive view) definitions or nested
subqueries [42,43,56,57]. In each case, the goal is to avoid
redundant computation in the views or the nested subqueries. It is
also important to recognize the tradeoff between the cost of
computing the views (the view PartialResult in the example
above) and use of such views to reduce the cost of computation.
The formal relationship of the above transformation to semijoin
has recently been presented in [56] and may form the basis for
integration of this strategy in a cost-based optimizer. Note that a
degenerate application of this technique is passing the predicates
across query blocks instead of results of views. This simpler
technique has been used in distributed and heterogeneous
databases and generalized in [36].
&&&
以上的技术可以用于包含视图（包括递归视图）的多块查询或者多层子查询[42,43,56,57]。在每个情况中，目标都是减少试图或者多层子查询的冗余计算。同时我们也要一是到计算这些视图（上面例子中的PartialResult）和使用这样的试图来减少计算量的权衡。上述沌河和semijoin的正式关系已经被展示在[56]中，并且已经被结合于基于耗费的优化器中。注意这种技术的一种退化应用是传递断言到查询快而不是试图。这种简单的技术已经被用于分布式和混合型的数据库，并且在[36]得到一般化阐述。
&&&

5. STATISTICS AND COST ESTIMATION
&&&
5. 统计和耗费的估计
&&&
Given a query, there are many logically equivalent algebraic
expressions and for each of the expressions, there are many ways
to implement them as operators. Even if we ignore the
computational complexity of enumerating the space of
possibilities, there remains the question of deciding which of the
operator trees consumes the least resources. Resources may be
CPU time, I/O cost, memory, communication bandwidth, or a
combination of these. Therefore, given an operator tree (partial or
complete) of a query, being able to accurately and efficiently
evaluate its cost is of fundamental importance. The cost
estimation must be accurate because optimization is only as good
as its cost estimates. Cost estimation must be efficient since it is
in the inner loop of query optimization and is repeatedly invoked.
The basic estimation framework is derived from the System-R
approach:
&&&
给定一个查询，它有很多逻辑上相等的表达式，然后又有很多操作符可以实现。就算我们忽略了遍历搜索空间的计算复杂度，仍有有着如何决定那种操作符树才是耗费资源最好的。资源可以是CPU时间，IO耗费，内存，传输带块或者是它们中一些的组合。因此，给定一个操作符树（部分或者是完整的），精确且高效地计算它们的耗费是基础且重要的。耗费估算要精确因为优化出来的情况就是估算的情况。耗费估算必须高效因为它是查询优化器中最内层的循环体，然后会被不停地运行。最基础的耗费估算框架由System-R衍生而来：
&&&
1. Collect statistical summaries of data that has been stored.
2. Given an operator and the statistical summary for each of its
input data streams, determine the:
(a) Statistical summary of the output data stream
(b) Estimated cost of executing the operation
&&&
1. 收集已经被存储好的统计概述。
2. 给定一个操作符和对于每个输入流的统计概述，决定：
(a) 输出数据流的统计概览
(b) 执行操作的耗费估算
&&&
Step 2 can be applied iteratively to an operator tree of arbitrary
depth to derive the costs for each of its operators. Once we have
the costs for each of the operator nodes, the cost for the plan may
be obtained by combining the costs of each of the operator nodes
in the tree. In Section 5.1, we discuss the statistical parameters
for the stored data that are used in cost optimization and efficient
ways of obtaining such statistical information. We also discuss
how to propagate such statistical information. The issue of
estimating cost for physical operators is discussed in Section 5.2.
&&&
步骤2可以重复地用于操作符树的任意深度来计算每个操作符的耗费。一旦我们有了每个操作符结点的耗费，整个执行计划的耗费就可以通过结合每个操作符的耗费来得出。在5.1节中，我们讨论被存储的用于耗费优化的统计参数还有高效获取这些统计信息的方法。我们同样讨论如何传递这些统计信息。5.2节会讨论估算物理操作符耗费的问题。
&&&
It is important to recognize the differences between the nature of
the statistical property and the cost of a plan. The statistical
property of the output data stream of a plan is the same as that of
any other plan for the same query, but its cost can be different
from other plans. In other words, statistical summary is a logical
property but the cost of a plan is a physical property.
&&&
同时也要意识到统计属性和执行计划耗费的不同之处。一个执行计划的输出流和统计属性对于同个查询的其它执行计划都是一样的，但这些执行计划之前会不一样。换句话说，统计概览是一种逻辑属性但执行计划的耗费是一种物理属性。
&&&

5.1 Statistical Summaries of Data
5.1.1 Statistical Information on Base Data
&&&
5.1 数据的统计橄榄
5.1.1 基础数据的统计信息
&&&
For every table, the necessary statistical information includes the
number of tuples in a data stream since this parameter determines
the cost of data scans, joins, and their memory requirements. In
addition to the number of tuples, the number of physical pages
used by the table is important. Statistical information on columns
of the data stream is of interest since these statistics can be used to
estimate the selectivity of predicates on that column. Such
information is created for columns on which there are one or more
indexes, although it may be created on demand for any other
column as well.
&&&
对于每一张表，必要的统计信息包括元组的数量因为这个参数会决定扫描，连接还有其他需要内存操作的规模。此外还有物理页的数量也是很重要的。数据流中对列的统计信息也值得注意因为这些数据会用于估算对于这些列的断言的选择性。如果这些列有一个或多个索引，这样的信息就会被计算，尽管其它列可能也会按需计算。
&&&

In a large number of systems, information on the data distribution
on a column is provided by histograms. A histogram divides the
values on a column into k buckets. In many cases, k is a constant
and determines the degree of accuracy of the histogram. However,
k also determines the memory usage, since while optimizing a
query, relevant columns of the histogram are loaded in memory.
There are several choices for “bucketization” of values. In many
database systems, equi-depth (also called equi-height) histograms
are used to represent the data distribution on a column. If the table
&&&
在不少系统中，对某列的数据分布信息会以柱状图来表示。一个主张图把列中的值分为可k个桶。在很多情况下，k是一个常数然后决定了柱状图的精确度。然而，k同时也决定了内存的使用因为在优化查询的时候，相关列的柱状图会读入内存。还有很多对值得桶化操作。在很多数据库系统中等高柱状图也会用来表示列的数据分布。
&&&
has n records and the histogram has k buckets, then an equi-depth
histogram divides the set of values on that column into k ranges
such that each range has the same number of values, i.e., n/k.
Compressed histograms place frequently occurring values in
singleton buckets. The number of such singleton buckets may be
tuned. It has been shown in [52] that such histograms are effective
for either high or low skew data. One aspect of histograms
relevant to optimization is the assumption made about values
within a bucket. For example, in an equi-depth histogram, values
&&&
如果一张表有n个记录然后柱状图有k个桶，然后一个等高柱状图把列的数据分成了k个区间，并且每个区间含有相同数量的值，就是说n/k。亚索的柱状图把经常出现的数据放入一个单值桶中。这个单值桶的数量可以调节。[52]中已经表明这样的等高徒对于高或低的非对称数据都很搞笑。柱状图用于优化的其中一个方面是基于桶中数据的假设。例如在一个等高柱状图中，
&&&
within the endpoints of a bucket may be assumed to occur with
uniform spread. A discussion of the above assumption as well as a
broad taxonomy of histograms and ramifications of the histogram
structures on accuracy appears in [52]. In the absence of
histograms, information such as the min and max of the values in
a column may be used. However, in practice, the second lowest
and the second highest values are used since the min and max
have a high probability of being outlying values. Histogram
information is complemented by information on parameters such
as number of distinct values on that column
&&&
前后两点中的数值分布是均匀分布的。[52]中讨论了上述假设和柱状图的宽度分类和柱状图精度结果。在缺少柱状图的时候，像最大最小值这样的信息就会被使用到。然而在实践中，第二最小和第二最高会被使用因为最大最小值会很有可能夸大了数值的实际情况。柱状图信息也会和一些参数信息互补，例如列中唯一值得数量。
&&&
Although histograms provide information on a single column,
they do not provide information on the correlations among
columns. In order to capture correlations, we need the joint
distribution of values. One option is to consider 2-dimensional
histograms [45,51]. Unfortunately, the space of possibilities is
quite large. In many systems, instead of providing detailed joint
distribution, only summary information such as the number of
distinct pairs of values is used. For example, the statistical
information associated with a multi-column index may consist of
a histogram on the leading column and the total count of distinct
combinations of column values present in the data.
&&&
尽管柱状图提供了单列的信息，他们不提供各列的相关性信息。为了抓住这些相关性，我们需要数值的相关分布。一种做法是考虑二维柱状图[45,51]。不幸的是，占用空间可能会非常大。在很多系统中，只有一些概览信息例如唯一的二元组数量会被使用，而不是提供一个很细节的相关分布。例如，数据中由关键列和唯一多列元组组成的多列索引的统计信息。
&&&

5.1.2 Estimating Statistics on Base Data
&&&
5.1.2 基础数据的统计估算
&&&
Enterprise class databases often have large schema and also have
large volumes of data. Therefore, to have the flexibility of
obtaining statistics to improve accuracy, it is important to be able
to estimate the statistical parameters accurately and efficiently.
Sampling data provides one possible approach. However, the
challenge is to limit the error in estimation. In [48], Shapiro and
Connell show that for a given query, only a small sample is
needed to estimate a histogram that has a high probability of being
accurate for the given query. However, this misses the point since
the goal is to build a histogram that is reasonably accurate for a
large class of queries. Our recent work has addressed this
problem [11]. We have also shown that the task of estimating
distinct values is provably error prone, i.e., for any estimation
scheme, there exists a database where the error is significant. This
result explains the past difficulty in estimation of the number of
distinct values [50,27]. Recent work has also addressed the
problem of maintaining statistics in an incremental fashion [18].
&&&
企业级的数据一般会有很大的表和大量的数据。因此为了灵活地获取统计数据以提高精度，精确且高效地估算统计参数也是很重要的。采样提供了一种可能的办法。然而挑战在于减少估算中的误差。在[48]中，Shapiro和Connell展示了对于给定的查询，值需要很小的采样就可以有很大的可能可以精确地或者给定查询的估算柱状图。然而这走偏了，因为我们的不妙是构建一个用于大量查询的相当精确的柱状图。我们现在的工作已经解决了这个问题[11]。我们也展示了计算唯一值被证明是很容易出错的，例如对于任意的表估算，可能有个数据库会错得很离谱。这回导致估算谓一致的困难，[50,27]。现在的工作已经使用了增量的办法来维护统计数据。
&&&

5.1.3 Propagation of Statistical Information
&&&
5.1.3 统计信息的传递
&&&
It is not sufficient to use information only on base data because a
query typically contains many operators. Therefore, it is important
to be able to propagate the statistical information through
operators. The simplest case of such an operator is selection. If
there is a histogram on a column A and the query is a simple
selection on column A, then the histogram can be modified to
reflect the effect of the selection. Some inaccuracy results in this
step due to assumptions such as uniform spread that needs to be
made within a bucket. Moreover, the inability to capture
correlation is a key source of error. In the above example, this will
be reflected in not modifying the distribution of other attributes
on the table (except A) and thus incurring potentially significant
errors in subsequent operators. Likewise, if multiple predicates are
present, then the independence assumption is made and the
product of the selectivity is considered. However, some systems
only use the selectivity of the most selective predicate and can
also identify potential correlation [17]. In the presence of
histograms on columns involved in a join predicate, the
histograms may be “joined”. However, this raises the issue of
aligning the corresponding buckets. Finally, when histogram
information is not available, then ad-hoc constants are used to
estimate selectivity, as in [55].
&&&
使用基础数据是不够的，因为一个查询一般会包含很多操作符。因此通过操作符传递统计数据很重要。最简单的情况是选择操作符。如果有一个关于列A的柱状图然后查询是一个很简单的对A的选择，那么柱状图就可以被修改为对选择的反应。这一步会有些不准确，因为认为桶中的数据是均匀分布的。并且，不能去抓住相关性也容易导致错误。在上述例子中，这回反应为没有修改表中其他属性（除了A）的分布，然后会导致接下来操作符的严重错误。类似，如果出现了多个断言，然后断言间就会有独立性的假设，然后选择性就用乘法来计算。然而，一些系统只使用了能筛得最多的少悬浮来计算，然后也能识别出潜在的相关性[17]。在有涉及连接断言的柱状图时，柱状图可以被“连接”。然而这会引出对应桶分布的问题。最后，当柱状体信息拿不到，一个常数会用来估算选择性。
&&&

5.2 Cost Computation
&&&
5.2 耗费计算
&&&
The cost estimation step tries to determine the cost of an
operation. The costing module estimates CPU, I/O and, in the
case of parallel or distributed systems, communication costs. In
most systems, these parameters are combined into an overall
metric that is used for comparing alternative plans. The problem
of choosing an appropriate set of to determine cost requires
considerable care. An early study [40] identified that in addition
to the physical and statistical properties of the input data streams
and the computation of selectivity, modeling buffer utilization
plays a key role in accurate estimation. This requires using
different buffer pool hit ratios depending on the levels of indexes
as well as adjusting buffer utilization by taking into account
properties of join methods, e.g., a relatively pronounced locality
of reference in an index scan for indexed nested loop join [17].
Cost models take into account relevant aspects of physical design,
e.g., co-location of data and index pages. However, the ability to
do accurate cost estimation and propagation of statistical
information on data streams remains one of the difficult open
issues in query optimization.
&&&
耗费估算步骤会尝试去计算操作的耗费。耗费模块估算CPU，IO和分布式系统中的交流耗费。在大部分系统中，这些参数会被结合成一个综合信息并且被用来比较候选的执行计划。问题主要是如何选择估算参数的寄来。一个早期的件数[40]发现除了统计得到的输入数据物理数据还有选择性的计算，模拟缓存使用也很重要。这对于不同级别的索引需要使用不同的缓冲池命中率同时需要通过把这些属性纳入连接方法来提纵横缓冲区的使用，例如内层索引循环中索引的局部性[17]。耗费模型吧物理设计也纳入考虑，例如数据物理上的分布还有索引页。然而，耗费的精确估算还有数据流统计信息的传递仍然是查询优化中的很难的问题。
&&&

6. ENUMERATION ARCHITECTURES
&&&
6. 遍历操作的架构
&&&
An enumeration algorithm must pick an inexpensive execution
plan for a given query by exploring the search space. The System-
R join enumerator that we discussed in Section 3 was designed to
choose only an optimal linear join order. A software engineering
consideration is to build the enumerator so that it can gracefully
adapt to changes in the search space due to the addition of new
transformations, the addition of new physical operators (e.g., a
new join implementation) and changes in the cost estimation
techniques. More recent optimization architectures have been
built with this paradigm and are called extensible optimizers.
&&&
一个遍历算法必须通过搜索搜索空间来找出给定查询耗费低的执行计划。我们在第三节讨论得System-R连接遍历器是被设计来选择一个最优的线性连接顺序。一个软件工程考虑是去构建这样一个遍历器，它能很优雅地适应搜索空间的修改因为会加新的变换还有新的物理操作符（例如新的连接实现）还有耗费估计技术的改变。现在的架构已经是以这种方式来做的，被称为可扩展优化器。
&&&
Building an extensible optimizer is a tall order since it is more
than simply coming up with a better enumeration algorithm.
Rather, they provide an infrastructure for evolution of optimizer
design. However, generality in the architecture must be balanced
with the need for efficiency in enumeration.
&&&
构建一个可扩展的优化器是一个高级的任务因为这病不是简单的提出一种更好的遍历算法。而是，他们提供了一种便于优化器金华的基础设施。然而，架构的一般性和性能必须被很好地权衡。
&&&
We focus on two representative examples of such extensible
optimizers: Starburst and Volcano/Cascades briefly. Despite their
differences, we can summarize some of the commonality in them:
(a) Use of generalized cost functions and physical properties with
operator nodes. (b) Use of a rule engine that allows
transformations to modify the query expression or the operator
trees. Such rule engines also provide the ability to direct search to
achieve efficiency. (c) Many exposed “knobs” that can be used to
tune the behavior of the system. Unfortunately, setting these
knobs for optimal performance is a daunting task
&&&
我们着重考虑两个这样的可扩展优化器的代表：Starburst and Volcano/Cascades。不考虑他们的不同，我们可以总结一些他们的相同点。（a）使用了一般化的耗费函数还有带有物理试行的操作符。（b）使用了一个规则引擎来让变换个罪恶去修改查询表达式或者操作符树。这样的规则引擎同时也提高了直接搜索的效率。（c）很多暴露出来的“旋钮”可以用于调节系统的行为。不幸的是，设置这些旋钮来优化性能是一个令人畏惧的工作。
&&&

6.1 Starburst
&&&
6.1 Starburst
&&&
Query optimization in the Starburst project [26] at IBM Almaden
begins with a structural representation of the SQL query that is
used throughout the lifecycle of optimization. This representation
is called the Query Graph Model (QGM). In the QGM, a box
represents a query block and labeled arcs between boxes represent
table references across blocks. Each box contains information on
the predicate structure as well as on whether the data stream is
ordered. In the query rewrite phase of optimization [49], rules are
used to transform a QGM into another equivalent QGM. Rules are
modeled as pairs of arbitrary functions. The first one checks the
&&&
在IBM Almaden的Starburst project [26]的查询优化器开始执行在SQL查询的结构化表示，这会用于整个优化的生命周期。这种表示被称为Query Graph Model (QGM)。在QGM中，一个盒子代表了一个查询快并且在盒子之间用狐仙来表示跨块的表引用。每个盒子包含断言结构还有数据流的有序性。在优化的查询重写阶段[49]，规则用于转换一个QGM到另一个等价的QGM规则以一对任意的函数来表示。
&&&
condition for applicability and the second one enforces the
transformation. A forward chaining rule engine governs the rules.
Rules may be grouped in rule classes and it is possible to tune the
order of evaluation of rule classes to focus search. Since any
application of a rule results in a valid QGM, any set of rule
applications guarantee query equivalence (assuming rules
themselves are valid). The query rewrite phase does not have the
cost information available. This forces this module to either retain
alternatives obtained through rule application or to use the rules in
a heuristic way (and thus compromise optimality).
&&&
第一个用于检查是否可以使用，第二个用于做转换。一个向前的链接起来的规则引擎来管理这些规则。规则是以规则类来分组的并且可以调节某些搜索的规则优先级。因为任何这些规则的使用会得到一个合法的QGM，任何规则应用的集合保证了查询语义的不变形（假设规则本身是合法的）。这个规则重写阶段不会有任何可用的耗费信息。这要求了这个模块要么通过规则应用保留可选项，要么以一种启发式的方法来使用这些规则（妥协了优化）。
&&&

The second phase of query optimization is called plan
optimization. In this phase, given a QGM, an execution plan
(operator tree) is chosen. In Starburst, the physical operators
(called LOLEPOPs) may be combined in a variety of ways to
implement higher level operators. In Starburst, such combinations
are expressed in a grammar production-like language [37]. The
realization of a higher-level operation is expressed by its
derivation in terms of the physical operators. In computing such
derivations, comparable plans that represent the same physical
and logical properties but have higher costs, are pruned. Each
plan has a relational description that corresponds to the algebraic
expression it represents, an estimated cost, and physical properties
(e.g., order). These properties are propagated as plans are built
bottom-up. Thus, with each physical operator, a function is
associated that shows the effect of the physical operator on each
of the above properties. The join enumerator in this system is
similar to System-R’s bottom-up enumeration scheme.
&&&
查询优化的第二阶段叫做执行计划优化，在这个阶段中，给定了一个QGM，一个执行计划（操作符树）会被选中。在StarBusrst中，一个物理执行计划（称为LOLEPOPs）可能会以多种方式组合起来去实现更高级的操作符。在Starburst，这样的组合是以类似于文法规则的语言来表示的[37]。在物理操作符的说法来讲，高级操作符的实现是用他们的变形来表示的。在计算这样的变形时，用于比较的执行计划代表了相同的物理和逻辑试行但是会有更高稿费的会被兼职。每个执行计划会有一个关系型的表述对应于他们的数学表示，即耗费估计还有物理属性（例如有序性）。这些属性会随着执行计划以自底向上传递。因此，对于每一个物理操作符，一个函数是可结合的，展示了物理操作符对于上述属性的影响。在这个系统中的连接遍历器类似于System-R的自底向上模式。
&&&

6.2 Volcano/Cascades
&&&
6.2 Volcano/Cascades
&&&
The Volcano [23] and the Cascades extensible architecture [21]
evolved from Exodus [22]. In these systems, rules are used
universally to represent the knowledge of search space. Two kinds
of rules are used. The transformation rules map an algebraic
expression into another. The implementation rules map an
algebraic expression into an operator tree. The rules may have
conditions for applicability. Logical properties, physical
properties and costs are associated with plans. The physical
properties and the cost depend on the algorithms used to
implement operators and its input data streams. For efficiency,
&&&
Volcano[23]和Cascades的可扩展架构源于Exodus [22]。在这些系统中，规则被通用地表示搜索空间的知识。两种类型的规则会被用到。变换规则映射一个涮书表达式到另外一个。实现规则映射一个属性表达式到一个操作符树。这些规则可能会有可应用的条件。逻辑属性和物理属性和耗费都和执行计划结合在一起。梳理属性还有基于耗费的算法被用于实现操作符还有他们的输入数据流。
&&&
Volcano/Cascades uses dynamic programming in a top-down way
(“memoization”). When presented with an optimization task, it
checks whether the task has already been accomplished by
looking up its logical and physical properties in the table of plans
that have been optimized in the past. Otherwise, it will apply a
logical transformation rule, an implementation rule, or use an
enforcer to modify properties of the data stream. At every stage, it
uses the promise of an action to determine the next move. The
promise parameter is programmable and reflects cost parameters.
&&&
为了效率Volcano/Cascades使用了动态规划来以一种自顶向下的方法（“记忆搜索”）。当给定一个优化任务，它会检查任务是否已经完成，通过查看之前已经做过优化的执行计划表来完成。另外，它会应用一个逻辑转换规则，一个实现规则或者修改数据流的属性。在每个阶段，它会使用操作的保证来决定下一个动作。保证参数是可编程的并且会反映耗费参数。
&&&

The Volcano/Cascades framework differs from Starburst in its
approach to enumeration: (a) These systems do not use two
distinct optimization phases because all transformations are
algebraic and cost-based. (b) The mapping from algebraic to
physical operators occurs in a single step. (c) Instead of applying
rules in a forward chaining fashion, as in the Starburst query
rewrite phase, Volcano/Cascades does goal-driven application of
rules.
&&&
Volcano/Cascades框架不同于Starburst是在于他的遍历方法：（a）这些系统不会使用两个完全不同的优化阶段因为所有的变换规则都是代数的和基于耗费的。（b）从代数到物理操作符的映射知道出现在一步中。（c）不同于Starburst查询重写阶段那样以一种向前链式的方法来应用规则，Volcano/Cascades使用目标驱动来应用规则。
&&&
